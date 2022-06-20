`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 16:41:52
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
    wire [31:0] ALURes;
    reg [31:0] Input1;
    reg [31:0] Input2;
    reg [3:0] ALUCtr;
    wire Zero;
    ALU uu(.input1(Input1),
          .input2(Input2),
          .aluCtr(ALUCtr),
          .zero(Zero),
          .aluRes(ALURes)
    );
    initial begin
        Input1=0;
        Input2=0;
        ALUCtr=0;
        #100;
        Input1=15;
        Input2=10;
        ALUCtr=4'b0000;
        #100;
        Input1=15;
        Input2=10;
        ALUCtr=4'b0001;
        #100;
        Input1=15;
        Input2=10;
        ALUCtr=4'b0010;
        #100;
        Input1=15;
        Input2=10;
        ALUCtr=4'b0110;
        #100;
        Input1=10;
        Input2=15;
        ALUCtr=4'b0110;
        #100;
        Input1=15;
        Input2=10;
        ALUCtr=4'b0111;
        #100;
        Input1=10;
        Input2=15;
        ALUCtr=4'b0111;
        #100;
        Input1=1;
        Input2=1;
        ALUCtr=4'b1100;
        #100;
        Input1=16;
        Input2=1;
        ALUCtr=4'b1100;
    end
endmodule
