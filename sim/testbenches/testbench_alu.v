`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_alu
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the alu module
// 
// Dependencies: alu.v: alu module instantiated as the DUT
// Functionality tested: ADD, SUB, SLT, SLTU, AND, OR, XOR, SLL, SRL, SRA
//                       Proper ALU control signal decoding from instruction fields
//                       Zero output flag for branch comparisons
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_alu( );
    
    // DUT input
    reg [31:0] A,B;
    reg [6:0] funct7;
    reg [2:0] funct3;
    reg [1:0] alu_op;
    
    // DUT output
    wire [31:0] C;
    wire zero;
    
    
    // Variables: error counter
    integer errors = 0;
    
    // Instantiating the DUT
    alu DUT_ALU(
        .A(A) ,.B(B),
        .funct7(funct7),
        .funct3(funct3),
        .alu_op(alu_op),
        .C(C),
        .zero(zero)
    );
    
    // Task for a single ALU test case
    task test_alu;
        input [31:0] A_t,B_t;
        input [6:0] funct7_t;
        input [2:0] funct3_t;
        input [1:0] alu_op_t;
        input [31:0] C_expected;
        input zero_expected;
        input [14*8:1] label;
        
        reg local_error;
        
        begin
            A = A_t;
            B = B_t;
            funct7 = funct7_t;
            funct3 = funct3_t;
            alu_op = alu_op_t;
            
            #1;
            
            local_error = 0;
            $write("%-12s | ", label);
            
            if(C !== C_expected)
            begin
                $write("FAIL C: expected: %h,\t got: %h\t", C_expected, C);
                errors = errors + 1;
                local_error = 1'b1;
            end
            
            if(zero !== zero_expected)
            begin
                $write("FAIL zero: expected: %b,\t got: %b\t", zero_expected, zero);
                errors = errors + 1;
                local_error = 1'b1;
            end
            
            if (local_error == 1'b0)
                $display("PASS");
            else
                $display("FAIL");
  
        end
        
    endtask
    
    
    // Test sequence
    initial
    begin
        $display("\n\n=== ALU Testbench ===");
        
        // op 00: address addition
        test_alu(32'd5, 32'd3, 7'b0, 3'b0, 2'b0, 32'd8, 0, "ADD (op 00)");
        
        // op 01: subtraction
        test_alu(32'd7, 32'd2, 7'b0, 3'b0, 2'b01, 32'd5, 0, "SUB (op 01)");
        
        // op 10: full set of ALU operations
        test_alu(32'd10, 32'd5, 7'b0000000, 3'b000, 2'b10, 32'd15, 0, "ADD");
        test_alu(32'd10, 32'd5, 7'b0100000, 3'b000, 2'b10, 32'd5, 0, "SUB");
        test_alu(32'h00000001, 32'd3, 7'b0000000, 3'b001, 2'b10, 32'd8, 0, "SLL");
        test_alu(-32'sd5, 32'sd2, 7'b0, 3'b010, 2'b10, 32'd1, 0, "SLT(less)");
        test_alu(32'd5, 32'd5, 7'b0, 3'b010, 2'b10, 32'd0, 1, "SLT (equal)");
        test_alu(32'sd5, 32'sd2, 7'b0, 3'b010, 2'b10, 32'd0, 1, "SLT(greater)");
        test_alu(32'd100, 32'd101, 7'b0, 3'b011, 2'b10, 32'd1, 0, "SLTU(less)");
        test_alu(-32'sd100, 32'hFFFFFF9C, 7'b0, 3'b011, 2'b10, 32'd0, 1, "SLTU(equal)");
        test_alu(-32'sd100, 32'd100, 7'b0, 3'b011, 2'b10, 32'd0, 1, "SLTU(greater)");
        test_alu(32'hF0F0F0F0, 32'h0F0F0F0F, 7'b0, 3'b100, 2'b10, 32'hFFFFFFFF, 0, "XOR");
        test_alu(32'h80000000, 32'd2, 7'b0000000, 3'b101, 2'b10, 32'h20000000, 0, "SRL");
        test_alu(32'h80000000, 32'd2, 7'b0100000, 3'b101, 2'b10, 32'hE0000000, 0, "SRA");
        test_alu(32'h0F0F0000, 32'h0000F0F0, 7'b0000000, 3'b110, 2'b10, 32'h0F0FF0F0, 0, "OR");
        test_alu(32'hFF00FF00, 32'h0F0F0F0F, 7'b0000000, 3'b111, 2'b10, 32'h0F000F00, 0, "AND");
    
        // zero result
        test_alu(32'd5, 32'd5, 7'b0000000, 3'b000, 2'b01, 32'd0, 1, "ZERO SUB");
        
        // Summary
        $display("\n=== ALU Test Summary ===");
        if (errors ==0)
            $display("All tests passed!\n\n");
        else
            $display("Total errors: %0d\n\n", errors);
            
        $finish;
   
    end
    
    
    
    
endmodule
