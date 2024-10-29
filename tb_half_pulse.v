module tb_half_pulse ();
 // 宏定义
  parameter _RAM_WIDTH = 32;
  parameter PWM_PULSE_WIDTH = 10000; // 单位为纳秒，代表1us的PWM脉冲宽度
  parameter clock_period = 5;

   // 输入输出信号
  reg io_clk;
  reg io_rst;
  reg pwm_dis;
  reg io_en;
  reg pulse_begin;
//   wire io_defaultLevel;
//   reg [_RAM_WIDTH - 1:0] io_pulseWidth;
  reg io_defaultLevel;
    reg [_RAM_WIDTH - 1:0] die_period;
    reg [_RAM_WIDTH - 1:0] pulse_period;

  //
    wire pulse_valid;
    
    wire io_pulseOut_a;
    wire io_pulseOut_b;

  reg en_d1;
  // 实例化DUT
  half_pwm_die #(
    ._RAM_WIDTH(_RAM_WIDTH)
  ) uut (
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

  // 时钟生成
  initial begin
    io_clk = 0;
    forever #(clock_period/2) io_clk = ~io_clk; // 生成200MHz的时钟信号
  end
  always @(posedge io_clk) begin
     en_d1 <= io_en;
     pulse_begin <= io_en & ~en_d1 ;
  end
  initial begin
    // 初始化信号
    io_rst = 1;
    io_en = 0;
    en_d1 = 0;
    pwm_dis =0;
    io_defaultLevel = 0;
    die_period = 3;
    pulse_period = 5;
    #200; // 等待几个时钟周期以稳定信号
    io_rst = 0; // 释放复位
    #20;        
    start_sigpulse;
    @(posedge pulse_valid)
    #1000 start_sigpulse;
      
    

  end

  // 生成PWM信号的函数
  task start_sigpulse ;
    //input io_defaultLevel;
    // input  [_RAM_WIDTH-1 :0] period;
    // output pwm_out;
    begin
      io_en = 1;
      #20; // 保持一段时间
      $display("pulus_access !");
      io_en = 0;
      // #(period/2);
    end
  endtask
  endmodule