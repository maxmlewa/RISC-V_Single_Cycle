`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: imm_gen
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Immediate Generator for RV32I instructions
//              Extracts and sign-extends immediate fields from 32 bit instruction
//              Operation based on the instruction format: I, S, B, U, J
// 
// Dependencies: None, pure standalone module
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module imm_gen(
    input wire [31:0] instr,
    output reg [31:0] imm
    );
    
    wire [6:0] opcode = instr[6:0];
    
    always@*
    begin
        case(opcode)
            7'b0010011, 7'b0000011, 7'b1100111: imm = {{20{instr[31]}}, instr[31:20]}; // I-Type instruction
            7'b0100011:                         imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-Type instruction
            7'b1100011:                         imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-Type instruction
            7'b1101111:                         imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-Type instruction
            7'b0110111, 7'b0010111:             imm = {instr[31:12], 12'b0}; // U-Type instruction
            default :                           imm = 32'b0;                           //maintain the combinational logic 
        endcase
    end
endmodule
