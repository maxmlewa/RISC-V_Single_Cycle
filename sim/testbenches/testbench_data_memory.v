`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench_data_memory
// Project Name: Single Cycle Processor
// Target Devices: XXXX
// Description: Unit testbench for the data_memory module
// 
// Dependencies: Data_memory module instantiated as the DUT
// Functionality tested: Word, halfword, byte read and write operations
//                       Sign and zero extension of the output
//                       Proper byte alignment
//                       Combinational reads and sequential writes
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench_data_memory( );

    // DUT input
    reg clk, we;
    reg [31:0] addr, din;
    reg [2:0] funct3;
    
    // DUT output
    wire [31:0] dout;
    
    // Internal signal declarations
    integer errors;
    
    // DUT instantiation
    data_memory DUT_DATA_MEMORY(
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .funct3(funct3),
        .dout(dout)
    );
    
    // clock generator
    initial
        clk = 0;
    always
        #5 clk = ~clk;
    
    // Task as writing helper
    task test_write;
        input [2:0] f3;
        input [31:0] address;
        input [31:0] data;
        
        begin
            funct3 = f3;
            addr = address;
            din = data;
            we = 1;
            
            #12;
            we = 0;
        end
        
    endtask
    
    // Task as reading helper
    task test_read;
        input [2:0] f3;
        input [31:0] address;
        input [31:0] expected;
        input [25*8:1] label;
        
        begin
            funct3 = f3;
            addr = address;
            #1;
            $write("%-25s Addr: %h -> Dout: %h ", label, address, dout);
            if (dout === expected)
                $display("PASS");
            else
            begin
                $display("FAIL: Expected %h", expected);
                errors = errors + 1;
            end
        end  
    endtask
    
    // Test sequence
    initial
    begin
        errors = 0;
        $display("\n=== Data Memory Tests ===");
        
        // Basic SW / LW
        test_write(3'b010, 32'h00000010, 32'hCAFEBABE);
        test_read( 3'b010, 32'h00000010, 32'hCAFEBABE, "SW + LW (word)");

        // Store and load halfword with sign-extension
        test_write(3'b001, 32'h00000020, 32'h0000BEEF); // only lower halfword
        test_read( 3'b001, 32'h00000020, 32'hFFFFBEEF, "SH + LH (signed)");
        test_read( 3'b101, 32'h00000020, 32'h0000BEEF, "SH + LHU (zero-ext)");

        // Store and load byte with sign-extension
        test_write(3'b000, 32'h00000030, 32'h0000007F);
        test_read( 3'b000, 32'h00000030, 32'h0000007F, "SB + LB (pos byte)");
        test_read( 3'b100, 32'h00000030, 32'h0000007F, "SB + LBU (pos byte)");

        test_write(3'b000, 32'h00000034, 32'h00000080); // 0x80 = -128
        test_read( 3'b000, 32'h00000034, 32'hFFFFFF80, "SB + LB (neg byte)");
        test_read( 3'b100, 32'h00000034, 32'h00000080, "SB + LBU (neg byte)");

        // Multiple locations: Verify no overwrites
        test_write(3'b010, 32'h00000040, 32'hAAAAAAAA);
        test_write(3'b010, 32'h00000044, 32'hBBBBBBBB);
        test_read( 3'b010, 32'h00000040, 32'hAAAAAAAA, "SW + LW (addr 0x40)");
        test_read( 3'b010, 32'h00000044, 32'hBBBBBBBB, "SW + LW (addr 0x44)");

        // Boundary byte test
        test_write(3'b000, 32'h000000FC, 32'h12345678);
        test_read( 3'b100, 32'h000000FC, 32'h00000078, "SB + LBU (near boundary)");
        
        // reading uninitialized location
        test_read( 3'b010, 32'h00000120, 32'hxxxxxxx, "Uninitialized read");
        
                // === Overwrite existing full word ===
        test_write(3'b010, 32'h00000050, 32'h11111111);
        test_read( 3'b010, 32'h00000050, 32'h11111111, "Initial SW @0x50");

        test_write(3'b010, 32'h00000050, 32'h22222222);
        test_read( 3'b010, 32'h00000050, 32'h22222222, "Overwrite SW @0x50");

        // === Partial overwrite: Byte ===
        // Write full word
        test_write(3'b010, 32'h00000060, 32'h12345678);
        // Overwrite just LSB (byte) at 0x60 with 0xAA
        test_write(3'b000, 32'h00000060, 32'h000000AA);
        test_read( 3'b010, 32'h00000060, 32'h123456AA, "Partial Byte Overwrite");

        // === Partial overwrite: Halfword ===
        // Write full word
        test_write(3'b010, 32'h00000070, 32'hABCDEF01);
        // Overwrite lower halfword at 0x70 with 0x5678
        test_write(3'b001, 32'h00000070, 32'h00005678);
        test_read( 3'b010, 32'h00000070, 32'hABCD5678, "Partial Halfword Overwrite");

        // === Byte overwrite of MSB (little endian) ===
        // Write word
        test_write(3'b010, 32'h00000080, 32'h11223344);
        // Overwrite MSB (byte at 0x83) with 0xFF
        test_write(3'b000, 32'h00000083, 32'h000000FF);
        test_read( 3'b010, 32'h00000080, 32'hFF223344, "Byte Overwrite MSB");

        // === Halfword overwrite of upper half ===
        // Write word
        test_write(3'b010, 32'h00000090, 32'hAABBCCDD);
        // Overwrite upper halfword at 0x92 (MS half) with 0x1234
        test_write(3'b001, 32'h00000092, 32'h00001234);
        test_read( 3'b010, 32'h00000090, 32'h1234CCDD, "Halfword Overwrite Upper");

        // === Cross-byte overwrite followed by full word read ===
        // Byte overwrite in middle
        test_write(3'b010, 32'h000000A0, 32'h55555555);
        test_write(3'b000, 32'h000000A1, 32'h000000AA); // Overwrite 2nd byte
        test_read( 3'b010, 32'h000000A0, 32'h5555AA55, "Cross-byte Overwrite");


        
        $display("\n=== Data Memory Test complete with %0d errors ===", errors);
        
        $finish;
    end
    
endmodule
