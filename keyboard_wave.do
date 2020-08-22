onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /keyboard_input_handler_test/reset
add wave -noupdate /keyboard_input_handler_test/makeBreak
add wave -noupdate /keyboard_input_handler_test/clk
add wave -noupdate /keyboard_input_handler_test/pressed
add wave -noupdate /keyboard_input_handler_test/scanCode
add wave -noupdate /keyboard_input_handler_test/outCode
add wave -noupdate /keyboard_input_handler_test/k1/ps
add wave -noupdate /keyboard_input_handler_test/k1/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
