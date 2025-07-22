`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: control_unit
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Main control logic for RV32I
//              Decodes the opcode (and funct3 for the memory access width)
//              Generates the control signals for the datapath component
// 
// Dependencies: None, pure standalone
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
    input wire [6:0] opcode,
    input wire [2:0] funct3, // left for future expansion
    output reg [1:0] alu_op,
    output reg branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jal, jalr, lui
    );
    
    always@*
    begin   // Safe default values for NOP
        branch = 1'b0;      // High for conditional branches
        mem_read = 1'b0;    // Enables memory read
        mem_to_reg = 1'b0;  // Selects the data memory output for register writeback
        mem_write = 1'b0;   // Enables memory write
        alu_src = 1'b0;     // Selects between the immediate(1) and register(0) for second alu input
        reg_write = 1'b0;   // Enables register file writeback
        jal = 1'b0;         // High for JAL
        jalr = 1'b0;        // High for JALR
        lui = 1'b0;         // High for LUI
        alu_op = 2'b00;     // 2 bit alu operation selector: 00: ADD, 01: SUB, 10: R-Type and I-Type
        
        case(opcode)
            7'b0110011: begin // R type
                            // alu src remains 0
                            reg_write = 1'b1;
                            alu_op = 2'b10; // will be using funct3/funct7 for decoding
                        end
                        
            7'b0010011: begin // I type
                            alu_src = 1'b1;
                            reg_write = 1'b1;
                            alu_op = 2'b10;
                        end

            7'b00000111: begin // Load
                            // alu_op remains ADD for address calculation
                            alu_src = 1'b1;
                            mem_read = 1'b1;
                            mem_to_reg = 1'b1;
                            reg_write = 1'b1;
                        end   
                        
            7'b0100011: begin // Store
                            alu_src = 1'b1;
                            mem_write = 1'b1;
                        end 
                        
            7'b1100011: begin // Branch
                            branch = 1'b1;
                            alu_op = 2'b01; // SUB for comparison
                        end 
                        
            7'b1101111: begin // JAL
                            jal = 1'b1;
                            reg_write = 1'b1; // to rd
                        end   
                        
            7'b1100111: begin // JALR
                            jalr = 1'b1;
                            reg_write = 1'b1;
                            alu_src = 1'b1;
                        end  
                        
            7'b0110111: begin // LUI
                            lui = 1'b1;
                            reg_write = 1'b1;
                        end         
                        
            7'b0010111: begin // AUIPC
                            reg_write = 1'b1;
                            alu_src = 1'b1;
                        end
                 
            default : begin
                        // Invalid/unknown opcode: control signals stay at default
                      end                                                                                                                                                                
            
        endcase
    end
endmodule
