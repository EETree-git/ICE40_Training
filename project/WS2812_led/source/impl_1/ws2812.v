module ws2812
(
	input		clk,
	input		rst,
	output	led

);
//clk 12M
parameter	T0H = 6'd4;
parameter	T0L = 6'd12;//0��ĸߵ͵�ƽʱ��
parameter	T1H = 6'd12;
parameter	T1L = 6'd4;//1��
parameter  cnt_time_max = 1_500_000;

parameter	RST = 14'd3600;//��λʱ��


parameter LED_1 = 25'b00000_0000_0000_0000_0001_0000;//��
parameter LED_2 = 25'b00000_0000_0000_0000_0001_0000;//��
parameter LED_3 = 25'b00000_0000_0000_0000_0001_0000;//��
parameter LED_4 = 25'b00000_0000_0001_0000_0000_0000;//��
parameter LED_5 = 25'b00000_0000_0001_0000_0000_0000;//��
parameter LED_6 = 25'b00000_0000_0001_0000_0000_0000;//��
parameter LED_7 = 25'b00001_0000_0000_0000_0000_0000;//����ȡֵ��0-23Ϊ��λ����λGRB��˳��
parameter LED_8 = 25'b00001_0000_0000_0000_0000_0000;//��25λ������ӣ�����bit_cnt��24��0
//FSM 16��LED��һ����λ״̬
parameter IDLE        = 16'b0000_0000_0000_0000;
parameter LED_one     = 16'b0000_0000_0000_0001;
parameter LED_two     = 16'b0000_0000_0000_0010;
parameter LED_thr     = 16'b0000_0000_0000_0100;
parameter LED_fou     = 16'b0000_0000_0000_1000;
parameter LED_fiv     = 16'b0000_0000_0001_0000;
parameter LED_six     = 16'b0000_0000_0010_0000;
parameter LED_sev     = 16'b0000_0000_0100_0000;
parameter LED_eig     = 16'b0000_0000_1000_0000;
parameter LED_nin     = 16'b0000_0001_0000_0000;
parameter LED_ten     = 16'b0000_0010_0000_0000;
parameter LED_ele     = 16'b0000_0100_0000_0000;
parameter LED_twe     = 16'b0000_1000_0000_0000;
parameter RST_FSM     = 16'b1100_0000_0000_0000;
reg [15:0] state;
reg [15:0] state_n;//״̬

