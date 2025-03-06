`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 16:54:58
// Design Name: 
// Module Name: digital_clk
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


module digital_clk(input clk,
                   input rst_n,
                   input en,
                   output [7:0]hour,
                   output [7:0]min,
                   output [7:0]sec
                   );

wire co_sec,co_min,co_sec1,co_min1;

counter60 u_sec(clk,rst_n,en,sec,co_sec1);

assign co_sec=en & co_sec1;

counter60 u_min(clk,rst_n,co_sec,min,co_min1);

assign co_min=co_min1 & co_sec;

counter24 u_h(clk,rst_n,co_min,hour);




endmodule
