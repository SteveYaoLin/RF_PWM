module half_pwm_die #(
    parameter _RAM_WIDTH = 32
)
(
    input io_clk,
    input io_rst,
    input io_en,
    input pwm_dis,
    output io_pulseOut_a,
    output io_pulseOut_b,
    input io_defaultLevel,  
    input [_RAM_WIDTH - 1:0] die_period,
    input [_RAM_WIDTH - 1:0] pulse_period,
    output pulse_valid
);
    wire die_a_pulse ;
    wire die_b_pulse ;
    wire die_pulse_a_last;
    wire die_pulse_b_last;

    wire pulse_a_last;
    wire pulse_b_last;
    
 sigpulse #(
    ._RAM_WIDTH(_RAM_WIDTH)
 ) u_die_a (
    .io_clk(io_clk),
    .io_rst(io_rst),
    .io_en(io_en),
    .pwm_dis(pwm_dis),
    .io_pulseOut(die_a_pulse),
    .io_pulseWidth(die_period),
    .io_defaultLevel(io_defaultLevel),
    .pulse_valid(die_pulse_a_last)
  );

  sigpulse #(
    ._RAM_WIDTH(_RAM_WIDTH)
  ) u_pulse_a (
    .io_clk(io_clk),
    .io_rst(io_rst),
    .io_en(die_pulse_a_last),
    .pwm_dis(pwm_dis),
    .io_pulseOut(io_pulseOut_a),
    .io_pulseWidth(pulse_period),
    .io_defaultLevel(io_defaultLevel),
    .pulse_valid(pulse_a_last)
  );

   sigpulse #(
    ._RAM_WIDTH(_RAM_WIDTH)
 ) u_die_b (
    .io_clk(io_clk),
    .io_rst(io_rst),
    .io_en(pulse_a_last),
    .pwm_dis(pwm_dis),
    .io_pulseOut(die_b_pulse),
    .io_pulseWidth(die_period),
    .io_defaultLevel(io_defaultLevel),
    .pulse_valid(die_pulse_b_last)
  );

  sigpulse #(
    ._RAM_WIDTH(_RAM_WIDTH)
  ) u_pulse_b (
    .io_clk(io_clk),
    .io_rst(io_rst),
    .io_en(die_pulse_b_last),
    .pwm_dis(pwm_dis),
    .io_pulseOut(io_pulseOut_b),
    .io_pulseWidth(pulse_period),
    .io_defaultLevel(io_defaultLevel),
    .pulse_valid(pulse_b_last)
  );
  assign pulse_valid = pulse_b_last ;
endmodule