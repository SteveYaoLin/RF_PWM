`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:01 10/29/2024 
// Design Name: 
// Module Name:    sys_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sys_top # (parameter _RAM_WIDTH = 32)
(
    input sys_clk,
    // input sys_rst_n,
    output io_pulseOut_a,
    output io_pulseOut_b,
    output io_pulseOut_c,
    output io_pulseOut_d,
    output [5:0] led,
    input key
    );

    wire        locked;              
    wire        sys_rst_n;
    wire        rst_n;    
    reg [15:0] temp_cnt =0;

    wire io_defaultLevel;
    wire [_RAM_WIDTH - 1:0] die_period;
    wire [_RAM_WIDTH - 1:0] pulse_period;
    wire io_clk;
    wire io_rst;
    wire pwm_dis;
    wire io_en;
    reg en_d1 = 0;
    reg pulse_begin;

    wire pulse_valid;

    clk_wiz_0 u_pll
    (

    .CLK_OUT1(io_clk),
    // .CLK_OUT2(clk_65m),
             
    .RESET(~key), 
    .LOCKED(locked),
    .CLK_IN1(sys_clk)
    );
    //creted rst_n
//    always @(posedge sys_clk) begin
//        if(temp_cnt == 10000) begin
//            temp_cnt <= temp_cnt;
//        end
//        else begin
//        temp_cnt <= temp_cnt + 1'b1;
//        end
//    end
//    assign sys_rst_n = ((temp_cnt>50)|(temp_cnt<90)) ? 1'b0 : 1'b1;
//	 assign sys_rst_n = key;
    assign rst_n =  locked; 

    assign led[5] = sys_rst_n;
    assign led[4] = ~locked;
	 assign led[3:0] = sig_led[7:4];

    assign io_en = ((temp_cnt>9980)|(temp_cnt<9990)&(locked==1'b1)) ? 1'b1 : 1'b0;

    always @(posedge io_clk) begin
     en_d1 <= io_en;
     pulse_begin <= io_en & ~en_d1 ;
  end
  half_pwm_die #(
    ._RAM_WIDTH(_RAM_WIDTH)
  ) port_ab (
    .io_clk(io_clk),
    .io_rst(io_rst),
    .io_en(pulse_begin|pulse_valid),
    .pwm_dis(pwm_dis),
    .io_pulseOut_a(io_pulseOut_a),
    .io_pulseOut_b(io_pulseOut_b),
    .die_period(die_period),
    .pulse_period(pulse_period),
    .io_defaultLevel(io_defaultLevel),
    .pulse_valid(pulse_valid)
  );
  
  
	assign io_pulseOut_c = 0;
	assign io_pulseOut_d = 0;
	
	assign die_period = 3;
	assign pulse_period = 10;
	
	reg[24:0] counter = 0;//变量led_out 定义为寄存器型
	reg[7:0] sig_led = 0;
//assign led=8'b11111111;
always@(posedge io_clk)
begin
    counter<=counter+1'b1;
	if(counter==25'd25000000)
	begin
		sig_led<=sig_led<<1;// led 向左移位，空闲位自动添0 补位
		counter<=0;//计数器清0
		if(sig_led==8'b0000_0000)//每到时间临界点后,左移一位,一直到8位全部都变为0
		sig_led<=8'b1111_1111;//重新赋值为全1,
	end
	
end
endmodule
