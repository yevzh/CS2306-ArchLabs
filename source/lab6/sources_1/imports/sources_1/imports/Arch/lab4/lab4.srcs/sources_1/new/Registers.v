`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 17:01:47
// Design Name: 
// Module Name: Registers
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


module Registers(
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    input jalSign,
    input[31:0] jalData,
    input clk,
    input reset,
    output [31:0] readData1,
    output [31:0] readData2
    );
    reg [31:0] regFile [31:0];
    integer i;
    

    assign readData1=regFile[readReg1];
    assign readData2=regFile[readReg2];

    
    always @ (negedge clk)
    begin
        if(regWrite)begin
            regFile[writeReg]=writeData;
        end
        if(jalSign)begin
            regFile[31]=jalData;
        end
    end
    always@(reset)
    begin
        for(i=0;i<=31;i=i+1)
            regFile[i]=0;
    end
endmodule

