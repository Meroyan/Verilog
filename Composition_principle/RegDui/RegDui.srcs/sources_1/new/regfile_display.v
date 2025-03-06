//*************************************************************************
//   > �ļ���: regfile_display.v
//   > ����  ���Ĵ�������ʾģ�飬����FPGA���ϵ�IO�ӿںʹ�����
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module regfile_display(
    //ʱ���븴λ�ź�
    input clk,
    input resetn,    //��׺"n"����͵�ƽ��Ч

    //���뿪�أ����ڲ���дʹ�ܺ�ѡ��������
    input wen,
    input [1:0] input_sel,
    //input_sel2Ϊ0ʱ����ʾд���λ���ݣ�Ϊ1ʱ����ʾд���λ����
    input input_sel2,

    //led�ƣ�����ָʾдʹ���źţ�����������ʲô����
    output led_wen,
    output led_waddr,    //ָʾ����д��ַ
    output led_wdata,    //ָʾ����д����
    output led_raddr1,   //ָʾ�������ַ1
    output led_raddr2,   //ָʾ�������ַ2

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
//-----{LED��ʾ}begin
    assign led_wen    = wen;
    assign led_raddr1 = (input_sel==2'd0);
    assign led_raddr2 = (input_sel==2'd1);
    assign led_waddr  = (input_sel==2'd2);
    assign led_wdata  = (input_sel==2'd3);
//-----{LED��ʾ}end

//-----{���üĴ�����ģ��}begin
    //�Ĵ����Ѷ�����һ�����˿ڣ������ڴ���������ʾ16���Ĵ���ֵ
    wire [63:0] test_data;  
    wire [3 :0] test_addr;

    reg  [3 :0] raddr1;
    reg  [3 :0] raddr2;
    reg  [3 :0] waddr;
    reg  [63:0] wdata;
    wire [63:0] rdata1;
    wire [63:0] rdata2;
    regfile rf_module(
        .clk   (clk   ),
        .wen   (wen   ),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr (waddr ),
        .wdata (wdata ),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .test_addr(test_addr),
        .test_data(test_data)
    );
//-----{���üĴ�����ģ��}end

//---------------------{���ô�����ģ��}begin--------------------//
//-----{ʵ����������}begin
//��С�ڲ���Ҫ����
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5 :0] display_number;
    wire        input_valid;
    wire [31:0] input_value;

    lcd_module lcd_module(
        .clk            (clk           ),   //10Mhz
        .resetn         (resetn        ),

        //���ô������Ľӿ�
        .display_valid  (display_valid ),
        .display_name   (display_name  ),
        .display_value  (display_value ),
        .display_number (display_number),
        .input_valid    (input_valid   ),
        .input_value    (input_value   ),

        //lcd��������ؽӿڣ�����Ҫ����
        .lcd_rst        (lcd_rst       ),
        .lcd_cs         (lcd_cs        ),
        .lcd_rs         (lcd_rs        ),
        .lcd_wr         (lcd_wr        ),
        .lcd_rd         (lcd_rd        ),
        .lcd_data_io    (lcd_data_io   ),
        .lcd_bl_ctr     (lcd_bl_ctr    ),
        .ct_int         (ct_int        ),
        .ct_sda         (ct_sda        ),
        .ct_scl         (ct_scl        ),
        .ct_rstn        (ct_rstn       )
    ); 
//-----{ʵ����������}end

//-----{�Ӵ�������ȡ����}begin
//����ʵ����Ҫ��������޸Ĵ�С�ڣ�
//�����ÿһ���������룬��д����һ��always��
    //16���Ĵ�����ʾ��11~44�ŵ���ʾ�飬�ʶ���ַΪ��display_number-1��
    
    assign test_addr = (display_number-5'd11)>>1;
    //��input_selΪ2'b00ʱ����ʾ������Ϊ����ַ1����raddr1
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            raddr1 <= 4'd0;
        end
        else if (input_valid &&  input_sel==2'd0)
        begin
            raddr1 <= input_value[3:0];
        end
    end
    
    //��input_selΪ2'b01ʱ����ʾ������Ϊ����ַ2����raddr2
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            raddr2 <= 4'd0;
        end
        else if (input_valid && input_sel==2'd1)
        begin
            raddr2 <= input_value[3:0];
        end
    end
    
    //��input_selΪ2'b10ʱ����ʾ������Ϊд��ַ����waddr
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            waddr  <= 4'd0;
        end
        else if (input_valid && input_sel==2'd2)
        begin
            waddr  <= input_value[3:0];
        end
    end
    
    //��input_sel2Ϊ1'b0ʱ����ʾ������Ϊд���ݵĸ�λ����wdata[63:32]
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            wdata[63:32]  <= 32'd0;
        end
        else if (input_valid && input_sel==2'd3 && input_sel2==1'd0)
        begin
            wdata[63:32]  <= input_value;     
        end
    end
    
    //��input_sel2Ϊ1'b1ʱ����ʾ������Ϊд���ݵĵ�λ����wdata[31:0]
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            wdata[31:0]  <= 32'd0;
        end
        else if (input_valid && input_sel==2'd3 && input_sel2==1'd1)
        begin
            wdata[31:0]  <= input_value;     
        end
    end
//-----{�Ӵ�������ȡ����}end

//-----{�������������ʾ}begin
//������Ҫ��ʾ�����޸Ĵ�С�ڣ�
//�������Ϲ���44����ʾ���򣬿���ʾ44��32λ����
//44����ʾ�����1��ʼ��ţ����Ϊ1~44��


    always @(posedge clk)
    begin
        if (display_number >6'd10 && display_number <6'd45 )
        begin //���11~44��ʾ16��ͨ�üĴ�����ֵ
            display_valid <= 1'b1;
            //display_name[39:16] <= "REG";
            //display_name[15: 8] <= {4'b0011,3'b000,test_addr[3]};
            //0011 0000Ϊ48��asc���Ӧ0��0011 0001Ϊ49��asc���Ӧ1
            //display_name[7 : 0] <= {4'b0011,test_addr[3:0]}; 
            //0011 0000Ϊ0��0011 1001Ϊ9
            //display_value       <= test_data;
            
            case(display_number)
                6'd11: begin // ������11����ʾ�Ĵ���0�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_value <= 32'b0; // ��ʾ�Ĵ���0�ĸ�32λ
                end
                6'd12: begin // ������12����ʾ�Ĵ���0�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_value <= 32'b0; // ��ʾ�Ĵ���0�ĵ�32λ
                end
                
                6'd13: begin // ������13����ʾ�Ĵ���1�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���1�ĵ�32λ
                end
                6'd14: begin // ������14����ʾ�Ĵ���1�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���1�ĵ�32λ
                end
                
                6'd15: begin // ������15����ʾ�Ĵ���2�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010Ϊ50��asc���Ӧ2
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���2�ĸ�32λ
                end
                6'd16: begin // ������16����ʾ�Ĵ���2�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010Ϊ50��asc���Ӧ2
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���2�ĵ�32λ
                end
                
                6'd17: begin // ������17����ʾ�Ĵ���3�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011Ϊ51��asc���Ӧ3
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���2�ĸ�32λ
                end
                6'd18: begin // ������18����ʾ�Ĵ���3�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011Ϊ51��asc���Ӧ3
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���3�ĵ�32λ
                end
                
                6'd19: begin // ������19����ʾ�Ĵ���4�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100Ϊ52��asc���Ӧ4
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���4�ĸ�32λ
                end
                6'd20: begin // ������20����ʾ�Ĵ���4�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0011Ϊ51��asc���Ӧ3
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���4�ĵ�32λ
                end
                
                6'd21: begin // ������21����ʾ�Ĵ���5�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101Ϊ53��asc���Ӧ5
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���5�ĸ�32λ
                end
                6'd22: begin // ������22����ʾ�Ĵ���5�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101Ϊ53��asc���Ӧ5
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���5�ĵ�32λ
                end
                
                6'd23: begin // ������23����ʾ�Ĵ���6�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110Ϊ54��asc���Ӧ6
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���6�ĸ�32λ
                end
                6'd24: begin // ������24����ʾ�Ĵ���6�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110Ϊ54��asc���Ӧ6
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���6�ĵ�32λ
                end
                
                6'd25: begin // ������25����ʾ�Ĵ���7�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0111}; 
                    //0011 0111Ϊ55��asc���Ӧ7
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���7�ĸ�32λ
                end
                6'd26: begin // ������26����ʾ�Ĵ���7�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b0111}; 
                    //0011 0111Ϊ55��asc���Ӧ7
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���7�ĵ�32λ
                end
                
                6'd27: begin // ������27����ʾ�Ĵ���8�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b1000}; 
                    //0011 1000Ϊ56��asc���Ӧ8
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���8�ĸ�32λ
                end
                6'd28: begin // ������28����ʾ�Ĵ���8�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b1000}; 
                    //0011 1000Ϊ56��asc���Ӧ8
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���8�ĵ�32λ
                end
                
                6'd29: begin // ������29����ʾ�Ĵ���9�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b1001}; 
                    //0011 1001Ϊ57��asc���Ӧ9
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���9�ĸ�32λ
                end
                6'd30: begin // ������30����ʾ�Ĵ���9�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_name[7:0] <= {4'b0011, 4'b1001}; 
                    //0011 1001Ϊ57��asc���Ӧ9
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���9�ĵ�32λ
                end
                
                6'd31: begin // ������31����ʾ�Ĵ���10�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���10�ĸ�32λ
                end
                6'd32: begin // ������32����ʾ�Ĵ���10�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000Ϊ48��asc���Ӧ0
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���10�ĵ�32λ
                end
                
                6'd33: begin // ������33����ʾ�Ĵ���11�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���11�ĸ�32λ
                end
                6'd34: begin // ������34����ʾ�Ĵ���11�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���11�ĵ�32λ
                end
                
                6'd35: begin // ������35����ʾ�Ĵ���12�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010Ϊ50��asc���Ӧ2
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���12�ĸ�32λ
                end
                6'd36: begin // ������36����ʾ�Ĵ���12�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010Ϊ50��asc���Ӧ2
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���12�ĵ�32λ
                end
                
                6'd37: begin // ������37����ʾ�Ĵ���13�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011Ϊ51��asc���Ӧ3
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���13�ĸ�32λ
                end
                6'd38: begin // ������38����ʾ�Ĵ���13�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011Ϊ51��asc���Ӧ3
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���13�ĵ�32λ
                end
                
                6'd39: begin // ������39����ʾ�Ĵ���14�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100Ϊ52��asc���Ӧ4
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���14�ĸ�32λ
                end
                6'd40: begin // ������40����ʾ�Ĵ���14�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100Ϊ52��asc���Ӧ4
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���14�ĵ�32λ
                end
                
                6'd41: begin // ������41����ʾ�Ĵ���15�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101Ϊ53��asc���Ӧ5
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���15�ĸ�32λ
                end
                6'd42: begin // ������42����ʾ�Ĵ���15�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101Ϊ53��asc���Ӧ5
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���15�ĵ�32λ
                end
                
                6'd43: begin // ������43����ʾ�Ĵ���16�ĸ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110Ϊ54��asc���Ӧ6
                    display_value <= test_data[63:32]; // ��ʾ�Ĵ���16�ĸ�32λ
                end
                6'd44: begin // ������44����ʾ�Ĵ���16�ĵ�32λ
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001Ϊ49��asc���Ӧ1
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110Ϊ54��asc���Ӧ6
                    display_value <= test_data[31:0]; // ��ʾ�Ĵ���16�ĵ�32λ
                end
                
            endcase
        end  
        
        else
        begin
            case(display_number)
                6'd1 : //��ʾ���˿�1�ĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD1";
                    display_value <= raddr1;
                end                
                6'd2 : //��ʾ���˿�2�ĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD2";
                    display_value <= raddr2;
                end                 
                6'd3 : //��ʾ���˿�1�������ݵĸ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT1";
                    display_value <= rdata1[63:32];
                end               
                6'd4 : //��ʾ���˿�1�������ݵĵ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT1";
                    display_value <= rdata1[31:0];
                end
                6'd5 : //��ʾ���˿�2�������ݵĸ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT2";
                    display_value <= rdata2[63:32];
                end
                6'd6 : //��ʾ���˿�2�������ݵĵ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT2";
                    display_value <= rdata2[31:0];
                end
                6'd7 : //��ʾд�˿ڵĵ�ַ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WADDR";
                    display_value <= waddr;
                end
                6'd9 : //��ʾд�˿�д�����ݵĸ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WDATA";
                    display_value <= wdata[63:32];
                end
                6'd10 : //��ʾд�˿�д�����ݵĵ�32λ
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WDATA";
                    display_value <= wdata[31:0];
                end
                
                default :
                begin
                    display_valid <= 1'b0;
                    display_name  <= 40'd0;
                    display_value <= 32'd0;
                end
            endcase
        end
    end
    
    
//-----{�������������ʾ}end
//----------------------{���ô�����ģ��}end---------------------//







endmodule
