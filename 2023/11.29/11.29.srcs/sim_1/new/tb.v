`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 20:42:01
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

reg[31:0]num;
wire[5:0]count0;
wire[5:0]count1;
count c1(num,count0,count1);

initial begin
    num=32'b0000_0000_0000_0000_0000_0000_0000_0000;
end
always #6 num=$random%33'b1_0000_0000_0000_0000_0000_0000_0000_0000;

endmodule
