`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 20:17:01
// Design Name: 
// Module Name: yima
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


module display_2(input [7:0] num,
                 input clk,
                 output reg[1:0] scan_select,//片选
                 output reg[7:0] seg7 //段选
                 );
reg clk2;//时钟信号计数
reg judge;//分频后的最终判断信号

initial begin
    judge=0;
    scan_select=2'b01;
    seg7=8'b0111_1110;
    clk2=0;
end

always@(posedge clk)
begin
    clk2=clk2+1;
end

always@(posedge clk2)
begin
    judge=~judge;
end

always@(judge)
begin
    if(judge)
    begin
        scan_select <= 2'b10;
        seg7<={num[3:0] ==4'b0000} ? 8'b01111110 ://0
              {num[3:0] ==4'b0001} ? 8'b00110000 ://1
              {num[3:0] ==4'b0010} ? 8'b01101101 ://2
              {num[3:0] ==4'b0011} ? 8'b01111001 ://3
              {num[3:0] ==4'b0100} ? 8'b00110011 ://4
              {num[3:0] ==4'b0101} ? 8'b01011011 ://5
              {num[3:0] ==4'b0110} ? 8'b01011111 ://6
              {num[3:0] ==4'b0111} ? 8'b01110000 ://7
              {num[3:0] ==4'b1000} ? 8'b01111111 ://8
              {num[3:0] ==4'b1001} ? 8'b01111011 ://9
              8'b01111011;//9
    end
    
    else
    begin
     scan_select <= 2'b01;
     seg7<={num[7:4] ==4'b0000}?8'b01111110 ://0
            {num[7:4] ==4'b0001}?8'b00110000 ://1
            {num[7:4] ==4'b0010}?8'b01101101 ://2
            {num[7:4] ==4'b0011}?8'b01111001 ://3
            {num[7:4] ==4'b0100}?8'b00110011 ://4
            {num[7:4] ==4'b0101}?8'b01011011 ://5
            {num[7:4] ==4'b0110}?8'b01011111 ://6
            {num[7:4] ==4'b0111}?8'b01110000 ://7
            {num[7:4] ==4'b1000}?8'b01111111 ://8
            {num[7:4] ==4'b1001}?8'b01111011 ://9
            8'b01111011;//9
    end
end

endmodule