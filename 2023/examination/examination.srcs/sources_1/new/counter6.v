`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:26:35
// Design Name: 
// Module Name: counter6
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


module counter6( input clk,//时钟信号
                 input rst_n,//异步复位信号
                 input en,//使能信号
                 output[3:0]dout,//输出计数值
                 output co//进位输出    
                 );
reg [3:0]temp_dout;

always@(posedge clk or negedge rst_n)
//clk上升沿  rst_n下降沿  
begin
if(!rst_n)//复位，计数器清零
    temp_dout <= 4'b0000;
    
else if(en)//使能信号en为高电平时
    if(temp_dout==4'b0101)//计数达到5，清零
        temp_dout<=4'b0000;
    else//计数+1
        temp_dout<=temp_dout+1'b1;
        
else//使能信号en为低电平时，输出不变
        temp_dout<=temp_dout;    
end
   
assign dout=temp_dout;
assign co=dout[0] & dout[2];//计数达到5（0101）时，进位为1
endmodule
