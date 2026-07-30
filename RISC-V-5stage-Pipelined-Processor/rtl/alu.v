module alu (
input [31:0] A,
input [31:0] B,
input [2:0] ALUcontrol,

output zero,
output reg [31:0] Result
);

always @(*)
begin

    case(ALUcontrol)

    3'b000: Result = A + B;                       // ADD
    3'b001: Result = A - B;                       // SUB
    3'b010: Result = A & B;                       // AND
    3'b011: Result = A | B;                       // OR
    3'b100: Result = A ^ B;                       // XOR
    3'b101: Result = (A < B) ? 32'b1 : 32'b0;    // SLT
    3'b110: Result = A << B[4:0];                // SLL
    3'b111: Result = A >> B[4:0];                // SRL

    default: Result = 32'b0;

    endcase

end

assign zero = (Result == 32'b0);

endmodule