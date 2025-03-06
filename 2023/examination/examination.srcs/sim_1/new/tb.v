`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 21:08:42
// Design Name: 
// Module Name: tb
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

module tb();
reg clk,rst_n,en;
wire[7:0]min,sec,hour;
wire co;

digital_clk u(clk,rst_n,en,hour,min,sec);

initial begin
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end
	 
initial begin
	rst_n = 1'b0;
	en = 1'b0;
	# 2
	@(negedge clk) 
	rst_n = 1;
	@(negedge clk) 
	en = 1;

end

endmodule
