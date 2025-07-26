`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_rv32I_top
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Full system simulation for the RV32I single cycle processor
// 
// Dependencies: The rv32I_top module instantiated as the DUT
// Functionality tested: Instruction fetch and decode
//                       Register file, ALU, memory as the architectural state
//                       Program execution
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_rv32I_top( );
    
    // DUT input
    reg clk;
    reg reset;
    reg [3:0] io_in;
    
    // DUT output
    wire [7:0] debug_output;
    
    // Other testbench signals
    
    integer cycle;
    integer i; 
    
    // Instantiating the DUT
    rv32I_top DUT_RV32I_TOP(
        .clk(clk),
        .reset(reset),
        .io_in(io_in),
        .debug_output(debug_output)
    );
    
    wire pc = DUT_RV32I_TOP.curr_pc;
    // clock generation
    initial
        clk = 0;
    always 
        #5 clk = ~clk;
        
    // test sequence
    initial
    begin
        cycle = 0;
        $display("=== RV32I Top Tests ===");
        $display("Cycle \t|\t Time\t|\t PC \t|\t nextPC \t|\t A \t|\t B \t|\t C");
        
        // initial reset
        reset = 0;
        #5 reset = 1;
        #20 reset = 0;
        
        $display("\t\t[%0t] Reset deasserted\n", $time);
        
        // running for X cycles
        repeat (54)
        begin
            @(posedge clk);
            begin
                #6;
                cycle = cycle + 1;
                $display("%0d \t|\t %0t \t|\t 0x%08h \t|\t 0x%08h \t|\t \t|\t 0x%08h \t|\t 0x%08h \t|\t 0x%08h ",cycle ,$time ,DUT_RV32I_TOP.curr_pc , DUT_RV32I_TOP.pc_next, DUT_RV32I_TOP.ALU.A, DUT_RV32I_TOP.ALU.B, DUT_RV32I_TOP.ALU.C);
            end
        end
        
        // === Register File Dump ===
        $display("\n=== Register File Dump ===");
        for (i = 0; i < 32; i = i + 1)
        begin
            $display("x%0d = 0x%08h", i, DUT_RV32I_TOP.RF.regs[i]);
        end

        // === Top 10 Data Memory Dump ===
        $display("\n=== Top 10 Data Memory Words (0x00 - 0x24) ===");
        for (i = 0; i < 10; i = i + 1)
        begin
            $display("mem[0x%02h] = 0x%08h", i*4, DUT_RV32I_TOP.DMEM.mem[i]);
        end
        
        $display("=== RV32I Tests Done ===");
    
        $finish;
        
    end
    
    
    
endmodule
