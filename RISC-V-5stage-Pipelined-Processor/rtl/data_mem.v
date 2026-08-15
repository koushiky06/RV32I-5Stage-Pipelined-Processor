module Data_mem(clk,A,WE,WD,RD);
input clk,WE;
input [31:0] A,WD;

output [31:0] RD;

reg [31:0] data_mem[31:0];

integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            data_mem[i] = 32'h00000000;
        end
    end

always @(posedge clk)
begin
if(WE)
data_mem[A] <= WD;
end

assign RD = data_mem[A];

endmodule
