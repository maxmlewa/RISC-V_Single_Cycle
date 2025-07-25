`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_instr_memory
// Project Name: Single Cycle Processot
// Target Devices: XXXX
// Description: Unit testbench for the instr_memory module
// 
// Dependencies: instr_memory.v: instr_memory module instantiated as the DUT
// Functionality tested: Combinational Memory read: Correct instruction fetch procedure
//                       Address Handling: word aligned access
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_instr_memory( );
    
    // DUT input
    reg [31:0] addr;
    
    // DUT output
    wire [31:0] instr;
    
    // internal variables
    reg [31:0] expected_instr;
    integer errors;
    
    // instantiating the instr_mem as the DUT 
    instr_memory DUT_INSTR_MEMORY(
        .addr(addr),
        .instr(instr)
    );
    
    // Task for testing a single address access
    task test_addr;
        input [31:0] address;
        input [31:0] expected;
        input [31:0] instr_number;
        
        begin
            errors = 0;
            addr = address;
            expected_instr = expected;
            #1; // allow for propagation
            if (instr !== expected_instr)
            begin
                $display("FAIL | (instr %0d) expected: 0x%08h\t got: 0x%08h", instr_number, expected_instr, instr);
                errors = errors+1;
            end
            else
                $display("PASS | (instr %0d)", instr_number);  
        end
  
    endtask
    
    // Test sequence
    initial
    begin
        $display("\n\n=== Instruction Memory Tests ===");
        
        test_addr(32'h00000000, 32'h00100093, 1);
        test_addr(32'h00000004, 32'h00200113, 2);
        test_addr(32'h00000008, 32'h002081b3, 3);
        test_addr(32'h0000000C, 32'h40110233, 4);
        test_addr(32'h00000010, 32'h0011f2b3, 5);
        test_addr(32'h00000014, 32'h0011e333, 6);
        test_addr(32'h00000018, 32'h0011c3b3, 7);
        test_addr(32'h0000001C, 32'h00209433, 8);
        test_addr(32'h00000064, 32'h00380813, 9);
        test_addr(32'h00000068, 32'hf9dfffef, 10);
        test_addr(32'h0000006C, 32'h00800f67, 11);
        test_addr(32'h000000C8, 32'bx, 12); // out of bounds
        test_addr(32'h000000CC, 32'bx, 13); // out of bounds
        test_addr(32'h000000DC, 32'bx, 14); // out of bounds
        test_addr(32'h000000FF, 32'bx, 15); // out of bounds
        test_addr(32'h00000000, 32'h00100093, 16); // wrap around
        test_addr(32'hFF000004, 32'h00200113, 17); // wrap around
        test_addr(32'hCCC00008, 32'h002081b3, 18); // wrap around
        test_addr(32'h2200000C, 32'h40110233, 19); // wrap around
        test_addr(32'hCC000010, 32'h0011f2b3, 20); // wrap around
        
        
        if (errors == 0)
            $display("PASS! :)");
        else
            $display("FAIL :(");
        
        $display("=== Test Complete With %0d errors.====\n\n", errors);
        $finish;
        
    end
    
endmodule
