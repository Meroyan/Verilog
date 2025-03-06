`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 18:57:35
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
   reg [7:0]ina,inb;
   wire [7:0]sumab;
   wire sumflag,lessflag,equalflag,bitXorflag;
   wire[15:0]leftshiftA;
   
Calculate c1(ina,inb,sumab,sumflag,leftshiftA,lessflag,equalflag,bitXorflag);

initial begin
    ina=8'b0000_0000;    inb=8'b0000_0000;
end

    always #5 ina=$random% 9'b1_0000_0000;
    always #5 inb=$random% 9'b1_0000_0000;


endmodule
