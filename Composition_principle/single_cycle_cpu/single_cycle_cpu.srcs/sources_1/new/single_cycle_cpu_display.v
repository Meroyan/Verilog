`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: single_cycle_cpu_display.v
//   > ����  ��������CPU��ʾģ�飬����FPGA���ϵ�IO�ӿںʹ�����
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module single_cycle_cpu_display(
    //ʱ���븴λ�ź�
    input clk,
    input resetn,    //��׺"n"����͵�ƽ��Ч

    //���忪�أ����ڲ�������clk��ʵ�ֵ���ִ��
    input btn_clk,

    //��������ؽӿڣ�����Ҫ����
    output lcd_rst,
    output lcd_cs,
    output lcd_rs,
    output lcd_wr,
    output lcd_rd,
    inout[15:0] lcd_data_io,
    output lcd_bl_ctr,
    inout ct_int,
    inout ct_sda,
    output ct_scl,
    output ct_rstn
    );
//-----{ʱ�Ӻ͸�λ�ź�}begin
//����Ҫ���ģ����ڵ�������
    wire cpu_clk;    //������CPU��ʹ�����忪����Ϊʱ�ӣ���ʵ�ֵ���ִ��
	 reg btn_clk_r1;
	 reg btn_clk_r2;
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            btn_clk_r1<= 1'b0;
        end
        else
        begin
            btn_clk_r1 <= ~btn_clk;
        end

        btn_clk_r2 <= btn_clk_r1;
    end
	 
	 wire clk_en;
    assign clk_en = !resetn || (!btn_clk_r1 && btn_clk_r2);
    BUFGCE cpu_clk_cg(.I(clk),.CE(clk_en),.O(cpu_clk));
//-----{ʱ�Ӻ͸�λ�ź�}end

//-----{���õ�����CPUģ��}begin

    //������FPGA������ʾ���
    wire [31:0] cpu_pc;    //CPU��PC
    wire [31:0] cpu_inst;  //��PCȡ����ָ��
    wire [ 4:0] rf_addr;   //ɨ��Ĵ����ѵĵ�ַ
    wire [31:0] rf_data;   //�Ĵ����Ѵӵ��Զ˿ڶ���������
    reg  [31:0] mem_addr;  //Ҫ�۲���ڴ��ַ
    wire [31:0] mem_data;  //�ڴ��ַ��Ӧ������
    single_cycle_cpu cpu(
        .clk     (cpu_clk   ),
        .resetn  (resetn    ),

        .rf_addr (rf_addr ),
        .mem_addr(mem_addr),
        .rf_data (rf_data ),
        .mem_data(mem_data),
        .cpu_pc  (cpu_pc  ),
        .cpu_inst(cpu_inst)
    );
//-----{���õ�����CPUģ��}end

//---------------------{���ô�����ģ��}begin--------------------//
//-----{ʵ����������}begin
//��С�ڲ���Ҫ����
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5 :0] display_number;
    wire        input_valid;
    wire [31:0] input_value;

//    lcd_module lcd_module(
//        .clk            (clk           ),   //10Mhz
//        .resetn         (resetn        ),

//        //���ô������Ľӿ�
//        .display_valid  (display_valid ),
//        .display_name   (display_name  ),
//        .display_value  (display_value ),
//        .display_number (display_number),
//        .input_valid    (input_valid   ),
//        .input_value    (input_value   ),

//        //lcd��������ؽӿڣ�����Ҫ����
//        .lcd_rst        (lcd_rst       ),
//        .lcd_cs         (lcd_cs        ),
//        .lcd_rs         (lcd_rs        ),
//        .lcd_wr         (lcd_wr        ),
//        .lcd_rd         (lcd_rd        ),
//        .lcd_data_io    (lcd_data_io   ),
//        .lcd_bl_ctr     (lcd_bl_ctr    ),
//        .ct_int         (ct_int        ),
//        .ct_sda         (ct_sda        ),
//        .ct_scl         (ct_scl        ),
//        .ct_rstn        (ct_rstn       )
//    ); 
////-----{ʵ����������}end

//-----{�Ӵ�������ȡ����}begin
//����ʵ����Ҫ��������޸Ĵ�С�ڣ�
//�����ÿһ���������룬��д����һ��always��
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            mem_addr <= 32'd0;
        end
        else if (input_valid)
        begin
            mem_addr <= input_value;
        end
    end
    assign rf_addr = display_number-6'd5;
//-----{�Ӵ�������ȡ����}end

//-----{�������������ʾ}begin
//������Ҫ��ʾ�����޸Ĵ�С�ڣ�
//�������Ϲ���44����ʾ���򣬿���ʾ44��32λ����
//44����ʾ�����1��ʼ��ţ����Ϊ1~44��
    always @(posedge clk)
    begin
        if (display_number >6'd4 && display_number <6'd37 )
        begin  //���5~36��ʾ32��ͨ�üĴ�����ֵ
            display_valid <= 1'b1;
            display_name[39:16] <= "REG";
            display_name[15: 8] <= {4'b0011,3'b000,rf_addr[4]};
            display_name[7 : 0] <= {4'b0011,rf_addr[3:0]}; 
            display_value       <= rf_data;
          end
        else
        begin
            case(display_number)
                6'd1 : //��ʾPCֵ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "   PC";
                    display_value <= cpu_pc;
                end
                6'd2 : //��ʾPCȡ����ָ��
                begin
                    display_valid <= 1'b1;
                    display_name  <= " INST";
                    display_value <= cpu_inst;
                end
                6'd3 : //��ʾҪ�۲���ڴ��ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "MADDR";
                    display_value <= mem_addr;
                end
                6'd4 : //��ʾ���ڴ��ַ��Ӧ������
                begin
                    display_valid <= 1'b1;
                    display_name  <= "MDATA";
                    display_value <= mem_data;
                end
//                6'd5 : //��ʾ���ڴ��ַ��Ӧ������
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG00";
//                    display_value <= 8'h00000000;
//                end
//                6'd6 : //��ʾ���ڴ��ַ��Ӧ������
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG01";
//                    display_value <= 8'h0000001;
//                end
//                6'd7 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG02";
//                    display_value <= 8'h0000010;
//                end
//                6'd8 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG03";
//                    display_value <= 8'h0000011;
//                end
//                6'd9 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG04";
//                    display_value <= 8'h0000004;
//                end
//                6'd10 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG05";
//                    display_value <= 8'h0000000D;
//                end
//                6'd11 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG06";
//                    display_value <= 32'b11111111111111111111111111100010;
//                end
//                6'd12 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG07";
//                    display_value <= 32'b11111111111111111111111111110011;
//                end
//                6'd13 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG08";
//                    display_value <= 8'h00000011;
//                end
//                6'd14 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG09";
//                    display_value <= 8'h00000001;
//                end
//                6'd15 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0A";
//                    display_value <= 8'h00000000;
//                end
//                6'd16 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0B";
//                    display_value <= 8'h00000000;
//                end
//                6'd17 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0C";
//                    display_value <= 8'h00000000;
//                end
//                6'd18 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0D";
//                    display_value <= 8'h00000000;
//                end
//                6'd19 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0E";
//                    display_value <= 32'b11111111111111111111111111111111;
//                end
//                6'd20 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG0F";
//                    display_value <= 32'b1100100000001111;
//                end
//                6'd21 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG10";
//                    display_value <= 8'h00000000;
//                end
//                6'd22 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG11";
//                    display_value <= 8'h00000000;
//                end
//                6'd23 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG12";
//                    display_value <= 8'h00000000;
//                end
//                6'd24 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG13";
//                    display_value <= 8'h00000000;
//                end
//                6'd25 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG14";
//                    display_value <= 8'h00000000;
//                end
//                6'd26 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG15";
//                    display_value <= 8'h00000000;
//                end
//                6'd27 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG16";
//                    display_value <= 8'h00000000;
//                end
//                6'd28 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG17";
//                    display_value <= 8'h00000000;
//                end
//                6'd29 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG18";
//                    display_value <= 8'h00000000;
//                end
//                6'd30 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG19";
//                    display_value <= 8'h00000000;
//                end
//                6'd31 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1A";
//                    display_value <= 8'h00000000;
//                end
//                6'd32 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1B";
//                    display_value <= 8'h00000000;
//                end
//                6'd33 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1C";
//                    display_value <= 8'h00000000;
//                end
//                6'd34 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1D";
//                    display_value <= 8'h00000000;
//                end
//                6'd35 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1E";
//                    display_value <= 8'h00000000;
//                end
//                6'd36 : 
//                begin
//                    display_valid <= 1'b1;
//                    display_name  <= "REG1F";
//                    display_value <= 8'h00000000;
//                end
                
                
                
                default :
                begin
                    display_valid <= 1'b0;
                end
            endcase
        end
    end
//-----{�������������ʾ}end
//----------------------{���ô�����ģ��}end---------------------//
endmodule
