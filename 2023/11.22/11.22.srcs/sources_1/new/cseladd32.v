`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 20:35:23
// Design Name: 
// Module Name: cseladd32
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


module cseladd32(input[31:0]ina,
                 input[31:0]inb,
                 output[31:0]sum);

wire [31:0]tempsum1;
wire [2:0]cout;



add16 fadd16_0(.ina(ina[15:0]),
               .inb(inb[15:0]),
               .cin(0),
               .sum(sum[15:0]),
               .cout(cout[0]));
add16 fadd16_3(.ina(ina[31:16]),
               .inb(inb[31:16]),
               .cin(0),
               .sum(tempsum1[15:0]),
               .cout(cout[1]));
               
add16 fadd16_4(.ina(ina[31:16]),
               .inb(inb[31:16]),
               .cin(1'b1),
               .sum(tempsum1[31:16]),
               .cout(cout[2]));
    
wire [15:0]tsum;
assign tsum[15:0]=((cout[0]==0) ? tempsum1[15:0]:tempsum1[31:16]);
assign sum[31:0]={tempsum1[15:0],sum[15:0]};


endmodule
