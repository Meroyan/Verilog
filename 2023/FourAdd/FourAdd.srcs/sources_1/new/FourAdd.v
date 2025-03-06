`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 19:04:38
// Design Name: 
// Module Name: FourAdd
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


module FourAdd(
 input[3:0] ina,
 input[3:0] inb.
 input ci,
 output [3:0]sun,
 output co
    );
 assign{co,sum}=ina+inb+ci;   
    
    
    
endmodule
