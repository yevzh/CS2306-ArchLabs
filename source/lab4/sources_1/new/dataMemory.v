`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 17:06:10
// Design Name: 
// Module Name: dataMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataMemory(
    input clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
    reg [31:0] memFile [0:63];
    always @ (memRead or address)
    begin
        if(memRead)
        begin
            if(address<=63)
                readData=memFile[address];
            else
                readData=0;
        end
    end
    always @ (negedge clk)
    begin
        if(memWrite&&address<=63)
            memFile[address]=writeData;
    end    
endmodule
