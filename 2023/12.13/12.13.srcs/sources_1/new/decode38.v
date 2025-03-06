`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:51:33
// Design Name: 
// Module Name: decode38
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


module decode38(input A,
                input B,
                input C,
                output [7:0]y
    );
    
assign y= {C,B,A}==3'b000 ? 8'b0000_0001:
          {C,B,A}==3'b001 ? 8'b0000_0010:
          {C,B,A}==3'b010 ? 8'b0000_0100:
          {C,B,A}==3'b011 ? 8'b0000_1000:
          {C,B,A}==3'b100 ? 8'b0001_0000:
          {C,B,A}==3'b101 ? 8'b0010_0000:
          {C,B,A}==3'b110 ? 8'b0100_0000:
          8'b1000_0000;

    
endmodule
