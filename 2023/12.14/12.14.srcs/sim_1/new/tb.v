`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 18:08:54
// Design Name: 
// Module Name: tb
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


module tb();
reg[7:0]switch;
reg clk;
wire[1:0]scan_select;
wire[7:0]seg7;

display_2 u(switch,clk,scan_select,seg7);

initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end

initial begin
switch=8'b0000_0000;
end

always #2 switch=$random% 9'b1_0000_0000;

endmodule
