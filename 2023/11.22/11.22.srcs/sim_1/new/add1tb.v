`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 18:37:34
// Design Name: 
// Module Name: add1tb
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


module add1tb();

reg ina,inb,cin;
wire sum, cout;

add1 fadd1(ina,inb,cin,sum,cout);
initial begin
    ina=1'b0;
    inb=1'b0;
    cin=1'b0;
end

always #2 ina=$random% 2'b10;
always #3 inb=$random% 2'b10;

endmodule
