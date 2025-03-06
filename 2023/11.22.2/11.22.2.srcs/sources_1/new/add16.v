`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 22:24:49
// Design Name: 
// Module Name: add16
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


module add16(input[15:0]ina,
             input[15:0]inb,
             input cin,
             output[15:0]sum,
             output cout);
             
assign{cout,sum}=ina+inb+cin;
             
endmodule
