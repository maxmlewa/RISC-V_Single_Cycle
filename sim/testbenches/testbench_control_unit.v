`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_control_unit
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the control_unit module
// 
// Dependencies: control_unit.v: control_unit module instantiated as the DUT
// Functionality tested: Signal generation for each opcode
//                       ALU opcode assignment
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_control_unit( );

    // DUT input
    reg[6:0] opcode;
    reg [2:0] funct3;
    
    // DUT output
    wire branch, mem_read, mem_to_reg, mem_write;
    wire alu_src, reg_write, jal, jalr, lui;
    wire [1:0] alu_op;
    
    integer errors = 0;
    
    // Instantiate DUT
    control_unit DUT_CONTROL_UNIT(
        .opcode(opcode),
        .funct3(funct3),
        .alu_op(alu_op),
        .branch(branch), .mem_read(mem_read), .mem_to_reg(mem_to_reg), .mem_write(mem_write), 
        .alu_src(alu_src), .reg_write(reg_write), .jal(jal), .jalr(jalr), .lui(lui)
    );
    
    // Task for a single test case
    task test_control_unit;
        input [6:0] t_opcode;
        input [12*8:1] instr_label;
        input exp_branch, exp_mem_read, exp_mem_to_reg;
        input exp_mem_write, exp_alu_src, exp_reg_write;
        input [1:0] exp_alu_op;
        input exp_jal, exp_jalr, exp_lui;
        
        reg local_error;

        begin
            opcode = t_opcode;
            #1;
            
            local_error = 1'b0;
            $write("%-8s | ", instr_label);

            if (branch     !== exp_branch     ) begin $write("branch FAIL, ");     errors = errors + 1; local_error = 1; end
            if (mem_read   !== exp_mem_read   ) begin $write("mem_read FAIL, ");   errors = errors + 1; local_error = 1; end
            if (mem_to_reg !== exp_mem_to_reg ) begin $write("mem_to_reg FAIL, "); errors = errors + 1; local_error = 1; end
            if (mem_write  !== exp_mem_write  ) begin $write("mem_write FAIL, ");  errors = errors + 1; local_error = 1; end
            if (alu_src    !== exp_alu_src    ) begin $write("alu_src FAIL, ");    errors = errors + 1; local_error = 1; end
            if (reg_write  !== exp_reg_write  ) begin $write("reg_write FAIL, ");  errors = errors + 1; local_error = 1; end
            if (alu_op     !== exp_alu_op     ) begin $write("alu_op FAIL, ");     errors = errors + 1; local_error = 1; end
            if (jal        !== exp_jal        ) begin $write("jal FAIL, ");        errors = errors + 1; local_error = 1; end
            if (jalr       !== exp_jalr       ) begin $write("jalr FAIL, ");       errors = errors + 1; local_error = 1; end
            if (lui        !== exp_lui        ) begin $write("lui FAIL, ");        errors = errors + 1; local_error = 1; end

            if (local_error == 1'b0) 
                $display("PASS");
            else            
                $display("FAILED");
        end
    endtask

    initial begin
        $display("=== Control Unit Testbench ===");

        //                  opcode     label      br,  mr,  m2r, mw,  asrc, regw,  aop,  jal, jlr, lui
        test_control_unit(7'b0110011, "R-type ",   0,   0,   0,   0,    0,    1,   2'b10, 0,   0,   0);
        test_control_unit(7'b0010011, "I-type ",   0,   0,   0,   0,    1,    1,   2'b10, 0,   0,   0);
        test_control_unit(7'b0000011, "Load   ",   0,   1,   1,   0,    1,    1,   2'b00, 0,   0,   0);
        test_control_unit(7'b0100011, "Store  ",   0,   0,   0,   1,    1,    0,   2'b00, 0,   0,   0);
        test_control_unit(7'b1100011, "Branch ",   1,   0,   0,   0,    0,    0,   2'b01, 0,   0,   0);
        test_control_unit(7'b1101111, "JAL    ",   0,   0,   0,   0,    0,    1,   2'b00, 1,   0,   0);
        test_control_unit(7'b1100111, "JALR   ",   0,   0,   0,   0,    1,    1,   2'b00, 0,   1,   0);
        test_control_unit(7'b0110111, "LUI    ",   0,   0,   0,   0,    0,    1,   2'b00, 0,   0,   1);
        test_control_unit(7'b0010111, "AUIPC  ",   0,   0,   0,   0,    1,    1,   2'b00, 0,   0,   0);
        
        
        // some invalid opcodes: not exhaustive
        test_control_unit(7'b0000000, "INVALID  ",   0,   0,   0,   0,    0,    0,   2'b00, 0,   0,   0);
        test_control_unit(7'b1111111, "INVALID  ",   0,   0,   0,   0,    0,    0,   2'b00, 0,   0,   0);
        test_control_unit(7'b1010101, "INVALID  ",   0,   0,   0,   0,    0,    0,   2'b00, 0,   0,   0);
        test_control_unit(7'b0101010, "INVALID  ",   0,   0,   0,   0,    0,    0,   2'b00, 0,   0,   0);


        $display("\n=== Test Summary ===");
        if (errors == 0)
            $display("All tests passed!");
        else
            $display("Total errors: %0d", errors);

        $finish;
    end
endmodule
