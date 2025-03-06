`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 18:32:00
// Design Name: 
// Module Name: Calculate
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


module Calculate(input[7:0] ina, input[7:0] inb,
         output[7:0] sumab, //两个输入之和
         output sumflag, //两个输入相加之后的进位
         output[15:0]leftshiftA, //把a按位左移，移动位数为b
         output lessflag, //ina<inb时返回1
         output equalflag,//判断a与b是否相等
         output bitXorflag//把a按位缩减异或
         );
    assign {sumflag,sumab}=ina+inb;
    assign leftshiftA=ina<<inb;       
    assign lessflag=(ina<inb)?1:0;
    assign equalflag=(ina===inb)?1:0;  
    assign bitXorflag= ^ina;       
                
endmodule
