module top(
	input					clk_in,		//系统时钟
	input					rst_n_in,	//系统复位，低有效
	
	output				oled_rst,	//OLCD液晶屏复位
	output				oled_dcn,	//OLCD数据指令控制
	output				oled_clk,	//OLCD时钟信号
	output				oled_dat	//OLCD数据信号

	);


OLED12864	OLED12864_u1 (
			.clk     (clk_in) ,		
			.rst_n   (rst_n_in),		
			
			//.oled_csn(oled_csn),			
			.oled_rst(oled_rst),			
			.oled_dcn(oled_dcn),	
			.oled_clk(oled_clk),	
			.oled_dat(oled_dat)		
);
endmodule