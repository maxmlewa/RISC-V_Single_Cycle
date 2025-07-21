`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Module Name: pc
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Points to the current instruction being executed
// 
// Dependencies: No defined module instantiated
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input wire clk, reset,
    input wire [31:0] pc_next,
    output reg [31:0] pc
    );
    always @(posedge clk or posedge reset) // the PC reset is active HIGH and asynchronous
        begin
            if(reset)
                pc <= 0;
            else
                pc <= pc_next;
            end
endmodule
