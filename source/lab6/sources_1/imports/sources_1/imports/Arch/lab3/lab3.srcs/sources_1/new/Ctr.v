`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/09 16:45:28
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] opCode,
    input [5:0] func,
    // input nop,
    output regDst,
    output aluSrc,
    output memToReg,
    output regWrite,
    output memRead,
    output memWrite,
    output [3:0] aluOp,
    output jump,
    output extSign,
    output jalSign,
    output beqSign,
    output bneSign,
    output luiSign,
    output jrSign
    );
    reg RegDst;
    reg ALUSrc;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg [3:0] ALUOp;
    reg Jump;
    reg ExtSign;
    reg JalSign;
    reg BeqSign;
    reg BneSign;
    reg LuiSign;
    reg JrSign;
    
    always @(opCode or func)
    begin
        case(opCode)
        6'b000000:          //R Type
        begin
            if(func==6'b001000)begin
                RegDst=0;
                RegWrite=0;
                JrSign=1;
                ALUOp=4'b1111;
            end
            else begin
                RegDst=1;
                RegWrite=1;
                JrSign=0;
                ALUOp=4'b1101;
            end
            // regDst=0;
            ALUSrc=0;
            MemToReg=0;
            // regWrite=0;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            // jrSign=0;
            // aluOp=4'b1111;
            Jump=0;
        end
        6'b001000:          //addi
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0000;   
        end
        6'b001001:          //addiu
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0001;    
        end
        6'b001100:          //andi
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0100;
        end
        6'b001101:          //ori
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0101;
        end
        6'b001110:          //xori
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0110;
        end
        6'b001111:          //lui
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=1;
            JrSign=0;
            ALUOp=4'b1111;
        end
        6'b100011:          //lw
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=1;
            RegWrite=1;
            MemRead=1;
            MemWrite=0;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0001;
        end
        6'b101011:             //sw
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=1;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0001;
        end
        6'b000100:          //beq
        begin
            RegDst=0;
            ALUSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=1;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0011;
        end 
        6'b000101:          //bne
        begin
            RegDst=0;
            ALUSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=0;
            BneSign=1;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b0011;
        end
        6'b001010:          //slti
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=1;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b1000;
        end
        6'b001011:          //sltiu
        begin
            RegDst=0;
            ALUSrc=1;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b1001;
        end
        6'b000010:          //j
        begin
            RegDst=0;
            ALUSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Jump=1;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b1111;
        end
        6'b000011:          //jal
        begin 
            RegDst=0;
            ALUSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Jump=1;
            ExtSign=0;
            JalSign=1;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b1111;
        end
        default:
        begin
            RegDst=0;
            ALUSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            ALUOp=0;
            Jump=0;
            ExtSign=0;
            JalSign=0;
            BeqSign=0;
            BneSign=0;
            LuiSign=0;
            JrSign=0;
            ALUOp=4'b1111;
        end
        endcase
        
    end   
    assign regDst=RegDst;
    assign aluSrc=ALUSrc;
    assign memToReg=MemToReg;
    assign regWrite=RegWrite;
    assign memRead=MemRead;
    assign memWrite=MemWrite;
    assign aluOp=ALUOp;
    assign jump=Jump;
    assign extSign=ExtSign;
    assign jalSign=JalSign;  
    assign beqSign=BeqSign;
    assign bneSign=BneSign;
    assign luiSign=LuiSign;
    assign jrSign=JrSign;          
endmodule
