module top(
	input					clk_in,		//ϵͳʱ��
	input					rst_n_in,	//ϵͳ��λ������Ч
	
	output				oled_rst,	//OLCDҺ������λ
	output				oled_dcn,	//OLCD����ָ�����
	output				oled_clk,	//OLCDʱ���ź�
	output				oled_dat	//OLCD�����ź�

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