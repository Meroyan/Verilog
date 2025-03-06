`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 20:28:15
// Design Name: 
// Module Name: myadder
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


module myadder(input a,input b,input ci,output s,output co);

   assign s=a^b^ci;
   assign co=ci&(a^b) | a&b;

endmodule










