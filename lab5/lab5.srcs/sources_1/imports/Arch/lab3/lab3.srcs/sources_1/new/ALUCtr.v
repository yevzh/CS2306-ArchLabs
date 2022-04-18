`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 16:55:22
// Design Name: 
// Module Name: ALUCtr
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

module ALUCtr(
    input [2:0] aluOp,
    input [5:0] funct,
    output reg [3:0] aluCtrOut,
    output reg shamtSign
    );
    always @ (aluOp or funct)
    begin
        casex({aluOp,funct})
            9'b000xxxxxx://lw sw
                aluCtrOut = 4'b0010;
            9'b001xxxxxx://beq
                aluCtrOut = 4'b0110;
            9'b010xxxxxx://addi               
                aluCtrOut = 4'b0010;
            9'b011xxxxxx://andi
                aluCtrOut = 4'b0000;
            9'b100xxxxxx://ori
                aluCtrOut = 4'b0001;
            9'b101000000://sll
                aluCtrOut = 4'b0011;
            9'b101000010://srl
                aluCtrOut = 4'b0100;
            9'b101001000://jr
                aluCtrOut = 4'b0101;
            9'b101100000://add
                aluCtrOut = 4'b0010;
            9'b101100010://sub
                aluCtrOut = 4'b0110;
            9'b101100100://and
                aluCtrOut = 4'b0000;
            9'b101100101://or
                aluCtrOut = 4'b0001;
            9'b101101010://slt
                aluCtrOut = 4'b0111;
            9'b110xxxxxx://j jal
                aluCtrOut = 4'b0101;
        endcase
        if({aluOp, funct}==9'b101000000||{aluOp,funct}==9'b101000010)
            shamtSign=1;
        else
            shamtSign=0;
    end
  
endmodule
