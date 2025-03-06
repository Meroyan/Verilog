`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 19:53:31
// Design Name: 
// Module Name: add32
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


module add32(input[31:0]ina,
            input[31:0]inb,
            output[31:0]sum );
    
wire[1:0] cout;
wire[31:0]tempsum;

add16 fadd16_1(.ina(ina[15:0]),
               .inb(inb[15:0]),
               .cin(0),
               .sum(tempsum[15:0]),
               .cout(cout[0]));
add16 fadd16_2(.ina(ina[31:16]),
               .inb(inb[31:16]),
               .cin(fadd16_1.cout),
               .sum(tempsum[31:16]),
               .cout(cout[1]));
    
assign sum[31:0]={tempsum[31:16],tempsum[15:0]};
    
endmodule
