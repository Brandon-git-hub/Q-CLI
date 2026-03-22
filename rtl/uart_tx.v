module uart_tx #(
    parameter CLKS_PER_BIT = 434
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output reg        tx,
    output reg        tx_busy
);

    localparam s_IDLE  = 3'b000;
    localparam s_START = 3'b001;
    localparam s_DATA  = 3'b010;
    localparam s_STOP  = 3'b011;

    reg [2:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] tx_data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= s_IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
            tx_data_reg <= 0;
        end else begin
            case (state)
                s_IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;
                    if (tx_start) begin
                        tx_busy <= 1'b1;
                        tx_data_reg <= tx_data;
                        state <= s_START;
                    end
                end
                s_START: begin
                    tx <= 1'b0;
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state <= s_DATA;
                    end
                end
                s_DATA: begin
                    tx <= tx_data_reg[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= s_STOP;
                        end
                    end
                end
                s_STOP: begin
                    tx <= 1'b1;
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        tx_busy <= 1'b0;
                        state <= s_IDLE;
                    end
                end
                default: state <= s_IDLE;
            endcase
        end
    end
endmodule
