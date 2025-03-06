`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/08 20:42:01
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
    reg ina,inb,inc;
    wire outs,outc;
    myadder myunit(ina,inb,inc,outs,outc);
    
    initial begin
        ina=1'b0;  inb=1'b0;  inc=1'b0;
    end
    
    always #2 ina=~ina;
    always #3 inb=~inb;
    always #5 inc=~inc;
    
    endmodule
