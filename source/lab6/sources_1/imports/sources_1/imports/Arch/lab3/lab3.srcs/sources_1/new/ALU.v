`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 16:39:32
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr,
    output zero,
    output overflow,
    output [31:0] aluRes
    );
    reg Zero;
    reg Overflow;
    reg [31:0] ALURes;
//    reg [31:0] Input1;
//    reg[31:0]Input2;
    always @ (input1 or input2 or aluCtr)
    begin
        case(aluCtr)
            4'b0000://add with overflow
            begin
                ALURes=input1+input2;
                if((input1>>31)==(input2>>31)&&(input1>>31)!=(aluRes>>31))
                Overflow=1;
                else Overflow=0;
            end
            4'b0001:ALURes=input1+input2;//add
            4'b0010://sub with overflow
            begin
                ALURes=input1-input2;
                if((input1>>31)==((~input2+1)>>31)&&(input1>>31)!=(aluRes>>31))
                Overflow=1;
                else Overflow=0;
            end
            4'b0011:ALURes=input1-input2;//sub
            4'b0100:ALURes=input1&input2;//and
            4'b0101:ALURes=input1|input2;//or
            4'b0110:ALURes=input1^input2;//xor
            4'b0111:ALURes=~(input1|input2);//nor
            4'b1000:ALURes=($signed(input1)<$signed(input2));//slt
            4'b1001:ALURes=(input1<input2);//unsigned slt
            4'b1010:ALURes=(input2<<input1);//left-shift
            4'b1011:ALURes=(input2>>input1);//right-shift
            4'b1100:ALURes=($signed(input2)>>>input1);
            default:ALURes=0;

        endcase
        if(ALURes==0)
            Zero=1;
        else
            Zero=0;
    end
    assign zero=Zero;
    assign overflow=Overflow;
    assign aluRes=ALURes;
//    assign input1=Input1;
//    assign input2=Input2;
endmodule


