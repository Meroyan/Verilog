`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 21:55:28
// Design Name: 
// Module Name: TOP
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


module TOP(input clk,
           input rst_n,
           input en,
           output [5:0]an,  //ѡ�������
           output [7:0]sseg //ѡ������ܵĶ�
           );
           
wire[7:0] hour,min,sec;

digital_clk u_dig(clk,rst_n,en,hour,min,sec);

wire[3:0] hex0,hex1,hex2,hex3,hex4,hex5;

//hour�����
assign hex4 = hour[3:0];
assign hex5 = hour[7:4];

//min�����
assign hex2 = min[3:0];
assign hex3 = min[7:4];

//sec�����
assign hex0 = sec[3:0];
assign hex1 = sec[7:4];

display u_display(clk,rst_n,hex0,hex1,hex2,hex3,hex4,hex5,1,an,sseg);





  
endmodule
