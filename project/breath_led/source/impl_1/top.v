module top(
	input			clk_in,
	input			rst_n,
	output  [3:0] 	yrgb_led

);

breath_led breath_led_u1(
	.clk	(clk_in),  //12MHz
	.rst_n	(rst_n),
	.yrgb_led	(yrgb_led)  //RGBÈýÉ«µÆ
	
);




endmodule