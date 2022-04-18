`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/10 10:31:38
// Design Name: 
// Module Name: Top
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


module Top(
    input clk,
    input reset
    );
    wire REG_DST;               //reg dst, choose rt or rd
    wire JUMP;                  //jump
    wire BRANCH;                //branch
    wire MEM_READ;              //mem read
    wire MEM_TO_REG;            //mem to reg
    wire MEM_WRITE;             //mem right
    wire [2:0] ALU_OP;          //alu op
    wire ALU_SRC;               //alu src
    wire REG_WRITE;             //reg write
    wire [31:0] INST_ADDR;      //instruction address
    wire [31:0] INST;           //instruction
    wire SHAMT_SIGN;            //shamt sign
    wire JR_SIGN;               //jr sign
    wire EXT_SIGN;              //ext sign
    wire JAL_SIGN;              //jal sign
    wire ALU_ZERO;              //alu zero
    wire [3:0] ALU_CTR;         //alu ctr
    
    wire [31:0] ALU_INPUT1;     //alu input1
    wire [31:0] ALU_INPUT2;     //alu input2
    wire [31:0] ALU_RES;        //alu result
    wire [31:0] PC_IN;          //pc input
    wire [31:0] PC_OUT;         //pc output
    wire [4:0] REG_READ_SELECT1;       //read reg1
    wire [4:0] REG_READ_SELECT2;       //read reg2
    wire [4:0] REG_WRITE_SELECT;       //write reg2
    wire [31:0] REG_WRITE_DATA; //reg write data
    wire [31:0] MEM_READ_DATA;  //mem read data
    wire [31:0] REG_READ_DATA1; //read reg1
    wire [31:0] REG_READ_DATA2; //read reg2
    wire [31:0] EXT;            //extend result
    
    wire [31:0] PC_BRANCH;        
    wire [31:0] PC_JUMP;
    wire [4:0] REG_WRITE_JAL;
    wire [31:0] REG_WRITE_FROM_MEM;
    
    Ctr main_ctr(
        .opCode(INST[31:26]),
        .func(INST[5:0]),
        .regDst(REG_DST),
        .aluSrc(ALU_SRC),
        .memToReg(MEM_TO_REG),
        .regWrite(REG_WRITE),
        .memRead(MEM_READ),
        .memWrite(MEM_WRITE),
        .branch(BRANCH),
        .extSign(EXT_SIGN),
        .jalSign(JAL_SIGN),
        .aluOp(ALU_OP),
        .jump(JUMP),
        .jrSign(JR_SIGN)
    );
    
    ALUCtr alu_ctr(
        .aluOp(ALU_OP),
        .funct(INST[5:0]),
        .aluCtrOut(ALU_CTR),
        .shamtSign(SHAMT_SIGN)
    );
    
    ALU alu(
        .input1(ALU_INPUT1),
        .input2(ALU_INPUT2),
        .aluCtr(ALU_CTR),
        .zero(ALU_ZERO),
        .aluRes(ALU_RES)   
    );

    
    Registers register_file(
        .readReg1(INST[25:21]),
        .readReg2(INST[20:16]),
        .writeReg(REG_WRITE_JAL),
        .writeData(REG_WRITE_DATA),
        .regWrite(REG_WRITE&(~JR_SIGN)),
        .clk(clk),
        .reset(reset),
        .readData1(REG_READ_DATA1),
        .readData2(REG_READ_DATA2)
    );
    PC pc(
        .pcIn(PC_IN),
        .clk(clk),
        .reset(reset),
        .pcOut(PC_OUT)
    );
    
    InstMemory inst_mem(
        .address(PC_OUT),
        .inst(INST)
    );
    
    dataMemory data_mem(
        .clk(clk),
        .address(ALU_RES),
        .writeData(REG_READ_DATA2),
        .memWrite(MEM_WRITE),
        .memRead(MEM_READ),
        .readData(MEM_READ_DATA)
    );
    signext sign_ext(
        .extSign(EXT_SIGN),
        .inst(INST[15:0]),
        .data(EXT)
    );    


    Mux shamt_rs_mux(
        .selectSignal(SHAMT_SIGN),
        .input1({27'b0,INST[10:6]}),
        .input2(REG_READ_DATA1),
        .out(ALU_INPUT1)
    );
    Mux inst_rt_mux(
        .selectSignal(ALU_SRC),
        .input1(EXT),
        .input2(REG_READ_DATA2),
        .out(ALU_INPUT2)
    );
    Mux_s rt_rd_mux(
        .selectSignal(REG_DST),
        .input1(INST[15:11]),
        .input2(INST[20:16]),
        .out(REG_WRITE_SELECT)
    );
    Mux_s rt_rd_next_mux(
        .selectSignal(JAL_SIGN),
        .input1(5'b11111),
        .input2(REG_WRITE_SELECT),
        .out(REG_WRITE_JAL)
    );
    Mux mem_alu_mux(
        .selectSignal(MEM_TO_REG),
        .input1(MEM_READ_DATA),
        .input2(ALU_RES),
        .out(REG_WRITE_FROM_MEM)
    );
    Mux jal_mux(
        .selectSignal(JAL_SIGN),
        .input1(PC_OUT+4),
        .input2(REG_WRITE_FROM_MEM),
        .out(REG_WRITE_DATA)
    );
    Mux branch_mux(
        .selectSignal(BRANCH & ALU_ZERO),
        .input1(PC_OUT+4+(EXT<<2)),
        .input2(PC_OUT+4),
        .out(PC_BRANCH)
    );
    Mux jump_mux(
        .selectSignal(JUMP),
        .input1(((PC_OUT+4)&32'hf0000000)+(INST[25:0]<<2)),
        .input2(PC_BRANCH),
        .out(PC_JUMP)
    );
    Mux jr_mux(
        .selectSignal(JR_SIGN),
        .input1(REG_READ_DATA1),
        .input2(PC_JUMP),
        .out(PC_IN)
    );  

    

endmodule
