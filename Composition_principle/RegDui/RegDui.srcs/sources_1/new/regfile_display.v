//*************************************************************************
//   > 文件名: regfile_display.v
//   > 描述  ：寄存器堆显示模块，调用FPGA板上的IO接口和触摸屏
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module regfile_display(
    //时钟与复位信号
    input clk,
    input resetn,    //后缀"n"代表低电平有效

    //拨码开关，用于产生写使能和选择输入数
    input wen,
    input [1:0] input_sel,
    //input_sel2为0时，表示写入高位数据，为1时，表示写入低位数据
    input input_sel2,

    //led灯，用于指示写使能信号，和正在输入什么数据
    output led_wen,
    output led_waddr,    //指示输入写地址
    output led_wdata,    //指示输入写数据
    output led_raddr1,   //指示输入读地址1
    output led_raddr2,   //指示输入读地址2

    //触摸屏相关接口，不需要更改
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
//-----{LED显示}begin
    assign led_wen    = wen;
    assign led_raddr1 = (input_sel==2'd0);
    assign led_raddr2 = (input_sel==2'd1);
    assign led_waddr  = (input_sel==2'd2);
    assign led_wdata  = (input_sel==2'd3);
//-----{LED显示}end

//-----{调用寄存器堆模块}begin
    //寄存器堆多增加一个读端口，用于在触摸屏上显示16个寄存器值
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
//-----{调用寄存器堆模块}end

//---------------------{调用触摸屏模块}begin--------------------//
//-----{实例化触摸屏}begin
//此小节不需要更改
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5 :0] display_number;
    wire        input_valid;
    wire [31:0] input_value;

    lcd_module lcd_module(
        .clk            (clk           ),   //10Mhz
        .resetn         (resetn        ),

        //调用触摸屏的接口
        .display_valid  (display_valid ),
        .display_name   (display_name  ),
        .display_value  (display_value ),
        .display_number (display_number),
        .input_valid    (input_valid   ),
        .input_value    (input_value   ),

        //lcd触摸屏相关接口，不需要更改
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
//-----{实例化触摸屏}end

//-----{从触摸屏获取输入}begin
//根据实际需要输入的数修改此小节，
//建议对每一个数的输入，编写单独一个always块
    //16个寄存器显示在11~44号的显示块，故读地址为（display_number-1）
    
    assign test_addr = (display_number-5'd11)>>1;
    //当input_sel为2'b00时，表示输入数为读地址1，即raddr1
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
    
    //当input_sel为2'b01时，表示输入数为读地址2，即raddr2
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
    
    //当input_sel为2'b10时，表示输入数为写地址，即waddr
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
    
    //当input_sel2为1'b0时，表示输入数为写数据的高位，即wdata[63:32]
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
    
    //当input_sel2为1'b1时，表示输入数为写数据的低位，即wdata[31:0]
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
//-----{从触摸屏获取输入}end

//-----{输出到触摸屏显示}begin
//根据需要显示的数修改此小节，
//触摸屏上共有44块显示区域，可显示44组32位数据
//44块显示区域从1开始编号，编号为1~44，


    always @(posedge clk)
    begin
        if (display_number >6'd10 && display_number <6'd45 )
        begin //块号11~44显示16个通用寄存器的值
            display_valid <= 1'b1;
            //display_name[39:16] <= "REG";
            //display_name[15: 8] <= {4'b0011,3'b000,test_addr[3]};
            //0011 0000为48，ascⅡ对应0，0011 0001为49，ascⅡ对应1
            //display_name[7 : 0] <= {4'b0011,test_addr[3:0]}; 
            //0011 0000为0，0011 1001为9
            //display_value       <= test_data;
            
            case(display_number)
                6'd11: begin // 触摸屏11块显示寄存器0的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000为48，ascⅡ对应0
                    display_value <= 32'b0; // 显示寄存器0的高32位
                end
                6'd12: begin // 触摸屏12块显示寄存器0的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000为48，ascⅡ对应0
                    display_value <= 32'b0; // 显示寄存器0的低32位
                end
                
                6'd13: begin // 触摸屏13块显示寄存器1的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001为49，ascⅡ对应1
                    display_value <= test_data[63:32]; // 显示寄存器1的低32位
                end
                6'd14: begin // 触摸屏14块显示寄存器1的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001为49，ascⅡ对应1
                    display_value <= test_data[31:0]; // 显示寄存器1的低32位
                end
                
                6'd15: begin // 触摸屏15块显示寄存器2的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010为50，ascⅡ对应2
                    display_value <= test_data[63:32]; // 显示寄存器2的高32位
                end
                6'd16: begin // 触摸屏16块显示寄存器2的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010为50，ascⅡ对应2
                    display_value <= test_data[31:0]; // 显示寄存器2的低32位
                end
                
                6'd17: begin // 触摸屏17块显示寄存器3的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011为51，ascⅡ对应3
                    display_value <= test_data[63:32]; // 显示寄存器2的高32位
                end
                6'd18: begin // 触摸屏18块显示寄存器3的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011为51，ascⅡ对应3
                    display_value <= test_data[31:0]; // 显示寄存器3的低32位
                end
                
                6'd19: begin // 触摸屏19块显示寄存器4的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100为52，ascⅡ对应4
                    display_value <= test_data[63:32]; // 显示寄存器4的高32位
                end
                6'd20: begin // 触摸屏20块显示寄存器4的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0011为51，ascⅡ对应3
                    display_value <= test_data[31:0]; // 显示寄存器4的低32位
                end
                
                6'd21: begin // 触摸屏21块显示寄存器5的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101为53，ascⅡ对应5
                    display_value <= test_data[63:32]; // 显示寄存器5的高32位
                end
                6'd22: begin // 触摸屏22块显示寄存器5的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101为53，ascⅡ对应5
                    display_value <= test_data[31:0]; // 显示寄存器5的低32位
                end
                
                6'd23: begin // 触摸屏23块显示寄存器6的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110为54，ascⅡ对应6
                    display_value <= test_data[63:32]; // 显示寄存器6的高32位
                end
                6'd24: begin // 触摸屏24块显示寄存器6的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110为54，ascⅡ对应6
                    display_value <= test_data[31:0]; // 显示寄存器6的低32位
                end
                
                6'd25: begin // 触摸屏25块显示寄存器7的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0111}; 
                    //0011 0111为55，ascⅡ对应7
                    display_value <= test_data[63:32]; // 显示寄存器7的高32位
                end
                6'd26: begin // 触摸屏26块显示寄存器7的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b0111}; 
                    //0011 0111为55，ascⅡ对应7
                    display_value <= test_data[31:0]; // 显示寄存器7的低32位
                end
                
                6'd27: begin // 触摸屏27块显示寄存器8的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b1000}; 
                    //0011 1000为56，ascⅡ对应8
                    display_value <= test_data[63:32]; // 显示寄存器8的高32位
                end
                6'd28: begin // 触摸屏28块显示寄存器8的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b1000}; 
                    //0011 1000为56，ascⅡ对应8
                    display_value <= test_data[31:0]; // 显示寄存器8的低32位
                end
                
                6'd29: begin // 触摸屏29块显示寄存器9的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b1001}; 
                    //0011 1001为57，ascⅡ对应9
                    display_value <= test_data[63:32]; // 显示寄存器9的高32位
                end
                6'd30: begin // 触摸屏30块显示寄存器9的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0000};
                    //0011 0000为48，ascⅡ对应0
                    display_name[7:0] <= {4'b0011, 4'b1001}; 
                    //0011 1001为57，ascⅡ对应9
                    display_value <= test_data[31:0]; // 显示寄存器9的低32位
                end
                
                6'd31: begin // 触摸屏31块显示寄存器10的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000为48，ascⅡ对应0
                    display_value <= test_data[63:32]; // 显示寄存器10的高32位
                end
                6'd32: begin // 触摸屏32块显示寄存器10的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0000}; 
                    //0011 0000为48，ascⅡ对应0
                    display_value <= test_data[31:0]; // 显示寄存器10的低32位
                end
                
                6'd33: begin // 触摸屏33块显示寄存器11的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001为49，ascⅡ对应1
                    display_value <= test_data[63:32]; // 显示寄存器11的高32位
                end
                6'd34: begin // 触摸屏34块显示寄存器11的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0001}; 
                    //0011 0001为49，ascⅡ对应1
                    display_value <= test_data[31:0]; // 显示寄存器11的低32位
                end
                
                6'd35: begin // 触摸屏35块显示寄存器12的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010为50，ascⅡ对应2
                    display_value <= test_data[63:32]; // 显示寄存器12的高32位
                end
                6'd36: begin // 触摸屏36块显示寄存器12的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0010}; 
                    //0011 0010为50，ascⅡ对应2
                    display_value <= test_data[31:0]; // 显示寄存器12的低32位
                end
                
                6'd37: begin // 触摸屏37块显示寄存器13的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011为51，ascⅡ对应3
                    display_value <= test_data[63:32]; // 显示寄存器13的高32位
                end
                6'd38: begin // 触摸屏38块显示寄存器13的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0011}; 
                    //0011 0011为51，ascⅡ对应3
                    display_value <= test_data[31:0]; // 显示寄存器13的低32位
                end
                
                6'd39: begin // 触摸屏39块显示寄存器14的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100为52，ascⅡ对应4
                    display_value <= test_data[63:32]; // 显示寄存器14的高32位
                end
                6'd40: begin // 触摸屏40块显示寄存器14的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0100}; 
                    //0011 0100为52，ascⅡ对应4
                    display_value <= test_data[31:0]; // 显示寄存器14的低32位
                end
                
                6'd41: begin // 触摸屏41块显示寄存器15的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101为53，ascⅡ对应5
                    display_value <= test_data[63:32]; // 显示寄存器15的高32位
                end
                6'd42: begin // 触摸屏42块显示寄存器15的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0101}; 
                    //0011 0101为53，ascⅡ对应5
                    display_value <= test_data[31:0]; // 显示寄存器15的低32位
                end
                
                6'd43: begin // 触摸屏43块显示寄存器16的高32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110为54，ascⅡ对应6
                    display_value <= test_data[63:32]; // 显示寄存器16的高32位
                end
                6'd44: begin // 触摸屏44块显示寄存器16的低32位
                    display_name[39:16] <= "REG";
                    display_name[15:8] <= {4'b0011, 4'b0001};
                    //0011 0001为49，ascⅡ对应1
                    display_name[7:0] <= {4'b0011, 4'b0110}; 
                    //0011 0110为54，ascⅡ对应6
                    display_value <= test_data[31:0]; // 显示寄存器16的低32位
                end
                
            endcase
        end  
        
        else
        begin
            case(display_number)
                6'd1 : //显示读端口1的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD1";
                    display_value <= raddr1;
                end                
                6'd2 : //显示读端口2的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RADD2";
                    display_value <= raddr2;
                end                 
                6'd3 : //显示读端口1读出数据的高32位
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT1";
                    display_value <= rdata1[63:32];
                end               
                6'd4 : //显示读端口1读出数据的低32位
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT1";
                    display_value <= rdata1[31:0];
                end
                6'd5 : //显示读端口2读出数据的高32位
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT2";
                    display_value <= rdata2[63:32];
                end
                6'd6 : //显示读端口2读出数据的低32位
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDAT2";
                    display_value <= rdata2[31:0];
                end
                6'd7 : //显示写端口的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WADDR";
                    display_value <= waddr;
                end
                6'd9 : //显示写端口写入数据的高32位
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WDATA";
                    display_value <= wdata[63:32];
                end
                6'd10 : //显示写端口写入数据的低32位
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
    
    
//-----{输出到触摸屏显示}end
//----------------------{调用触摸屏模块}end---------------------//







endmodule
