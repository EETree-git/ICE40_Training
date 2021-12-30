module top(
	input					clk_in,		//系统时钟
	input					rst_n_in,	//系统复位，低有效
	output					led			//WS2812彩灯

	);

ws2812	ws2812_u1(
		.clk(clk_in),
		.rst(rst_n_in),
		.led(led)
);

endmodule