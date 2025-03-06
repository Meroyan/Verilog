`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 18:36:06
// Design Name: 
// Module Name: mult32
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


module mult32(input [32:1]ina,
              input [32:1]inb,
              output [64:1]c,
              output [64:1]d
);
    
integer i;
reg[64:1] temp;

always@(ina or inb)
begin
    temp=0;
    for(i=1;i<=32;i=i+1)
        if(inb[i]==1)
            temp=temp+(ina<<(i-1));

end
    
    assign c=temp;
    assign d=ina*inb;
endmodule
