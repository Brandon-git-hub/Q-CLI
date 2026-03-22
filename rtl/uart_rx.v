module uart_rx #(
    parameter CLKS_PER_BIT = 434
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_ready
);

    localparam s_IDLE  = 3'b000;
    localparam s_START = 3'b001;
    localparam s_DATA  = 3'b010;
    localparam s_STOP  = 3'b011;

    reg [2:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] rx_data_reg;

    // 防止 Metastability
    reg rx_r1, rx_r2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_r1 <= 1'b1;
            rx_r2 <= 1'b1;
        end else begin
            rx_r1 <= rx;
            rx_r2 <= rx_r1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= s_IDLE;
            rx_ready <= 1'b0;
            rx_data <= 0;
            clk_count <= 0;
            bit_index <= 0;
            rx_data_reg <= 0;
        end else begin
            case (state)
                s_IDLE: begin
                    rx_ready <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;
                    if (rx_r2 == 1'b0) begin // 偵測到 Start bit
                        state <= s_START;
                    end
                end
                s_START: begin
                    // 在 Bit 中間取樣
                    if (clk_count == (CLKS_PER_BIT - 1) / 2) begin
                        if (rx_r2 == 1'b0) begin
                            clk_count <= 0;
                            state <= s_DATA;
                        end else begin
                            state <= s_IDLE;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end
                s_DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        rx_data_reg[bit_index] <= rx_r2;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= s_STOP;
                        end
                    end
                end
                s_STOP: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        rx_ready <= 1'b1;
                        rx_data <= rx_data_reg;
                        state <= s_IDLE;
                    end
                end
                default: state <= s_IDLE;
            endcase
        end
    end
endmodule
