transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/registerclass.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/DataPath.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/Bus.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/MDR.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/and32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/add32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/div32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/booth_pair_mul.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/neg32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/not32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/or32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/ror32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/rol32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/shl32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/shr32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/shra32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/sub32.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/PCincrementer.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/zero_register.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/RAM.v}
vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/adder.v}

vlog -vlog01compat -work work +incdir+C:/Users/jpbru/Documents/GitHub/ELEC_374 {C:/Users/jpbru/Documents/GitHub/ELEC_374/ld_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  ld_tb

add wave *
view structure
view signals
run -all
