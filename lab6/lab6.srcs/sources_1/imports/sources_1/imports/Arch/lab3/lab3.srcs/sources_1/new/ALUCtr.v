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
    input [3:0] aluOp,
    input [5:0] func,
    output reg [3:0] aluCtrOut,
    output reg shamtSign
    );
    always @ (aluOp or func)
    begin
        casex({aluOp,func})
            // 9'b000xxxxxx://lw sw
            //     aluCtrOut = 4'b0010;
            // 9'b001xxxxxx://beq
            //     aluCtrOut = 4'b0110;
            //
            10'b0000100000:aluCtrOut=4'b0001;//add
            10'b0000100001:aluCtrOut=4'b0001;//addu
            10'b0000100010:aluCtrOut=4'b0011;//sub
            10'b0000100011:aluCtrOut=4'b0011;//subu
            10'b0000100100:aluCtrOut=4'b0100;//and
            10'b0000100101:aluCtrOut=4'b0101;//or
            10'b0000100110:aluCtrOut=4'b0110;//xor
            10'b0000100111:aluCtrOut=4'b0111;//nor
            10'b0000101010:aluCtrOut=4'b1000;//slt
            10'b0000101011:aluCtrOut=4'b1001;//sltu
            10'b0000000000:aluCtrOut=4'b1010;//sll
            10'b0000000010:aluCtrOut=4'b1011;//srl
            10'b0000000011:aluCtrOut=4'b1100;//sra
            10'b0000000100:aluCtrOut=4'b1010;//sllv
            10'b0000000110:aluCtrOut=4'b1011;//srlv
            10'b0000000111:aluCtrOut=4'b1100;//srav
            10'b1111001000:aluCtrOut=4'b1111;//jr
            10'b0010xxxxxx:aluCtrOut=4'b0001;//addi
            10'b0011xxxxxx:aluCtrOut=4'b0001;//addiu
            10'b0100xxxxxx:aluCtrOut=4'b0100;//andi
            10'b0101xxxxxx:aluCtrOut=4'b0101;//ori
            10'b0110xxxxxx:aluCtrOut=4'b0110;//xori
            10'b0111xxxxxx:aluCtrOut=4'b0111;//lui
            10'b1000xxxxxx:aluCtrOut=4'b0001;//lw,sw
            10'b1100xxxxxx:aluCtrOut=4'b0011;//beq,bne
            10'b1010xxxxxx:aluCtrOut=4'b1000;//slti
            10'b1011xxxxxx:aluCtrOut=4'b1000;//sltiu
            10'b1111xxxxxx:aluCtrOut=4'b1111;//jal,j

        endcase
        if(func==6'b000000||func==6'b000010||func==6'b000011)
        shamtSign=1;
        else shamtSign=0;
    end
  
endmodule
