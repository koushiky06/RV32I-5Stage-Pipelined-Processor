module instr_mem(
    input rst,
    input [31:0] A,
    output [31:0] RD
);

    // 32 words of 32-bit instructions (addresses 0 to 31)
    reg [31:0] mem [0:31];

    initial begin
        // Make sure memfile.hex is in your simulator execution directory
        $readmemh("memfile.hex", mem);
    end

    // Index using A[6:2] to map byte addresses (0, 4, 8, 12...) to word indices (0, 1, 2, 3...)
    assign RD = (rst) ? 32'h00000000 : mem[A[6:2]];

endmodule