`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 22:19:24
// Design Name: 
// Module Name: counter60
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

/*
module counter60( input clk,//时钟信号
                 input rst_n,//异步复位信号
                 input en,//使能信号
                 output[7:0]dout,//输出计数值
                 output co//进位输出    
                 );
reg[7:0]temp_dout;
                 
always@(posedge clk or negedge rst_n)
//clk上升沿  rst_n下降沿  
begin
if(!rst_n)//复位，计数器清零
    temp_dout <= 8'b0000_0000;

else if(en == 1'b0)   //计数使能无效时，输出不变
    temp_dout <= temp_dout;

else if( (dout[7:4] == 4'b0101)&&(dout[3:0] == 4'b1001) )  //计数达到59时，输出清零
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
*/



module counter60(clk, rst_n, en, dout, co);
 
input clk, rst_n, en;
output[7:0] dout;
output co;
wire co10_1, co10, co6;
wire[3:0] dout10, dout6;
 
counter10 u_10(.clk(clk), .rst_n(rst_n), .en(en), .dout(dout10), .co(co10_1)); //模10计数器的进位为co10_1
//and u3(co10,en,co10_1); //co10_1与en的与为co10
assign co10=en & co10_1;
counter6 u_6(.clk(clk), .rst_n(rst_n), .en(co10), .dout(dout6), .co(co6)); //co10_1与en的与为co10,作为模6计数器的使能信号
//and u4(co, co10, co6); //模6计数器的进位和模6的使能信号co10的与作为模60计数器的进位
assign co=co10 & co6;

assign dout = {dout6,dout10}; //模60计数器的输出，高位为模6计数器的输出，低位为模10计数器的输出，读法是8421BCD码读法
 
endmodule
 