`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Module Name: instr_memory
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Instruction Memory for the RV32I Single Cycle Processor
//              Single read port that performs a combinational read 
//              Not clocked, because the memory has no write port
// 
// Dependencies: None, pure standalone
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instr_memory(
    output wire [31:0] instr,
    input wire [31:0] addr
    );
    
    reg [31:0] mem [1023:0]; // 1024x32bit memory = 4kB
    
    // uncomment the lines of the following procedural block to read the program from a file
    //initial
    //  $readmemh("prog.hex", mem);
    
    assign instr = mem[addr[11:2]]; // combinational read, word aligned(2) only 2^10 lines (11)
    
endmodule
