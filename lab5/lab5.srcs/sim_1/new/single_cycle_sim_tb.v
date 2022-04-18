`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/10 11:57:32
// Design Name: 
// Module Name: single_cycle_sim_tb
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


module single_cycle_sim_tb(

    );
    reg clk;
    reg reset;
    Top processor(.clk(clk),.reset(reset));
    
    initial begin
        $readmemb("D:/C/Arch/lab5/inst_data.dat",processor.inst_mem.instFile);
        $readmemh("D:/C/Arch/lab5/data.dat",processor.data_mem.memFile);
        reset=1;
        clk=0;
    end
    
    always #20 clk=~clk;
    initial begin
        #40 reset=0;
        #1000;
        $finish;
    end
endmodule














