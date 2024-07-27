vlib work
vlog mux_4_to_1.v Reg_Mux.v Spartan6_DSP48A1.v Spartan6_DSP48A1_tb.v
vsim -voptargs=+acc work.Spartan6_DSP48A1_tb
add wave *
run -all
#quit -sim