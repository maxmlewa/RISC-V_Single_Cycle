`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: testbench_imm_gen
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the imm_gen module
// Functionality tested: Correct immediate generation for I, S, B, U, J types
//                       Sign extension of negative immediates
// 
// Dependencies: imm_gen.v : imm_gen instantiated as DUT
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_imm_gen( );

    // DUT input
    reg [31:0] instr;
    // DUT output
    wire [31:0] imm_out;
    
    // instantiate DUT
    imm_gen DUT_IMM_GEN(
        .instr(instr),
        .imm(imm_out)
    );
    
    // Task for single immediate case
    task test_imm;
        input[31:0] test_instr;
        input[31:0] expected_imm;
        
        begin
            instr = test_instr;
            #1;
            $write("%4t |\t %08h |\t %08h |\t %08h | ", $time, instr, expected_imm, imm_out );
            if (imm_out == expected_imm)
                $display("PASS");
            else
                $display("FAIL");
        end
    endtask
    
    // Test sequence
    initial
    begin
        $display("=== Immediate Generator Testbench ===");
        $display("Time | Instruction | Imm_Out | Expected | Result");
        $display("----------------------------------------------------");
        
        // I-type: addi x1, x2, -5 (imm = 0xFFFFFFFB)
        test_imm(32'hFFB1_0093, 32'hFFFF_FFFB);
        
        // S-type: sw x1, 12(x2) (imm = 0x0000000C)
        test_imm(32'h0011_2623, 32'h0000_000C);
        
        // B-type: beq x1, x2, -4 (imm = 0xFFFFFFFC)
        test_imm(32'hFE20_8EE3, 32'hFFFF_FFFC);
        
        // U-type: lui x1, 0x12345 (imm = 0x12345000)
        test_imm(32'h12345_0B7, 32'h1234_5000);
        
        // J-type: jal x1, 0x00000010 (imm = 0x00000010) 
        test_imm(32'h0100_00EF, 32'h0000_0010);
        
        $display("=== End Immediate Generator Tests ===");
        $finish;    
    end
endmodule
