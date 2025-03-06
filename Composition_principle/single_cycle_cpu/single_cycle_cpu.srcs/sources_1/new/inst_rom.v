`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: inst_rom.v
//   > 描述  ：异步指令存储器模块，采用寄存器搭建而成，类似寄存器堆
//   >         内嵌好指令，只读，异步读
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [4 :0] addr, // 指令地址
    output reg [31:0] inst       // 指令
    );

    wire [31:0] inst_rom[21:0];  // 指令存储器，字节地址7'b000_0000~7'b111_1111
    //------------- 指令编码 ---------|指令地址|--- 汇编指令 -----|- 指令结果 -----//
    assign inst_rom[ 0] = 32'h24010001; // 00H: addiu $1 ,$0,#1   | $1 = 0000_0001H
    //寄存器1的值设置为0001H
    assign inst_rom[ 1] = 32'h00011100; // 04H: sll   $2 ,$1,#4   | $2 = 0000_0010H
    //寄存器1的值逻辑左移两位放到寄存器2中
    assign inst_rom[ 2] = 32'h00411821; // 08H: addu  $3 ,$2,$1   | $3 = 0000_0011H
    //寄存器3=寄存器1+寄存器2
    assign inst_rom[ 3] = 32'h00022082; // 0CH: srl   $4 ,$2,#2   | $4 = 0000_0004H
    //寄存器2的值逻辑右移两位
    assign inst_rom[ 4] = 32'h00642823; // 10H: subu  $5 ,$3,$4   | $5 = 0000_000DH
    //寄存器5=寄存器3-寄存器4
    assign inst_rom[ 5] = 32'hAC250013; // 14H: sw    $5 ,#19($1) | Mem[0000_0014H] = 0000_000DH
    //寄存器5的值存储到内存
    assign inst_rom[ 6] = 32'h00A23027; // 18H: nor   $6 ,$5,$2   | $6 = FFFF_FFE2H
    //寄存器6=寄存器5 按位或非 寄存器2
    assign inst_rom[ 7] = 32'h00C33825; // 1CH: or    $7 ,$6,$3   | $7 = FFFF_FFF3H
    //寄存器7=寄存器6 按位或 寄存器3
    assign inst_rom[ 8] = 32'h00E64026; // 20H: xor   $8 ,$7,$6   | $8 = 0000_0011H
    //寄存器8=寄存器7 按位异或 寄存器6
    assign inst_rom[ 9] = 32'hAC08001C; // 24H: sw    $8 ,#28($0) | Mem[0000_001CH] = 0000_0011H
    //寄存器8的值存储到内存
    assign inst_rom[10] = 32'h00C7482A; // 28H: slt   $9 ,$6,$7   | $9 = 0000_0001H
    //寄存器9=寄存器6与寄存器7比较，小于则置位
    assign inst_rom[11] = 32'h11210002; // 2CH: beq   $9 ,$1,#2   | 跳转到指令34H
    //寄存器9和寄存器1相等则分支，跳转到34H
    assign inst_rom[12] = 32'h24010004; // 30H: addiu $1 ,$0,#4   | 不执行
    //因为发生跳转，所以不执行
    assign inst_rom[13] = 32'h8C2A0013; // 34H: lw    $10,#19($1) | $10 = 0000_000DH
    //19（10）=13（16） ，把13H处的值加载到寄存器 $10 
    assign inst_rom[14] = 32'h15450003; // 38H: bne   $10,$5,#3   | 不跳转
    //寄存器10和寄存器5不等则分支，寄存器5=寄存器10，不跳转
    assign inst_rom[15] = 32'h00415824; // 3CH: and   $11,$2,$1   | $11 = 0000_0000H
    //寄存器11=寄存器2 按位与 寄存器1
    assign inst_rom[16] = 32'hAC0B001C; // 40H: sw    $11,#28($0) | Men[0000_001CH] = 0000_0000H
    //寄存器11的值存到内存中
    assign inst_rom[17] = 32'hAC040010; // 44H: sw    $4 ,#16($0) | Mem[0000_0010H] = 0000_0004H
    //寄存器4的值存到内存中
    assign inst_rom[18] = 32'h3C0C000C; // 48H: lui   $12,#12     | [R12] = 000C_0000H
    //寄存器12=高位装载
    
    assign inst_rom[19] = 32'h00226830; // 4CH: smtu   $13 ,$1,$2   | $13 = 0000_0000H
    //寄存器13=寄存器1和寄存器2相比较，大于等于则置为1
    assign inst_rom[20] = 32'h00417031; // 50H: nand   $14,$2,$1    | $14 = FFFF_FFFFH
    //寄存器14=寄存器2 按位与非 寄存器1
    assign inst_rom[21] = 32'hC80F000C; // 54H: mui    $15,#15     | [R13] = 0000_C80FH
    //寄存器15=低位装载
    
    assign inst_rom[22] = 32'h08000000; // 58H: j     00H         | 跳转指令00H

    //读指令,取4字节
    always @(*)
    begin
        case (addr)
            5'd0 : inst <= inst_rom[0 ];
            5'd1 : inst <= inst_rom[1 ];
            5'd2 : inst <= inst_rom[2 ];
            5'd3 : inst <= inst_rom[3 ];
            5'd4 : inst <= inst_rom[4 ];
            5'd5 : inst <= inst_rom[5 ];
            5'd6 : inst <= inst_rom[6 ];
            5'd7 : inst <= inst_rom[7 ];
            5'd8 : inst <= inst_rom[8 ];
            5'd9 : inst <= inst_rom[9 ];
            5'd10: inst <= inst_rom[10];
            5'd11: inst <= inst_rom[11];
            5'd12: inst <= inst_rom[12];
            5'd13: inst <= inst_rom[13];
            5'd14: inst <= inst_rom[14];
            5'd15: inst <= inst_rom[15];
            5'd16: inst <= inst_rom[16];
            5'd17: inst <= inst_rom[17];
            5'd18: inst <= inst_rom[18];
            5'd19: inst <= inst_rom[19];
            
            5'd20: inst <= inst_rom[20];
            5'd21: inst <= inst_rom[21];
            5'd22: inst <= inst_rom[22];
            
            default: inst <= 32'd0;
        endcase
    end
endmodule