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

    );
endmodule
