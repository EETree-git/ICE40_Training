module top(
	input					clk_in,		//ϵͳʱ��
	input					rst_n_in,	//ϵͳ��λ������Ч
	output					led			//WS2812�ʵ�

	);

ws2812	ws2812_u1(
		.clk(clk_in),
		.rst(rst_n_in),
		.led(led)
);

endmodule