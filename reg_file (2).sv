/*
 * This module represents a register with parameterized data width and address widths.
 * It takes inputs clock, write data, write enable, write address, read address, and
 * read data. It stores the values and has synchronous write and asynchronous read. 
 */
module reg_file #(parameter DATA_WIDTH=8, ADDR_WIDTH=2)
                (clk, w_data, w_en, w_addr, r_addr, r_data);

	input  logic clk, w_en;
	input  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	input  logic signed[DATA_WIDTH-1:0] w_data;
	output logic signed[DATA_WIDTH-1:0] r_data;
	
	// array declaration (registers)
	logic [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];
	
	// write operation (synchronous)
	always_ff @(posedge clk) begin
	   if (w_en)
		   array_reg[w_addr] <= w_data;
	end
	
	//read operation (asynchronous)
	assign r_data = array_reg[r_addr];
	
endmodule
