`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_pc
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the Program Counter (pc) module
// Functionality Tested: Reset behavior: curr_pc must be 0 after reset
//                       Sequential Updates: curr_pc must follow pc_next on each clock edge
// 
// Dependencies: pc.v - pc instantiated as the DUT
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_pc( );
    
    // DUT input
    reg clk_TB, reset_TB;
    reg [31:0] pc_next_TB;
    
    // DUT output
    wire [31:0] curr_pc_TB;
    
    // Instantiating the DUT
    pc DUT_PC(
                .clk(clk_TB),
                .reset(reset_TB),
                .pc_next(pc_next_TB),
                .curr_pc(curr_pc_TB)
              );
              
    // Clock generation block
    initial 
    begin
        clk_TB = 1'b0;
    end
    
    always
    begin
        #5 clk_TB = ~clk_TB;
    end  
    
    // Test sequences
    initial
    begin
        reset_TB = 0;
        pc_next_TB = 32'b0;
        
        $display("=== Program Counter Testbench ===");
        $write("\t\t\t\tTime\tReset\tPC_Next\tPC_Out\n");
        
        // Apply reset
        reset_TB = 1;
        pc_next_TB = 32'hDEADBEEF;
        #1
        //test that it is asynchronous
        $write("%4t\t%b\t%h\t%h\t", $time, reset_TB, pc_next_TB, curr_pc_TB);
        if (curr_pc_TB == 0)
            $display("PASS: Reset successful");
        else
            $display("FAIL: Asynchronous Reset Failed");
        reset_TB = 0;
        
        // check update
        #9
        $write("%4t\t%b\t%h\t%h\t", $time, reset_TB, pc_next_TB, curr_pc_TB);
        if (curr_pc_TB == pc_next_TB)
            $display("PASS: Update 0 successful");
        else
            $display("FAIL: Update 0 Failed");
        reset_TB = 0;
        
        // random update tests
        repeat (4)
        begin
            pc_next_TB = $random;
            #10;
            $write("%4t\t%b\t%h\t%h\t", $time, reset_TB, pc_next_TB, curr_pc_TB);
            if (curr_pc_TB == pc_next_TB)
                $display("PASS");
            else
                $display("FAIL: PC did not update to nextPC");
           
        end
        
        // Testing edge cases
        pc_next_TB = 32'hFFFFFFFF;
        #10
        $write("%4t\t%b\t%h\t%h\t", $time, reset_TB, pc_next_TB, curr_pc_TB);
        if (curr_pc_TB == pc_next_TB)
            $display("PASS");
        else
            $display("FAIL: Max 32-bit PC value");
            
        pc_next_TB = 32'h00000000;
        #10
        $write("%4t\t%b\t%h\t%h\t", $time, reset_TB, pc_next_TB, curr_pc_TB);
        if (curr_pc_TB == pc_next_TB)
            $display("PASS");
        else
            $display("FAIL: Min 32-bit PC value, 0");
            
        $display("=== End of PC test ===");
        
        $finish; 
        
    end        
    
endmodule
