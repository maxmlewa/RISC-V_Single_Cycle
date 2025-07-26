`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Performs arithmetic and logic operations for RV32I
//              Supports operations based on the ALU control input 
// 
// Dependencies: No internal dependencies, standalone logic unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input wire [31:0] A,B,
    input wire [6:0] funct7,
    input wire [2:0] funct3,
    input wire [1:0] alu_op,
    output reg [31:0] C,
    output wire zero // High if the result is zero,
                    // support  branch decisions, borrowed from x86 ZF(Zero Flag)
    );
    
    // signal declarations
    wire [4:0] shamt = B[4:0];
    wire signed [31:0] A_s = A;
    wire signed [31:0] B_s = B;
    
    // SRA to escape the mux errors
    wire signed [31:0] SRA = A_s >>> shamt;
    

    
    
    // ALU component
    always@*
    begin
        // signal assignments
        case(alu_op)
            2'b00: C = A + B; // Supports the address manipulation: Load, Store, AUIPC
            2'b01: begin
                    // Branch comparison logic; currently makes use of the zero flag
                    // will be minimised in later developments
                    case(funct3)
                        3'b000: C = (A == B);
                        3'b001: C = (A != B);
                        3'b100: C = (A_s < B_s);
                        3'b101: C = (A_s >= B_s);
                        3'b110: C = (A < B); // unsigned
                        3'b111: C = (A >= B); // unsigned
                        default: C = 32'bx;    
                    endcase
                   end
            2'b10: begin
                    case(funct3)
                        3'b000: C = (funct7[5]) ? (A_s - B_s) : (A_s + B_s);                // SUB, ADD
                        3'b001: C = A << shamt;                                     // SLL, SLLI
                        3'b010: C = (A_s < B_s) ? 1 : 0;                            // SLT, SLTI
                        3'b011: C = (A < B) ? 1 : 0;                                // SLTU, SLTIU
                        3'b100: C = A ^ B;                                          // XOR, XORI
                        3'b101: C = (funct7[5]) ? SRA :(A >> shamt);     // SRA, SRAI ; SRL, SRLI
                        3'b110: C = A | B;                                          // OR, ORI
                        3'b111: C = A & B;                                          // AND, ANDI
                        default: C = 32'bx;                                         // for uknown and floating signals
                    endcase
                   end
            default: C = 32'bx;
        endcase
    end
    
    assign zero = (C == 32'b0);
endmodule
