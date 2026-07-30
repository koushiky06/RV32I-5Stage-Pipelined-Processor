module pipeline_2_tb();
    reg clk = 0;
    reg rst;
    
    // Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // 1. Assert Reset active high at start
        rst = 1'b1;
        #20;            // Hold reset for 50 ns (5 full clock cycles)
        
        // 2. Deassert Reset so the processor starts running code
        rst = 1'b0;
        
        // 3. Let simulation run for instructions to execute
        #2000;
        $finish;    
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

    pipeline_top dut (
        .clk(clk), 
        .rst(rst)
    );
    initial begin
    $display("Simulator Working Directory path check:");
    $system("pwd"); // Works on Linux / macOS / EDA Playground / Icarus Verilog
    // $system("cd"); // Use this line instead if you are running on Windows CMD
    end
endmodule
