module instr_mem(
    input rst,
    input [31:0] A,
    output [31:0] RD
);

    
    reg [31:0] mem [0:31];

    initial begin
        $readmemh("memfile.hex", mem);
    end
    assign RD = (rst) ? 32'h00000000 : mem[A[6:2]];

endmodule
