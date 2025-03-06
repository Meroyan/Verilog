`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 19:26:26
// Design Name: 
// Module Name: count
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


module count(input[31:0] num,
             output [5:0] count0,
             output [5:0] count1);
reg [5:0]temp0;
reg [5:0]temp1;

integer i;
always@(num)
begin
    temp1=0;
    temp0=0;
    
    for(i=0;i<32;i=i+1) 
     if(num[i]==0)
        temp0 =temp0 +1;
     else if(num[i]==1)
        temp1 = temp1 +1;
end
   
assign count0=temp0;
assign count1=temp1;
   
endmodule