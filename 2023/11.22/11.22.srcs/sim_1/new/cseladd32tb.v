`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 20:35:56
// Design Name: 
// Module Name: cseladd32tb
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

module cseladd32tb();

reg[31:0]ina;
reg[31:0]inb;
wire[31:0]sum;
    
cseladd32 f1cseladd32(ina,inb,sum);

initial begin
ina=32'b0000_0000_0000_0000_0000_0000_0000_0000;
inb=32'b0000_0000_0000_0000_0000_0000_0000_0000;
end

always #5 ina=$random% 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
always #5 inb=$random% 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
    
endmodule
