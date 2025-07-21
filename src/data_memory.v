`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: data_memory
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Data Memory for the Single Cycle microarchitecture of the RV32I architecture
//              Has added halfword and byte support 
//              Synchronous writes and asynchronous reads
// Dependencies: No defined module instantiated
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_memory(
    input wire clk, we,
    input wire [31:0] addr, din,
    input wire [2:0] funct3,
    output reg [31:0] dout
    );
    // declaring the memory array and the relevant signals
    reg [31:0] mem [0:1023]; //1024x32 = 4kB, change to match target device resources
    wire [9:0] waddr = addr[11:2]; // word aligned address
    wire [1:0] byte_sel = addr[1:0];
    
    // synchronous writes
    always@(posedge clk)
    begin
        if(we)
        begin
            case(funct3)
                3'b010: mem[waddr] <= din; // SW
                3'b001: begin // SH
                            case(byte_sel[1])
                                1'b0: mem[waddr][15:0]<= din[15:0];
                                1'b1: mem[waddr][31:16]<= din[15:0];
                            endcase
                            
                        end 
                3'b000: begin // SB
                            case(byte_sel)
                                2'b00: mem[waddr][7:0]<= din[7:0];
                                2'b01: mem[waddr][15:8]<= din[7:0];
                                2'b10: mem[waddr][23:16]<= din[7:0];
                                2'b11: mem[waddr][31:24]<= din[7:0];
                            endcase
                        end
            endcase
        end
    end
    
    
    // combinational read
    always@*
    begin
        case(funct3)
            3'b000: begin //LB
                        case(byte_sel) // make sure to use the sign extended versions of the bytes
                            2'b00: dout = {{24{mem[waddr][7]}}, mem[waddr][7:0]};
                            2'b01: dout = {{24{mem[waddr][15]}}, mem[waddr][15:8]};
                            2'b10: dout = {{24{mem[waddr][23]}}, mem[waddr][23:16]};
                            2'b11: dout = {{24{mem[waddr][31]}}, mem[waddr][31:24]};
                        endcase
                    end
            3'b001: begin //LH
                        if (byte_sel[1] == 1'b1)
                            dout = {{16{mem[waddr][31]}}, mem[waddr][31:15]};
                        else
                            dout = {{16{mem[waddr][15]}}, mem[waddr][15:0]};
                    end
            3'b010: dout = mem[waddr]; //LW
            3'b100: begin//LBU
                        case(byte_sel) // make sure to use the sign extended versions of the bytes
                            2'b00: dout = {24'b0, mem[waddr][7:0]};
                            2'b01: dout = {24'b0, mem[waddr][15:8]};
                            2'b10: dout = {24'b0, mem[waddr][23:16]};
                            2'b11: dout = {24'b0, mem[waddr][31:24]};
                        endcase
                    end
            3'b101: begin //LHU
                        if (byte_sel[1] == 1'b1)
                            dout = {16'b0, mem[waddr][31:15]};
                        else
                            dout = {16'b0, mem[waddr][15:0]};
                    end
            default: dout = 32'bx; // maintain the coombinational logic
        endcase
    end                   
endmodule
