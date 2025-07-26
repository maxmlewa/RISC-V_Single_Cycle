`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: rv32I_top
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Top level module for the RV32I single cycle processor
//              Implements the 5 stages in 1 cycle: Instruction fetch
//                  Decode, Execute, Memory Access and Writeback
//              Includes the 4 state elements and supporting architecture
// 
// Dependencies: pc.v           : program counter module
//               instr_memory.v : instruction memory (read only)
//               regfile.v      : integer register file (x0-x31)
//               data_memory.v  : data memory with byte/half/word support
//               control_unit.v : Main control logic
//               imm_gen.v      : Immediate Generator
//               alu.v          : Arithmetic Logic Unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rv32I_top(
    input wire clk, reset,
    input [3:0] io_in, // for future expansion and environment interaction
    output [7:0] debug_output
    );
    
    // synchronization of the reset signal
    // usefuleness depends on the origin of the reset signal
    reg reset_sync;
    always@(posedge clk)
        reset_sync <= reset;
    wire system_reset = reset_sync;
    
    
    // Instruction fields
    wire [31:0] curr_pc, pc_next, instr;
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [6:0] opcode = instr[6:0];    
    
    // Internal wires connecting modules
    wire [31:0] rd1, rd2, imm, alu_b, alu_out, mem_rdata, reg_wdata;
    wire [1:0] alu_op;
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, auipc;
    wire jal, jalr, lui, zero, take_branch;
        
    
    // Instantiation of the modules, positional port list
    // instance names uppercase, module names lowercase
    
    pc PC(
      .clk(clk),
      .reset(system_reset),
      .pc_next(pc_next),
      .curr_pc(curr_pc)
    );
    
    instr_memory IMEM(
        .instr(instr),
        .addr(curr_pc) 
    );
    
    control_unit CONTROL_UNIT(
        .opcode(opcode),
        .funct3(funct3),
        .alu_op(alu_op),
        .branch(branch), 
        .mem_read(mem_read), 
        .mem_to_reg(mem_to_reg), 
        .mem_write(mem_write), 
        .alu_src(alu_src), 
        .reg_write(reg_write), 
        .jal(jal), 
        .jalr(jalr), 
        .lui(lui),
        .auipc(auipc)  
    );
    
    imm_gen IMM_UNIT(
        .instr(instr),
        .imm(imm)
    );
    
    regfile RF(
        .clk(clk),
        .reset(system_reset),
        .we(reg_write),
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd),
        .wd(reg_wdata),
        .rd1(rd1), 
        .rd2(rd2)
    );
    
    alu ALU(
        .A(rd1),
        .B(alu_b),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .C(alu_out),
        .zero(zero)
    );
    
    data_memory DMEM(
        .clk(clk),
        .we(mem_write),
        .addr(alu_out),
        .din(rd2),
        .funct3(funct3),
        .dout(mem_rdata)
    );
    
    
    // alu operand selection mux
    assign alu_b = (alu_src)? imm : rd2;
    
    // write-back selection
    assign reg_wdata = (lui)        ? imm :
                       (auipc)      ? (curr_pc + imm) :
                       (jal | jalr) ? (curr_pc + 4) :
                       (mem_to_reg) ? mem_rdata :
                                      alu_out;
    
    // logic for branch and jump target operations
    assign take_branch = branch & (alu_out == 32'b1);
    
    assign pc_next = (jalr)        ? ((rd1 + imm) & ~32'd1) :
                     (jal)         ? (curr_pc + imm) :
                     (take_branch) ? (curr_pc + imm) :
                                     (curr_pc + 4);
                                     
    // debug output 
    assign debug_output = pc_next[7:0]; // Displaying the rd1 register value on LED for example
    
endmodule
