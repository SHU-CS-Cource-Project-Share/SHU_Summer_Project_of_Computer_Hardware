// LED模块
module led_module (
    input              sys_clk   ,       // 系统时钟
    input              sys_rst_n ,       // 系统复位
    input       [3:0]  state     ,       // 交通灯的状态
    input       [3:0]  key       ,       // 模式选择
    output reg  [23:0]  led              // 红黄绿LED灯发光使能
);

//parameter define
parameter  Yellow_Count = 20000;     //让黄灯闪烁的计数次数

//reg define
reg    [24:0]     count;             //让黄灯产生闪烁效果的计数器

//计数时间为0.4ms的计数器，用于让黄灯闪烁(非固定，  依据Yellow_Count参数调整)                                                              
always @(posedge sys_clk or negedge sys_rst_n)begin                                  
    if(!sys_rst_n)                                                                   
        count <= 25'b0;                                                                
    else if (count < Yellow_Count - 1'b1)                                                                                                        
        count <= count + 1'b1;
    else
        count <= 25'b0;
end
                                                                                     
//在交通灯的四个状态里，使相应的led灯发光
always @(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
        led <= 24'b100_100_100_100_100_100_100_100;
    else if(key[0] == 1'b0)
        led <= 24'b010_100_010_100_100_100_100_100;
	 else if(key[1] == 1'b0)
        led <= 24'b100_010_100_010_100_100_100_100;
	 else if(key[2] == 1'b0)
        led <= 24'b001_001_001_001_001_001_001_001;
    else begin
        case(state)
        // led寄存器从高到低分别驱动：北东南西向红绿黄灯以及左转灯
        // 前面四个是直行灯，后面四个是左转灯
        // 100 红灯、010 绿灯、001 黄灯
            4'b0000: led <= 24'b010_100_010_100_100_100_100_100;// 绿灯，红灯，绿灯，红灯，红灯，红灯，红灯，红灯
                                                                                  
            4'b0001: led <= 24'b001_100_001_100_100_100_100_100;// 黄灯，红灯，黄灯，红灯，红灯，红灯，红灯，红灯
				
            4'b0010: led <= 24'b100_100_100_100_010_100_010_100;// 红灯，红灯，红灯，红灯，绿灯，红灯，绿灯，红灯
				
            4'b0011: led <= 24'b100_100_100_100_001_100_001_100;// 红灯，红灯，红灯，红灯，黄灯，红灯，黄灯，红灯
				
			4'b0100: led <= 24'b100_010_100_010_100_100_100_100;// 红灯，绿灯，红灯，绿灯，红灯，红灯，红灯，红灯
				
			4'b0101: led <= 24'b100_001_100_001_100_100_100_100;// 红灯，黄灯，红灯，黄灯，红灯，红灯，红灯，红灯
				
            4'b0110: led <= 24'b100_100_100_100_100_010_100_010;// 红灯，红灯，红灯，红灯，红灯，绿灯，红灯，绿灯
				
            4'b0111: led <= 24'b100_100_100_100_100_001_100_001;// 红灯，红灯，红灯，红灯，红灯，黄灯，红灯，黄灯
				
            default: led <= 24'b010_100_010_100_100_100_100_100;// 第一种情况0000
        endcase
    end
end

endmodule             