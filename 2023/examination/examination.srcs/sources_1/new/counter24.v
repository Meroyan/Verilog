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


module counter24( input clk,//ʱ���ź�
                 input rst_n,//�첽��λ�ź�
                 input en,//ʹ���ź�
                 output[7:0]dout//�������ֵ
                 );
reg[7:0]temp_dout;
                 
always@(posedge clk or negedge rst_n)
//clk������  rst_n�½���  
begin
if(!rst_n)//��λ������������
    temp_dout <= 8'b0000_0000;

else if(en == 1'b0)   //����ʹ����Чʱ���������
    temp_dout <= temp_dout;

else if( (dout[7:4] == 4'b0010)&&(dout[3:0] == 4'b0011) )  //�����ﵽ23ʱ���������
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
