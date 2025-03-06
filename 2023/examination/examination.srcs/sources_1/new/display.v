`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 21:33:10
// Design Name: 
// Module Name: display
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


module display(input clk,
               input rst_n,
               input[3:0]hex0, //第一个数码管显示的数字
               input[3:0]hex1,
               input[3:0]hex2,
               input[3:0]hex3,
               input[3:0]hex4,
               input[3:0]hex5,
               input[5:0]dp_in, //小数点
               output reg[5:0] an, //选择数码管
               output reg[7:0] sseg //选择数码管上的段
               );
reg [18:0] regN;  //高三位作为控制信号，低16位为计数器，对时钟进行分频
reg [3:0] hex_in; //段选控制信号
reg dp;           //小数点
   
always@(posedge clk, posedge rst_n)
begin
	if(rst_n) //复位，清零
		regN <= 0;
	else
		regN <= regN + 1;
end    
  
always@ *
begin
	case(regN[18:16])
	3'b000:begin   //选中第一个数码管
		an = 6'b111110; 
		hex_in = hex0; //数码管显示的数字由hex_in控制，显示hex0输入的数字；
		dp = dp_in[0]; //控制该数码管的小数点的亮灭
	end
	
	3'b001:begin   //选中第二个数码管
		an = 6'b111101; 
		hex_in = hex1;
		dp = dp_in[1];
	end
	
	3'b010:begin
		an = 6'b111011;
		hex_in = hex2;
		dp = dp_in[2];
	end
	
	3'b011: begin
		an = 6'b110111;
		hex_in = hex3;
		dp = dp_in[3];
	end
		
	3'b010: begin
		an = 6'b101111;
		hex_in = hex4;
		dp = dp_in[4];
	end
	
	3'b011: begin
		an = 6'b011111;
		hex_in = hex5;
		dp = dp_in[5];
	end
		
	default:begin
		an = 6'b111111;
		hex_in = 0;
		dp = 1'b1;
	end
		
	endcase
end  
 
always@ *
begin
	case(hex_in)
		4'h0: sseg[6:0] = 7'b0000001; 
		4'h1: sseg[6:0] = 7'b1001111;
		4'h2: sseg[6:0] = 7'b0010010;
		4'h3: sseg[6:0] = 7'b0000110;
		4'h4: sseg[6:0] = 7'b1001100;
		4'h5: sseg[6:0] = 7'b0100100;
		4'h6: sseg[6:0] = 7'b0100000;
		4'h7: sseg[6:0] = 7'b0001111;
		4'h8: sseg[6:0] = 7'b0000010;
		4'h9: sseg[6:0] = 7'b0000100;
		4'ha: sseg[6:0] = 7'b0001000;
		4'hb: sseg[6:0] = 7'b1100000;
		4'hc: sseg[6:0] = 7'b0110001;	
		4'hd: sseg[6:0] = 7'b1000010;
		4'he: sseg[6:0] = 7'b0110000;
		default: sseg[6:0] = 7'b0111000;
	endcase

sseg[7] = dp;
end
   
endmodule
