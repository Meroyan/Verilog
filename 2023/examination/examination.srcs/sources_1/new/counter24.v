`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 23:00:54
// Design Name: 
// Module Name: counter24
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


module counter24( input clk,//时钟信号
                 input rst_n,//异步复位信号
                 input en,//使能信号
                 output[7:0]dout//输出计数值
                 );
reg[7:0]temp_dout;
                 
always@(posedge clk or negedge rst_n)
//clk上升沿  rst_n下降沿  
begin
if(!rst_n)//复位，计数器清零
    temp_dout <= 8'b0000_0000;

else if(en == 1'b0)   //计数使能无效时，输出不变
    temp_dout <= temp_dout;

else if( (dout[7:4] == 4'b0010)&&(dout[3:0] == 4'b0011) )  //计数达到23时，输出清零
    temp_dout <= 8'b00000000;

else if(dout[3:0] == 4'b1001)       //低位达到9时，低位清零，高位加1
    begin
        temp_dout[3:0] <= 4'b0000;
        temp_dout[7:4] <= temp_dout[7:4] + 1'b1;
    end
    
else                     //上述情况都没有发生，则高位不变，低位加1
    begin
    temp_dout[7:4] <= temp_dout[7:4];
    temp_dout[3:0] <= temp_dout[3:0] + 1'b1;
    end
end    
      
assign dout=temp_dout;
             
endmodule
