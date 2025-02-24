onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /mul64_tb/DUT/R2/BusMuxOut
add wave -noupdate -radix decimal /mul64_tb/DUT/R2/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/R2/q
add wave -noupdate -radix decimal /mul64_tb/DUT/R6/BusMuxOut
add wave -noupdate -radix decimal /mul64_tb/DUT/R6/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/R6/q
add wave -noupdate -radix decimal /mul64_tb/DUT/HI/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/LO/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/PC/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/RZ/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/IR/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/mdr_inst/MDMux
add wave -noupdate -radix decimal /mul64_tb/DUT/mdr_inst/MDatain
add wave -noupdate -radix decimal /mul64_tb/DUT/mdr_inst/clock
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInR2
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInR6
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInPC
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInIR
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInMAR
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxInMDR
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/Zreg
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/Yreg
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/R2out
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/R6out
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/Zlowout
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/Zhighout
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/Yout
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/MARout
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/MDRout
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/BusMuxOut
add wave -noupdate -radix decimal /mul64_tb/DUT/bus/q
add wave -noupdate -radix decimal /mul64_tb/DUT/PC/BusMuxOut
add wave -noupdate -radix decimal /mul64_tb/DUT/PC/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/pcInc/PCreg
add wave -noupdate -radix decimal /mul64_tb/DUT/pcInc/PCincremented
add wave -noupdate -radix decimal /mul64_tb/DUT/pcInc/increment_value
add wave -noupdate -radix decimal /mul64_tb/DUT/pcInc/incremented_PC
add wave -noupdate -radix decimal /mul64_tb/DUT/LO/BusMuxIn
add wave -noupdate -radix decimal /mul64_tb/DUT/HI/BusMuxOut
add wave -noupdate -radix decimal /mul64_tb/DUT/HI/BusMuxIn
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
