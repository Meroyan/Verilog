`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 19:11:12
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
    reg[3:0]ina,inb;
    reg ci;
    wire[3:0]sum;
    wire co;
FourAdd(ina,inb,ci,sum,co);
initial begin
    ina=4'b0000; inb=4'b0000; ci=1'b0; 
end

always #5 ina=$random%5'b10000;
always #5 inb=$random%5'b10000;
always #5 ci=$random%2'b10;

endmodule
