module fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input  wire                  clk,
    input  wire                  rst_n,

    // Write Port
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,

    // Read Port
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty
);

    // Function to calculate the address width needed to represent FIFO_DEPTH
    function integer clog2;
        input integer value;
        begin
            value = value - 1;
            for (clog2 = 0; value > 0; clog2 = clog2 + 1)
                value = value >> 1;
        end
    endfunction

    localparam ADDR_WIDTH = clog2(FIFO_DEPTH);

    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    reg [ADDR_WIDTH:0]   wr_ptr;
    reg [ADDR_WIDTH:0]   rd_ptr;
    reg [ADDR_WIDTH+1:0] count;

    assign full = (count == FIFO_DEPTH);
    assign empty = (count == 0);
    assign rd_data = mem[rd_ptr];

    // Write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            if (wr_ptr == FIFO_DEPTH - 1) begin
                wr_ptr <= 0;
            end else begin
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    // Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (rd_en && !empty) begin
            if (rd_ptr == FIFO_DEPTH - 1) begin
                rd_ptr <= 0;
            end else begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

    // Counter logic to track the number of items in the FIFO
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            if (wr_en && !full && !(rd_en && !empty)) begin
                count <= count + 1;
            end else if (!(wr_en && !full) && rd_en && !empty) begin
                count <= count - 1;
            end
        end
    end

endmodule
