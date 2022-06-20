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
        if(aluOp==4'b1101)begin
        case({aluOp,func})
            // 9'b000xxxxxx://lw sw
            //     aluCtrOut = 4'b0010;
            // 9'b001xxxxxx://beq
            //     aluCtrOut = 4'b0110;
            //
            10'b1101100000:aluCtrOut=4'b0000;//add
            10'b1101100001:aluCtrOut=4'b0001;//addu
            10'b1101100010:aluCtrOut=4'b0010;//sub
            10'b1101100011:aluCtrOut=4'b0011;//subu
            10'b1101100100:aluCtrOut=4'b0100;//and
            10'b1101100101:aluCtrOut=4'b0101;//or
            10'b1101100110:aluCtrOut=4'b0110;//xor
            10'b1101100111:aluCtrOut=4'b0111;//nor
            10'b1101101010:aluCtrOut=4'b1000;//slt
            10'b1101101011:aluCtrOut=4'b1001;//sltu
            10'b1101000000:aluCtrOut=4'b1010;//sll
            10'b1101000010:aluCtrOut=4'b1011;//srl
            10'b1101000011:aluCtrOut=4'b1100;//sra
            10'b1101000100:aluCtrOut=4'b1010;//sllv
            10'b1101000110:aluCtrOut=4'b1011;//srlv
            10'b1101000111:aluCtrOut=4'b1100;//srav
            10'b1111001000:aluCtrOut=4'b1111;//jr
            default:aluCtrOut=4'b1111;
        endcase
        
        if(func==6'b000000||func==6'b000010||func==6'b000011)
        shamtSign=1;
        else shamtSign=0;
        end
        else //not R-Type
        begin
            aluCtrOut=aluOp;
            shamtSign=0;
        end
    end
  
endmodule
