/*
 * This module combines a control and register file to form a fifo buffer. It takes clock, reset, 
 * read, and write as input signals to operate. It outputs empty and full as status signals to
 * indicate if the buffer is empty or full. The module also takes write data as input and outputs
 * read data. FIFO data width and number of addresses are adjustable in the parameter. This Fifo is only
 * capable of reading new values when it is full, and either both read and write are asserted or only read
 * is asserted. 
 */


module fifo #(parameter DATA_WIDTH=8, ADDR_WIDTH=4)
            (clk, reset, rd, wr, empty, full, w_data, r_data);

	input  logic clk, reset, rd, wr;
	output logic empty, full;
	input  logic signed[DATA_WIDTH-1:0] w_data;
	output logic signed[DATA_WIDTH-1:0] r_data;
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	logic w_en;
	
	// enable write only when FIFO is not full
	assign w_en = wr & (~full | rd);
	
	// instantiate FIFO controller and register file
	fifo_ctrl #(ADDR_WIDTH) c_unit (.*);
	reg_file #(DATA_WIDTH, ADDR_WIDTH) r_unit (.*);
	
endmodule