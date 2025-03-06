`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:25:30
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


module counter10( input clk,//ʱ���ź�
                 input rst_n,//�첽��λ�ź�
                 input en,//ʹ���ź�
                 output[3:0]dout,//�������ֵ
                 output co//��λ���
    );
    
reg [3:0]temp_dout;
 
always@(posedge clk or negedge rst_n)
//clk������  rst_n�½���  
begin
if(!rst_n)//��λ������������
    temp_dout <= 4'b0000;
    
else if(en)//ʹ���ź�enΪ�ߵ�ƽʱ
    if(temp_dout==4'b1001)//�����ﵽ9������
        temp_dout<=4'b0000;
    else//����+1
        temp_dout<=temp_dout+1'b1;
        
else//ʹ���ź�enΪ�͵�ƽʱ���������
        temp_dout<=temp_dout;    
end
   
assign dout=temp_dout;
assign co=dout[0] & dout[3];//�����ﵽ9��1001��ʱ����λΪ1
 
endmodule
