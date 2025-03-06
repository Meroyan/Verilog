`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 18:32:00
// Design Name: 
// Module Name: Calculate
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


module Calculate(input[7:0] ina, input[7:0] inb,
         output[7:0] sumab, //��������֮��
         output sumflag, //�����������֮��Ľ�λ
         output[15:0]leftshiftA, //��a��λ���ƣ��ƶ�λ��Ϊb
         output lessflag, //ina<inbʱ����1
         output equalflag,//�ж�a��b�Ƿ����
         output bitXorflag//��a��λ�������
         );
    assign {sumflag,sumab}=ina+inb;
    assign leftshiftA=ina<<inb;       
    assign lessflag=(ina<inb)?1:0;
    assign equalflag=(ina===inb)?1:0;  
    assign bitXorflag= ^ina;       
                
endmodule
