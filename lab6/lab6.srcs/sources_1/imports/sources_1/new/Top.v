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
    
//   reg NOP;
//   reg STALL;

    //IF stage
    reg[31:0] IF_PC;
    wire[31:0] IF_INST;
    InstMemory inst_mem(
        .address(IF_PC),
        .inst(IF_INST)
    );

    //Segment registers
    reg[31:0] IF2ID_PC;
    reg[31:0] IF2ID_INST;

    //ID stage
    wire[12:0] ID_CTR_SIGNALS;
    // 12:J
    // 11:JR
    // 10:EXT
    // 9:REG_DST
    // 8:JAL
    // 7:ALU_SRC
    // 6:LUI
    // 5:BEQ
    // 4:BNE
    // 3:MEM_WRITE
    // 2:MEM_READ
    // 1:MEM_TO_REG
    // 0:REG_WRITE

    //we should use wire to realize output

    wire ID_JUMP_SIGNAL;
    wire ID_JR_SIGNAL;
    wire ID_EXT_SIGNAL;
    wire ID_REG_DST_SIGNAL;
    wire ID_JAL_SIGNAL;
    wire ID_ALU_SRC_SIGNAL;
    wire ID_LUI_SIGNAL;
    wire ID_BEQ_SIGNAL;
    wire ID_BNE_SIGNAL;
    wire ID_MEM_WRITE_SIGNAL;
    wire ID_MEM_READ_SIGNAL;
    wire ID_MEM_TO_REG_SIGNAL;
    wire ID_REG_WRITE_SIGNAL;

    wire[3:0] ID_CTR_SIGNAL_ALUOP;
    Ctr main_ctr(
        .opCode(IF2ID_INST[31:26]),
        .func(IF2ID_INST[5:0]),
        .jump(ID_JUMP_SIGNAL),
        .jrSign(ID_JR_SIGNAL),
        .extSign(ID_EXT_SIGNAL),
        .regDst(ID_REG_DST_SIGNAL),
        .jalSign(ID_JAL_SIGNAL),
        .aluSrc(ID_ALU_SRC_SIGNAL),
        .luiSign(ID_LUI_SIGNAL),
        .beqSign(ID_BEQ_SIGNAL),
        .bneSign(ID_BNE_SIGNAL),
        .memWrite(ID_MEM_WRITE_SIGNAL),
        .memRead(ID_MEM_READ_SIGNAL),
        .memToReg(ID_MEM_TO_REG_SIGNAL),
        .regWrite(ID_REG_WRITE_SIGNAL),
        .aluOp(ID_CTR_SIGNAL_ALUOP)
    );

    assign ID_CTR_SIGNALS[12]=ID_JUMP_SIGNAL;
    assign ID_CTR_SIGNALS[11]=ID_JR_SIGNAL;
    assign ID_CTR_SIGNALS[10]=ID_EXT_SIGNAL;
    assign ID_CTR_SIGNALS[9]=ID_REG_DST_SIGNAL;
    assign ID_CTR_SIGNALS[8]=ID_JAL_SIGNAL;
    assign ID_CTR_SIGNALS[7]=ID_ALU_SRC_SIGNAL;
    assign ID_CTR_SIGNALS[6]=ID_LUI_SIGNAL;
    assign ID_CTR_SIGNALS[5]=ID_BEQ_SIGNAL;
    assign ID_CTR_SIGNALS[4]=ID_BNE_SIGNAL;
    assign ID_CTR_SIGNALS[3]=ID_MEM_WRITE_SIGNAL;
    assign ID_CTR_SIGNALS[2]=ID_MEM_READ_SIGNAL;
    assign ID_CTR_SIGNALS[1]=ID_MEM_TO_REG_SIGNAL;
    assign ID_CTR_SIGNALS[0]=ID_REG_WRITE_SIGNAL;


    wire[31:0] ID_REG_READ_DATA1;
    wire[31:0] ID_REG_READ_DATA2;
    wire[4:0] WB_REG_WRITE_ID;
    wire[4:0] WB_REG_WRITE_SELECT;//after the mux
    wire[31:0] WB_REG_WRITE_DATA;
    wire[31:0] WB_REG_WRITE_DATA_SELECT;//after the mux
    wire WB_REG_WRITE_SIGNAL;

    wire[4:0] ID_REG_DEST;
     wire[4:0] ID_REG_RS=IF2ID_INST[25:21];//RS
     wire[4:0] ID_REG_RT=IF2ID_INST[20:16];//RT
     wire[4:0] ID_REG_RD=IF2ID_INST[15:11];//RD

    Mux_s rt_rd_mux(
        .selectSignal(ID_REG_DST_SIGNAL),
        .input1(IF2ID_INST[15:11]),
        .input2(IF2ID_INST[20:16]),
        .out(ID_REG_DEST)
    );


    Registers reg_file(
        .readReg1(IF2ID_INST[25:21]),
        .readReg2(IF2ID_INST[20:16]),
        .writeReg(WB_REG_WRITE_SELECT),
        .writeData(WB_REG_WRITE_DATA_SELECT),
        .regWrite(WB_REG_WRITE_SIGNAL),
        .clk(clk),
        .reset(reset),
        .readData1(ID_REG_READ_DATA1),
        .readData2(ID_REG_READ_DATA2)
    );

    wire[31:0] ID_EXT_RES;
    signext sign_ext(
        .inst(IF2ID_INST[15:0]),
        .extSign(ID_EXT_SIGNAL),
        .data(ID_EXT_RES)
    );

    //Segment registers ID2EX
    reg[3:0] ID2EX_ALUOP;
    reg[7:0] ID2EX_CTR_SIGNALS;
    reg[4:0] ID2EX_INST_RS;
    reg[4:0] ID2EX_INST_RT;
    reg[31:0] ID2EX_REG_READ_DATA1;
    reg[31:0] ID2EX_REG_READ_DATA2;
    reg[4:0] ID2EX_REG_DEST;
    reg[31:0] ID2EX_EXT_RES;
    reg[4:0] ID2EX_SHAMT;
    reg[5:0] ID2EX_FUNC;
    reg[31:0] ID2EX_PC;

    //EX stage
    
    wire EX_ALU_SRC_SIG=ID2EX_CTR_SIGNALS[7];
    wire EX_LUI_SIG=ID2EX_CTR_SIGNALS[6];
    wire EX_BEQ_SIG=ID2EX_CTR_SIGNALS[5];
    wire EX_BNE_SIG=ID2EX_CTR_SIGNALS[4];
    wire EX_SHAMT_SIGNAL;
    wire[3:0] EX_ALU_CTR_OUT;

    wire[31:0] EX_ALU_INPUT1;
    wire[31:0] EX_ALU_INPUT2;
    wire[31:0] EX_ALU_RES;
    wire[31:0] EX_ALU_RES_LUI;
    wire EX_ALU_ZERO;
    wire EX_ALU_OVERFLOW;

    ALUCtr alu_ctr(
        .aluOp(ID2EX_ALUOP),
        .func(ID2EX_FUNC),
        .shamtSign(EX_SHAMT_SIGNAL),
        .aluCtrOut(EX_ALU_CTR_OUT)
    );


    wire[31:0] EX_ALU_INPUT1_FORWADING;
    wire[31:0] EX_ALU_INPUT2_FORWADING;

    Mux rs_shamt_mux(
        .selectSignal(EX_SHAMT_SIGNAL),
        .input1({27'b0,ID2EX_SHAMT}),
        .input2(EX_ALU_INPUT1_FORWADING),
        .out(EX_ALU_INPUT1)
    );//FOR INPUT1

    Mux rt_ext_mux(
        .selectSignal(EX_ALU_SRC_SIG),
        .input1(ID2EX_EXT_RES),
        .input2(EX_ALU_INPUT2_FORWADING),
        .out(EX_ALU_INPUT2)
    );//FOR INPUT2

    ALU alu(
        .input1(EX_ALU_INPUT1),
        .input2(EX_ALU_INPUT2),
        .aluCtr(EX_ALU_CTR_OUT),
        .aluRes(EX_ALU_RES),
        .zero(EX_ALU_ZERO),
        .overflow(EX_ALU_OVERFLOW)
    );

    Mux lui_mux(
        .selectSignal(EX_LUI_SIG),
        .input1({ID2EX_EXT_RES[15:0],16'b0}),
        .input2(EX_ALU_RES),
        .out(EX_ALU_RES_LUI)
    );

    wire[31:0] BRANCH_DT=ID2EX_PC+4+(ID2EX_EXT_RES<<2);

    //jump or branch, updating pc
    //we set the sequence jump->jr->beq->bne
    wire[31:0] PC_JUMP;
    wire[31:0] PC_JR;
    wire[31:0] PC_BEQ;
    wire[31:0] PC_BNE;

    Mux pc_jump_mux(
        .selectSignal(ID_CTR_SIGNALS[12]),
        .input1(((IF2ID_PC+4)&32'hf0000000)+(IF2ID_INST[25:0]<<2)),
        .input2(IF_PC+4),
        .out(PC_JUMP)
    );
    Mux pc_jr_mux(
        .selectSignal(ID_CTR_SIGNALS[11]),
        .input1(ID_REG_READ_DATA1),
        .input2(PC_JUMP),
        .out(PC_JR)
    );
    Mux pc_beq_mux(
        .selectSignal(EX_BEQ_SIG&EX_ALU_ZERO),
        .input1(BRANCH_DT),
        .input2(PC_JR),
        .out(PC_BEQ)
    );
    Mux pc_bne_mux(
        .selectSignal(EX_BNE_SIG&(~EX_ALU_ZERO)),
        .input1(BRANCH_DT),
        .input2(PC_BEQ),
        .out(PC_BNE)
    );
    wire[31:0] PC_NEXT=PC_BNE;
    wire BRANCH=EX_BEQ_SIG|EX_BNE_SIG;


    //Segment registers EX to MA
    reg[3:0] EX2MA_CTR_SIGNALS;
    reg[31:0] EX2MA_ALU_RES;
    reg[31:0] EX2MA_REG_READ_DATA2;
    reg[4:0] EX2MA_REG_DEST;

    wire MA_MEM_WRITE_SIGNAL=EX2MA_CTR_SIGNALS[3];
    wire MA_MEM_READ_SIGNAL= EX2MA_CTR_SIGNALS[2];
    wire MA_MEM_TO_REG_SIGNAL=EX2MA_CTR_SIGNALS[1];
    wire MA_REG_WRITE_SIGNAL=EX2MA_CTR_SIGNALS[0];


    //MA stage
    wire[31:0] MA_MEM_READ_DATA;
    dataMemory data_mem(
        .clk(clk),
        .address(EX2MA_ALU_RES),
        .writeData(EX2MA_REG_READ_DATA2),
        .memWrite(MA_MEM_WRITE_SIGNAL),
        .memRead(MA_MEM_READ_SIGNAL),
        .readData(MA_MEM_READ_DATA)
    );

    wire[31:0] MA_MEM_DATA_OUT;
    Mux mem_to_reg_mux(
        .selectSignal(MA_MEM_TO_REG_SIGNAL),
        .input1(MA_MEM_READ_DATA),
        .input2(EX2MA_ALU_RES),
        .out(MA_MEM_DATA_OUT)
    );

    //Segment registers MA to WB
    reg MA2WB_CTR_SIGNALS;
    reg[31:0] MA2WB_DATA_OUT;
    reg[4:0] MA2WB_REG_WRITE;

    //connect it to the registers
    assign WB_REG_WRITE_ID=MA2WB_REG_WRITE;
    assign WB_REG_WRITE_DATA=MA2WB_DATA_OUT;
    assign WB_REG_WRITE_SIGNAL=MA2WB_CTR_SIGNALS;

    // wire[5:0] WB_REG_WRIRE_SELECT;

    Mux_s jal_reg_mux(
        .selectSignal(ID_JAL_SIGNAL),
        .input1(5'b11111),
        .input2(WB_REG_WRITE_ID),
        .out(WB_REG_WRITE_SELECT)
    );
    Mux jal_reg_data_mux(
        .selectSignal(ID_JAL_SIGNAL),
        .input1(IF2ID_PC+4),
        .input2(WB_REG_WRITE_DATA),
        .out(WB_REG_WRITE_DATA_SELECT)
    );

    //FORWARDING
    wire[31:0] EX_FORWARING1_TMP;
    wire[31:0] EX_FORWARING2_TMP;
    Mux forward_mux1(
        .selectSignal(WB_REG_WRITE_SIGNAL&(MA2WB_REG_WRITE==ID2EX_INST_RS)),
        .input1(MA2WB_DATA_OUT),
        .input2(ID2EX_REG_READ_DATA1),
        .out(EX_FORWARING1_TMP)
    );
    Mux forward_mux2(
        .selectSignal(WB_REG_WRITE_SIGNAL&(MA2WB_REG_WRITE==ID2EX_INST_RT)),
        .input1(MA2WB_DATA_OUT),
        .input2(ID2EX_REG_READ_DATA2),
        .out(EX_FORWARING2_TMP)
    );
    Mux forward_mux1_next(
        .selectSignal(MA_REG_WRITE_SIGNAL&(EX2MA_REG_DEST==ID2EX_INST_RS)),
        .input1(EX2MA_ALU_RES),
        .input2(EX_FORWARING1_TMP),
        .out(EX_ALU_INPUT1_FORWADING)
    );
    Mux forward_mux2_next(
        .selectSignal(MA_REG_WRITE_SIGNAL&(EX2MA_REG_DEST==ID2EX_INST_RT)),
        .input1(EX2MA_ALU_RES),
        .input2(EX_FORWARING2_TMP),
        .out(EX_ALU_INPUT2_FORWADING)
    );
    wire STALL=ID2EX_CTR_SIGNALS[2]&((ID2EX_INST_RT==IF2ID_INST[25:21])|(ID2EX_INST_RT==IF2ID_INST[20:16]));
    wire NOP=BRANCH|ID_JUMP_SIGNAL|ID_JAL_SIGNAL;
//
    initial IF_PC=0;
    always @(reset)
    begin
        if(reset)begin
            IF_PC=0;
            IF2ID_INST=0;
            IF2ID_PC=0;
            ID2EX_ALUOP=0;
            ID2EX_CTR_SIGNALS=0;
            ID2EX_EXT_RES=0;
            ID2EX_FUNC=0;
            ID2EX_INST_RS=0;
            ID2EX_INST_RT=0;
            ID2EX_REG_DEST=0;
            ID2EX_REG_READ_DATA1=0;
            ID2EX_REG_READ_DATA2=0;
            ID2EX_SHAMT=0;
            EX2MA_ALU_RES=0;
            EX2MA_CTR_SIGNALS=0;
            EX2MA_REG_DEST=0;
            EX2MA_REG_READ_DATA2=0;
            MA2WB_CTR_SIGNALS=0;
            MA2WB_DATA_OUT=0;
            MA2WB_REG_WRITE=0;
        end
    end

    always @(posedge clk)
    begin
        //if-id
        if(!STALL)
            IF_PC<=PC_BNE;
        if(BRANCH||ID_CTR_SIGNALS[12]||ID_CTR_SIGNALS[11])begin
            IF2ID_INST<=0;
            IF2ID_PC<=0;
        end else if(!STALL)begin
            IF2ID_INST<=IF_INST;
            IF2ID_PC<=IF_PC;
        end
        //id-ex

            if(STALL||BRANCH)begin
                ID2EX_PC<=IF2ID_PC;
                ID2EX_ALUOP<=4'b1111;
                ID2EX_CTR_SIGNALS<=0;
                ID2EX_EXT_RES<=0;
                ID2EX_INST_RS<=0;
                ID2EX_INST_RT<=0;
                ID2EX_REG_READ_DATA1<=0;
                ID2EX_REG_READ_DATA2<=0;
                ID2EX_FUNC<=0;
                ID2EX_SHAMT<=0;
                ID2EX_REG_DEST<=0;
            end else begin
                ID2EX_PC<=IF2ID_PC;
                ID2EX_ALUOP<=ID_CTR_SIGNAL_ALUOP;
                ID2EX_CTR_SIGNALS<=ID_CTR_SIGNALS[7:0];
                ID2EX_EXT_RES<=ID_EXT_RES;
                ID2EX_INST_RS<=IF2ID_INST[25:21];
                ID2EX_INST_RT<=IF2ID_INST[20:16];
                ID2EX_REG_READ_DATA1<=ID_REG_READ_DATA1;
                ID2EX_REG_READ_DATA2<=ID_REG_READ_DATA2;
                ID2EX_FUNC<=IF2ID_INST[5:0];
                ID2EX_SHAMT<=IF2ID_INST[10:6];
                ID2EX_REG_DEST<=ID_REG_DEST;
            end

        //ex-ma

            EX2MA_CTR_SIGNALS<=ID2EX_CTR_SIGNALS[3:0];
            EX2MA_ALU_RES<=EX_ALU_RES_LUI;
            EX2MA_REG_READ_DATA2<=EX_ALU_INPUT2_FORWADING;
            EX2MA_REG_DEST<=ID2EX_REG_DEST;

            MA2WB_CTR_SIGNALS<=EX2MA_CTR_SIGNALS[0];
            MA2WB_DATA_OUT<=MA_MEM_DATA_OUT;
            MA2WB_REG_WRITE<=EX2MA_REG_DEST;
    end



endmodule
