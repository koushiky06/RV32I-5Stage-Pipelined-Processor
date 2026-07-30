module Main_Decoder(Opcode,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp);
input [6:0]Opcode;
output RegWrite,MemWrite,ResultSrc,Branch,ALUSrc;
output [1:0] ImmSrc;
output [1:0]ALUOp;

assign RegWrite = (Opcode == 7'b0000011 | Opcode == 7'b0110011 | Opcode == 7'b0010011 ) ? 1'b1 :1'b0 ;
assign ImmSrc = (Opcode == 7'b0100011) ? 2'b01 : (Opcode == 7'b1100011) ? 2'b10 : 2'b00 ;
assign ALUSrc = (Opcode == 7'b0000011 | Opcode == 7'b0100011 | Opcode == 7'b0010011) ? 1'b1 : 1'b0 ;
assign MemWrite = (Opcode == 7'b0100011) ? 1'b1 : 1'b0 ;
assign ResultSrc = (Opcode == 7'b0000011) ? 1'b1 : 1'b0 ;
assign Branch = (Opcode == 7'b1100011) ? 1'b1 : 1'b0 ;
assign ALUOp = (Opcode == 7'b0110011) ? 2'b10 : (Opcode == 7'b1100011) ? 2'b01 : 2'b00 ;

endmodule