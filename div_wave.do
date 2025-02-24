onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /div32_tb/DUT/R2/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/R6/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/HI/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/LO/BusMuxOut
add wave -noupdate -radix decimal /div32_tb/DUT/LO/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/RZ/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/RY/BusMuxIn
add wave -noupdate -radix decimal /div32_tb/DUT/alu_inst/ALU_result
add wave -noupdate -radix decimal /div32_tb/DUT/bus/HIreg
add wave -noupdate -radix decimal /div32_tb/DUT/bus/LOreg
add wave -noupdate -radix decimal /div32_tb/DUT/bus/Zreg
add wave -noupdate -radix decimal /div32_tb/DUT/bus/BusMuxInIR
add wave -noupdate -radix decimal /div32_tb/DUT/bus/Zlowout
add wave -noupdate -radix decimal /div32_tb/DUT/bus/Zhighout
add wave -noupdate -radix decimal /div32_tb/DUT/bus/HIout
add wave -noupdate -radix decimal /div32_tb/DUT/bus/LOout
add wave -noupdate -radix decimal /div32_tb/DUT/bus/BusMuxOut
add wave -noupdate -radix decimal /div32_tb/DUT/clock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {224790 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 284
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {50500 ps} {260500 ps}