reg 	[6:0] cycle_cnt;//���ڼ���
reg    led_pwm;//  Led ���
reg    shift;//24λ��λ���
reg    state_tran;//״̬ת�Ƶ�һ��led�����һ��
reg	 state_tran_rst;//״̬ת�ƣ���λ��LEd+
reg [13:0]  rst_cnt;//��λ���
reg [4:0]  bit_cnt;//��24λ���м�����λ
reg	[23:0]	cnt_time;
reg	[24:0]	ledcolor1,ledcolor2,ledcolor3,ledcolor4,ledcolor5,ledcolor6;
//��Ȧ��ת
always@(posedge clk or negedge rst ) begin
	if(!rst)begin
		cnt_time<=24'b0;
		ledcolor1<=LED_1;
		ledcolor2<=LED_2;
		ledcolor3<=LED_3;
		ledcolor4<=LED_4;
		ledcolor5<=LED_5;
		ledcolor6<=LED_6;
	end
	else if(cnt_time == cnt_time_max - 1'b1)begin
		cnt_time<=24'b0;
		ledcolor1<=ledcolor6;
		ledcolor2<=ledcolor1;
		ledcolor3<=ledcolor2;
		ledcolor4<=ledcolor3;
		ledcolor5<=ledcolor4;
		ledcolor6<=ledcolor5;
	end
	else 
		cnt_time<=cnt_time+1'b1;
end 


//LEd���ݸߵ����ڣ�һ��0/1�����ʱ��
always @(posedge clk or negedge rst)
begin
if(!rst)
	cycle_cnt <= 7'd0;
else if(cycle_cnt == (T0H + T0L - 6'd1))
	cycle_cnt <= 7'd0;
else if(state != RST_FSM)//һ�ִ�����������λ�����
	cycle_cnt <= cycle_cnt + 1'b1;
else
	cycle_cnt <= 7'd0;
end



//FSM 1
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		state <= IDLE;
	else
		state <= state_n;
end

//FSM 2  ״̬���
always @ (posedge clk or negedge rst)
begin
	if(!rst)
		begin
		led_pwm <= 1'b0;
		shift <= 1'b0;
		end
	else 
	begin
		case(state)
		
		IDLE :
				begin 
				led_pwm <= 1'b1;
				end
		LED_one:
				begin
				shift <= ledcolor1[bit_cnt];//����cnt�ļ������任0/1,
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_two:
				begin
				shift <= ledcolor1[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end	
		LED_thr:
				begin
				shift <= ledcolor2[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_fou:
				begin
				shift <= ledcolor2[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end					
		LED_fiv:
				begin
				shift <= ledcolor3[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_six:
				begin
				shift <= ledcolor3[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end	
		LED_sev:
				begin
				shift <= ledcolor4[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_eig:
				begin
				shift <= ledcolor4[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_nin:
				begin
				shift <= ledcolor5[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_ten:
				begin
				shift <= ledcolor5[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_ele:
				begin
				shift <= ledcolor6[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
		LED_twe:
				begin
				shift <= ledcolor6[bit_cnt];
				if(shift == 1'b1)
					begin
						if(cycle_cnt == T1H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				else
					begin
						if(cycle_cnt == T0H)
						led_pwm <= 1'b0;
						else if(cycle_cnt == (T1H + T0H - 6'd1))
						led_pwm <= 1'b1;
						else
						led_pwm <= led_pwm;
					end
				end
				
		RST_FSM:
				begin
					led_pwm <= 1'b0;
				end
				
		default:
				begin
					led_pwm <= 1'b0;
				end
		endcase
		end
end

assign led = led_pwm;


//FSM  3  ״̬ת��
always @ (*)
begin
	case (state)
	IDLE:
			state_n = LED_one;
	LED_one:
			begin
			if(state_tran)
			state_n = LED_two;
			else
			state_n = state;
			end
	LED_two:
			begin
			if(state_tran)
			state_n = LED_thr;
			else
			state_n = state;
			end
	LED_thr:
			begin
			if(state_tran)
			state_n = LED_fou;
			else
			state_n = state;
			end
	LED_fou:
			begin
			if(state_tran)
			state_n = LED_fiv;
			else
			state_n = state;
			end
	LED_fiv:
			begin
			if(state_tran)
			state_n = LED_six;
			else
			state_n = state;
			end
	LED_six:
			begin
			if(state_tran)
			state_n = LED_sev;
			else
			state_n = state;
			end
	LED_sev:
			begin
			if(state_tran)
			state_n = LED_eig;
			else
			state_n = state;
			end
	LED_eig:
			begin
			if(state_tran)
			state_n = LED_nin;
			else
			state_n = state;
			end
	LED_nin:
			begin
			if(state_tran)
			state_n = LED_ten;
			else
			state_n = state;
			end
	LED_ten:
			begin
			if(state_tran)
			state_n = LED_ele;
			else
			state_n = state;
			end
	LED_ele:
			begin
			if(state_tran)
			state_n = LED_twe;
			else
			state_n = state;
			end
	LED_twe:
			begin
			if(state_tran)
			state_n = RST_FSM;
			else
			state_n = state;
			end
	
	RST_FSM:
			begin
			if(state_tran_rst)
			state_n = IDLE;
			else
			state_n = state;
			end
	default:
			state_n =RST_FSM;
	endcase
end

	
	


//��¼24λ��ʱ�䣬����ת��״̬led
always @(posedge clk or negedge rst)
begin
	if(!rst)
		begin
		bit_cnt <= 5'd0;
		state_tran <= 1'b0;
		end
	else if (bit_cnt == 5'd24)
		begin
		bit_cnt <= 5'd0;
		state_tran <= 1'b1;
		end
	else if(cycle_cnt == (T0H + T0L - 6'd1))
		begin
		bit_cnt <= bit_cnt + 1'b1;
		state_tran <= 1'b0;
		end
	else
		begin
		bit_cnt <= bit_cnt;
		state_tran <= 1'b0;
		end
end
//��¼rst��ʱ�䣬״̬ת��
always @(posedge clk or negedge rst)
begin
	if(!rst)
		rst_cnt <= 14'd0;
	else if(state == RST_FSM)
		rst_cnt <= rst_cnt + 1'b1;
	else
		rst_cnt <= 14'd0;
end
 //rst��ʱ��һ���ͷ�״̬ת���źţ���ʼ��һ��
always @(posedge clk or negedge rst)
begin
	if(!rst)
	state_tran_rst <= 1'b0;
	else if(rst_cnt == RST)
	state_tran_rst <=1'b1;
	else
	state_tran_rst <= 1'b0;
end


		




endmodule

