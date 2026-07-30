module PC_Module(clk,rst,PC,PC_next);
input clk;
input rst;
input [31:0] PC_next;
output [31:0] PC;
reg [31:0] PC;

always @(posedge clk)
begin
if(rst==1'b1)
PC <= 32'b0;
else
PC <= PC_next;
end
endmodule
