`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 19:13:55
// Design Name: 
// Module Name: add16tb
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


module add16tb();

reg [15:0]ina,inb;
reg cin;
wire[15:0]sum;
wire cout;

add16 fadd16(ina,inb,cin,sum,cout);

initial begin
ina=32'b0000_0000_0000_0000_0000_0000_0000_0000;
inb=32'b0000_0000_0000_0000_0000_0000_0000_0000;
end

always #5 ina=$random% 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
always #5 inb=$random% 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;


endmodule
