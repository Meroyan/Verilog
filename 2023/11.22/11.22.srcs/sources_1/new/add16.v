`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 19:12:10
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


module add16(
    input[15:0]ina,input[15:0]inb,input cin,
    output[15:0]sum,output cout
    );
    
wire[15:0] carry;

generate
for(genvar i=0;i<16;i=i+1) begin:gen
    add1 fadd11(.ina(ina[i]),
                .inb(inb[i]),
                .cin((i==0)?cin:carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
                );
    end
endgenerate

assign cout=carry[15];    
    
endmodule
