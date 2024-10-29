if {[file exists work]} {
    file delete -force work
}
vlib work
vmap work work
vlog -work work +define+questasim +acc +fullpar tb_half_pulse.v half_pwm_die.v sigpulse.v -l vlog.g
vsim -c -l vsim.log +define+questasim -voptargs=+acc -fsmdebug work.tb_half_pulse

# 1. 在运行 DO 文件后直接进行 2ms 的仿真
run 2ms

# 2. 自动运行 all 子命令，以便将所有信号加入波形图中
add wave -r *