module breath_led (
	input 				clk,  //12MHz
	input 				rst_n,
	
	output wire [3:0] 	yrgb_led  //YRGB彩灯
	
);

	wire 			pwm_wave;            
	reg 	[24:0] 	cnt1;       //计数器1
	reg		[24:0] 	cnt2;       //计数器2
	reg flag;              //呼吸灯变亮和变暗的标志位
 
	//parameter   CNT_NUM = 2400;	//计数器的最大值 period = (2400^2)*2 ~= 12000000 = 1s由亮到暗0.5s，由暗到亮0.5s
	parameter   CNT_NUM = 3464;	//计数器的最大值 period = (3464^2)*2 ~= 24000000 = 2s由亮到暗1s，由暗到亮1s
	
	//产生计数器cnt1
	always@(posedge clk or negedge rst_n) begin 
		if(!rst_n) begin
			cnt1<=13'd0;
			end 
        else if(cnt1>=CNT_NUM-1) 
				cnt1<=1'b0;
		     else 
                cnt1<=cnt1+1'b1; 
		end
 
	//产生计数器cnt2
	always@(posedge clk or negedge rst_n) begin 
		if(!rst_n) begin
			cnt2<=13'd0;
			flag<=1'b0;
			end 
        else if(cnt1==CNT_NUM-1) begin //当计数器1计满时计数器2开始计数加一或减一
			if(!flag) begin            //当标志位为0时计数器2递增计数，表示呼吸灯效果由暗变亮
				if(cnt2>=CNT_NUM-1)    //计数器2计满时，表示亮度已最大，标志位变高，之后计数器2开始递减
					flag<=1'b1;
				else
					cnt2<=cnt2+1'b1;
				end
			else begin
				if(cnt2<=0)      //当标志位为高时计数器2递减计数
					flag<=1'b0;		   //计数器2级到0，表示亮度已最小，标志位变低，之后计数器2开始递增
				else 	
					cnt2<=cnt2-1'b1;
				end		
			end
		else 
			cnt2<=cnt2;                //计数器1在计数过程中计数器2保持不变
		end	
 
	//比较计数器1和计数器2的值产生自动调整占空比输出的信号，输出到led产生呼吸灯效果
	assign	pwm_wave = (cnt1<cnt2)? 1'b0 : 1'b1;
	
	assign	yrgb_led[0]=pwm_wave;
	assign	yrgb_led[1]=~pwm_wave;
	assign	yrgb_led[2]=pwm_wave;
	assign	yrgb_led[3]=~pwm_wave;

endmodule 
