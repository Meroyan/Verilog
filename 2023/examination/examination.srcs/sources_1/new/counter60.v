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
module counter60( input clk,//ʱ���ź�
                 input rst_n,//�첽��λ�ź�
                 input en,//ʹ���ź�
                 output[7:0]dout,//�������ֵ
                 output co//��λ���    
                 );
reg[7:0]temp_dout;
                 
always@(posedge clk or negedge rst_n)
//clk������  rst_n�½���  
begin
if(!rst_n)//��λ������������
    temp_dout <= 8'b0000_0000;

else if(en == 1'b0)   //����ʹ����Чʱ���������
    temp_dout <= temp_dout;

else if( (dout[7:4] == 4'b0101)&&(dout[3:0] == 4'b1001) )  //�����ﵽ59ʱ���������
    temp_dout <= 8'b00000000;

else if(dout[3:0] == 4'b1001)       //��λ�ﵽ9ʱ����λ���㣬��λ��1
    begin
        temp_dout[3:0] <= 4'b0000;
        temp_dout[7:4] <= temp_dout[7:4] + 1'b1;
    end
    
else                     //���������û�з��������λ���䣬��λ��1
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
 
counter10 u_10(.clk(clk), .rst_n(rst_n), .en(en), .dout(dout10), .co(co10_1)); //ģ10�������Ľ�λΪco10_1
//and u3(co10,en,co10_1); //co10_1��en����Ϊco10
assign co10=en & co10_1;
counter6 u_6(.clk(clk), .rst_n(rst_n), .en(co10), .dout(dout6), .co(co6)); //co10_1��en����Ϊco10,��Ϊģ6��������ʹ���ź�
//and u4(co, co10, co6); //ģ6�������Ľ�λ��ģ6��ʹ���ź�co10������Ϊģ60�������Ľ�λ
assign co=co10 & co6;

assign dout = {dout6,dout10}; //ģ60���������������λΪģ6���������������λΪģ10�������������������8421BCD�����
 
endmodule
 