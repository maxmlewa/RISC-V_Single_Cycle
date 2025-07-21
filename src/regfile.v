`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: regfile
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Register File for RV321
//              2 read ports and 1 write port
//              Synchronous write on rising clock edge and asynchronous reads
//              Asynchronous active HIGH reset
// 
// Dependencies: None, pure standalone
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input wire clk, reset, we,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] wd,
    output wire [31:0] rd1, rd2
    );
    reg [31:0] regs [31:0]; // 32 registers x0 to x31
    
    // combinational reads
    assign rd1 = regs[rs1];
    assign rd2 = regs[rs2];
    
    initial
        regs[0] = 32'b0; // hardcode x0 to 0
        
    integer i; // to be used in the reset for loop  
    
    always@(posedge clk or posedge reset) // asynchronous reset in case clk fails
    begin
        if(reset) // reset is active HIGH
        begin
            for(i = 0; i < 32; i = i+1)
                regs[i] <= 32'b0;
        end
        else if(we && rd !=0)
        begin
            regs[rd] <= wd;
        end
    end
                 
endmodule
