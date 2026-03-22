module gpio_bit_bang (
    input  wire       clk,
    input  wire       rst_n,
    
    // 控制介面
    input  wire       bang_start,
    input  wire [2:0] bang_data_in, 
    
    // 實體腳位輸出 (pa3, pa4, pa6)
    output reg        pa3,
    output reg        pa4,
    output reg        pa6
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pa3 <= 1'b0;
            pa4 <= 1'b0;
            pa6 <= 1'b0;
        end else if (bang_start) begin
            pa3 <= bang_data_in[0];
            pa4 <= bang_data_in[1];
            pa6 <= bang_data_in[2];
        end
    end
endmodule
