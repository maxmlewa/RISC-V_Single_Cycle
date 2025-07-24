`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_regfile
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the regfile module
// 
// Dependencies: regfile.v: regfile module as the DUT
// Functionality Tested: Combinational read
//               Synchronous writes
//               x0 hardwired to 0
//               Asynchronous reset signal
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_regfile( );

    // DUT inputs
    reg clk, reset, we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
       
    
    // DUT output
    wire [31:0] rd1, rd2;
    
    // variables
    integer local_error;
    integer i;
    integer j;
    
    // DUT instantiation
    regfile DUT_REGFILE(
        .clk(clk), .reset(reset), .we(we),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );
    
    // Clock generation block
    initial
        clk = 1'b0;
    always
        #5 clk = ~clk; // CLOCK PERIOD = 10 time units
    
    // Tasks for register file checking
    task check_registers; // check that all the registers hold the expected value
        input [31:0] expected_value;
        begin
            local_error = 0;
            for(i = 0; i < 32; i = i+1)
            begin
                rs1 = i;
                rs2 = i;
                #1;
                if((rd1 !== expected_value)||(rd2 !== expected_value))
                begin
                    local_error = 1;
                    $display("FAIL: Register x%0d value mismatch. Expected 0x%08h, got 0x%08h", i, expected_value, rd1);
                end
            end
            
            if(local_error == 0)
                $display("PASS: All registers match");
            else
                $display("FAIL: Register mismatch");
            
        end
    
    endtask
    
    
    // Test sequence
    reg [31:0] expected;
    
    initial
    begin
        $display("\n\n=== Register File Tests ===");
        
        // signal initializations
        reset = 0; we = 0; rd = 0; wd = 0; rs1 = 0; rs2 = 0;
        
        // Initial register file reset
        $display("\n-- Initial reset --");
        #7 reset = 1;
        #3 reset = 0;
        
        // verification of reset
        check_registers(32'h0);
        
        // writing values to all registers
        $display("\n--Writing to all registers--");
        for(j = 0; j < 32; j = j+1)
        begin
            we = 1;
            rd = j;
            wd = j*32'h11111111;
            #12;
        end
        we = 0;
        
        // verification of writing with combinational reads
        local_error = 0;
        for(j = 0; j < 32; j = j+1)
        begin
            rs1 = j;
            expected = j*32'h11111111;
            #1;
            if(rd1 !== expected)
            begin
                $display("x%0d | FAIL: : Expected 0x%08h, got 0x%08h", j, expected, rd1);
                local_error = local_error+1;
            end
        end
        if(local_error == 0)
            $display("PASS: All registers match! :)");
        else
            $display("FAIL: %d mismatches :(", local_error);
        
        // Reading of two registers consecutively
         $display("\n--Consecutive and combinational reads--");
        rs1 = 3;
        rs2 = 10;
        #1
        if((rd1 == 3* 32'h11111111) && (rd2 == 10*32'h11111111))
            $display("PASS");
        else
            $display("FAIL: : Expected [x%0d: 0x%08h , x%0d: 0x%08h], got [x%0d: 0x%08h , x%0d: 0x%08h]", rs1, 3*32'h11111111, rs2, 10*32'h11111111, rs1, rd1, rs2, rd2);
        
        
        // Verifying that x0 is logic 0 after writes
        $display("\n--Hardwiring of x0--");
        rd = 5'b0;
        we = 1'b1;
        wd = 32'hDEADBEEF;
        #12;
        rs1 = 0;
        #1;
        if(rd1 == 32'h0)
            $display("Test1: PASS");
        else
            $display("Test1: FAIL: : Expected 0x%08h, got 0x%08h", 32'h0, rd1);
            
            
        rd = 5'b0;
        we = 1'b1;
        wd = 32'hBEADBEAD;
        #12;
        rs2 = 0;
        #1;
        if(rd2 == 32'h0)
            $display("Test2: PASS");
        else
            $display("Test2: FAIL: : Expected 0x%08h, got 0x%08h", 32'h0, rd2);
        
        // Final register file reset
        $display("\n-- Final reset --");
        #7 reset = 1;
        #3 reset = 0;
        
        // verification of reset
        check_registers(32'h0);
        
        $display("=== Register File Tests Done ===\n\n");
        
        $finish;
         
    end
    
    
endmodule
