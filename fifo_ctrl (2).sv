/*
 * This module is a control circuit for a FIFO buffer that takes status signals rd and wr, and outputs
 * status signals empty and full to the top-level FIFO module. It takes inputs clk and reset, and outputs
 * the current read and write addresses to the reg_file component of the FIFO. This FIFO is only capable of
 * reading when it is full. 
 */
module fifo_ctrl #(parameter ADDR_WIDTH=4)
                 (clk, reset, rd, wr, empty, full, w_addr, r_addr);

	input  logic clk, reset, rd, wr;
	output logic empty, full;
	output logic [ADDR_WIDTH-1:0] w_addr, r_addr;
	
	// signal declarations
	logic [ADDR_WIDTH-1:0] rd_ptr, rd_ptr_next;
	logic [ADDR_WIDTH-1:0] wr_ptr, wr_ptr_next;
	logic empty_next, full_next;
	
	// output assignments
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;
	
	// fifo controller logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				full   <= 0;
				empty  <= 1;
			end
		else
			begin
				wr_ptr <= wr_ptr_next;
				rd_ptr <= rd_ptr_next;
				full   <= full_next;
				empty  <= empty_next;
			end
	end  // always_ff
	
	// next state logic
	always_comb begin
		// default to keeping the current values
		rd_ptr_next = rd_ptr;
		wr_ptr_next = wr_ptr;
		empty_next = empty;
		full_next = full;
		case ({rd, wr})
			2'b11:  // read and write
				begin
					rd_ptr_next = rd_ptr + 1'b1;
					wr_ptr_next = wr_ptr + 1'b1;
				end
			2'b10:  // read
				if (full) //when read is asserted, it will only read when FIFO is actually full 
					begin
						rd_ptr_next = rd_ptr + 1'b1;
						if (rd_ptr_next == wr_ptr)
							empty_next = 1;
						full_next = 0;
					end
			2'b01:  // write
				if (~full)
					begin
						wr_ptr_next = wr_ptr + 1'b1;
						empty_next = 0;
						if (wr_ptr_next == rd_ptr)
							full_next = 1;
					end
			2'b00: ; // no change
		endcase
	end  // always_comb
	
endmodule
