module breath_led (
	input 				clk,  //12MHz
	input 				rst_n,
	
	output wire [3:0] 	yrgb_led  //YRGB�ʵ�
	
);

	wire 			pwm_wave;            
	reg 	[24:0] 	cnt1;       //������1
	reg		[24:0] 	cnt2;       //������2
	reg flag;              //�����Ʊ����ͱ䰵�ı�־λ
 
	//parameter   CNT_NUM = 2400;	//�����������ֵ period = (2400^2)*2 ~= 12000000 = 1s��������0.5s���ɰ�����0.5s
	parameter   CNT_NUM = 3464;	//�����������ֵ period = (3464^2)*2 ~= 24000000 = 2s��������1s���ɰ�����1s
	
	//����������cnt1
	always@(posedge clk or negedge rst_n) begin 
		if(!rst_n) begin
			cnt1<=13'd0;
			end 
        else if(cnt1>=CNT_NUM-1) 
				cnt1<=1'b0;
		     else 
                cnt1<=cnt1+1'b1; 
		end
 
	//����������cnt2
	always@(posedge clk or negedge rst_n) begin 
		if(!rst_n) begin
			cnt2<=13'd0;
			flag<=1'b0;
			end 
        else if(cnt1==CNT_NUM-1) begin //��������1����ʱ������2��ʼ������һ���һ
			if(!flag) begin            //����־λΪ0ʱ������2������������ʾ������Ч���ɰ�����
				if(cnt2>=CNT_NUM-1)    //������2����ʱ����ʾ��������󣬱�־λ��ߣ�֮�������2��ʼ�ݼ�
					flag<=1'b1;
				else
					cnt2<=cnt2+1'b1;
				end
			else begin
				if(cnt2<=0)      //����־λΪ��ʱ������2�ݼ�����
					flag<=1'b0;		   //������2����0����ʾ��������С����־λ��ͣ�֮�������2��ʼ����
				else 	
					cnt2<=cnt2-1'b1;
				end		
			end
		else 
			cnt2<=cnt2;                //������1�ڼ��������м�����2���ֲ���
		end	
 
	//�Ƚϼ�����1�ͼ�����2��ֵ�����Զ�����ռ�ձ�������źţ������led����������Ч��
	assign	pwm_wave = (cnt1<cnt2)? 1'b0 : 1'b1;
	
	assign	yrgb_led[0]=pwm_wave;
	assign	yrgb_led[1]=~pwm_wave;
	assign	yrgb_led[2]=pwm_wave;
	assign	yrgb_led[3]=~pwm_wave;

endmodule 
