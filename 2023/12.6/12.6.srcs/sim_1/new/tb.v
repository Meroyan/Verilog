`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 19:10:21
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
reg[32:1]ina,inb;
wire[64:1] c,d;
mult32 f1(ina,inb,c,d);

initial begin
ina=32'b0000_0000_0000_0000_0000_0000_0000_0000;
inb=32'b0000_0000_0000_0000_0000_0000_0000_0000;
end

always #3 ina=$random%33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
always #3 inb=$random%33'b1_0000_0000_0000_0000_0000_0000_0000_0000;


endmodule
