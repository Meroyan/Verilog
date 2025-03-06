`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: adder.v
//   > ����  ���ӷ�����ֱ��ʹ��"+"�����Զ����ÿ���ļӷ���
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module adder(
    input  [31:0] operand1,
    input  [31:0] operand2,
    input  [31:0] operand3,
    input  [31:0] operand4,
    input  [1:0]  cin,
    output [31:0] result,
    output        cout
    );
    wire[31:0]temp1;
    wire[31:0]temp2;    
    assign {cout,temp1} = operand1 + operand2 + cin[0];
    assign {cout,temp2} = operand3 + operand4 + cin[1];
    assign {cout,result} = temp1 + temp2 + cin[0];

    

endmodule
