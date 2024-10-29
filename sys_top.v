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
    output [7:0] led,
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
    wire pulse_begin;

    wire pulse_valid;

    clk_wiz_0 u_pll
    (

    .CLK_OUT1(io_clk),
    // .CLK_OUT2(clk_65m),
             
    .RESET(~sys_rst_n), 
    .LOCKED(locked),
    .CLK_IN1(sys_clk)
    );
    //creted rst_n
    always @(posedge sys_clk) begin
        if(temp_cnt = 10000) begin
            temp_cnt <= temp_cnt;
        end
        else begin
        temp_cnt <= temp_cnt + 1'b1;
        end
    end
    assign sys_rst_n = ((temp_cnt>50)|(temp_cnt<90)) ? 1'b0 : 1'b1;
    assign rst_n =  locked; 

    assign led[0] = 1'b1;
    assign led[1] = 1'b0;

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
  
endmodule
