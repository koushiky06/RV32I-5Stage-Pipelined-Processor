module reg_file(clk,rst,WE3,A1,A2,A3,WD3,RD1,RD2);
input clk,rst,WE3;
input [4:0] A1;
input [4:0] A2;
input [4:0] A3;
input [31:0]WD3;
output [31:0] RD1;
output [31:0] RD2;

reg [31:0] registers [31:0];

integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'h00000000;
    end

always @(posedge clk)
begin
if(WE3 & (A3 != 5'h00))
registers[A3] <= WD3;
end

assign RD1 = (rst == 1'b1)? 32'b0 : registers[A1];
assign RD2 = (rst == 1'b1)? 32'b0 : registers[A2];

endmodule
