module control_unit_top(Opcode,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,funct3,funct7,ALUControl);

input [6:0]Opcode;
input [2:0] funct3;
input [6:0] funct7;
output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
output [1:0] ImmSrc;
output [2:0] ALUControl;

   Main_Decoder Main_Decoder(
                .Opcode(Opcode),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp)
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .op(Opcode),
                            .ALUControl(ALUControl)
    );
endmodule
