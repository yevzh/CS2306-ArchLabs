`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 16:46:09
// Design Name: 
// Module Name: Ctr_tb
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


module Ctr_tb(
    );
    reg [5:0] OpCode;
    wire RegDst;
    wire ALUSrc;
    wire MemToReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] ALUOp;
    wire Jump;
    Ctr u(.opCode(OpCode),
          .regDst(RegDst),
          .aluSrc(ALUSrc),
          .memToReg(MemToReg),
          .regWrite(RegWrite),
          .memRead(MemRead),
          .memWrite(MemWrite),
          .branch(Branch),
          .aluOp(ALUOp),
          .jump(Jump)
    );
    initial begin
        OpCode=0;
        #100;
        #100 OpCode=6'b000000;
        #100 OpCode=6'b100011;
        #100 OpCode=6'b101011;
        #100 OpCode=6'b000100;
        #100 OpCode=6'b000010;
        #100 OpCode=6'b111111;
    end
    
endmodule