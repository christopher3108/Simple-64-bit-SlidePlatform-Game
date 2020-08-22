module part3 #(parameter DATA_WIDTH = 24, N = 32, LOGN = 5) (read_ready, write_ready, rd_left, rd_right, clk, reset, nrd_left, nrd_right);
	input logic read_ready, write_ready, clk, reset;
	input logic signed [23:0] rd_left, rd_right;
	
	output logic signed[23:0] nrd_left, nrd_right;
	
	//read data from fifo buffer only if it is full
	//if not full, continue to fill the buffer
	//only writes or reads from the buffer when read and write ready are
	//asserted
	logic rd, wr;
	logic empty, L_full, R_full, full;

	assign full = L_full & R_full;
	assign wr = read_ready & write_ready;
	assign rd = full & read_ready & write_ready;
	
	//read data from fifo buffers
	logic signed [23:0] fifo_right_output, fifo_left_output,rd_r_div, rd_l_div;
	
	//fifo buffers for left and right channels
	fifo #(DATA_WIDTH, LOGN) memory_right (.clk, .reset, .rd, .wr, .empty, .full(R_full), .w_data(rd_r_div), .r_data(fifo_right_output));
	fifo #(DATA_WIDTH, LOGN) memory_left (.clk, .reset, .rd, .wr, .empty, .full(L_full), .w_data(rd_l_div), .r_data(fifo_left_output));
	
	logic signed [23:0] accumulator_r, accumulator_l;	
	
	//assigns output
	assign nrd_right = full ? rd_r_div - fifo_right_output + accumulator_r : 24'b0;
	assign nrd_left = full ? rd_l_div - fifo_left_output + accumulator_l : 24'b0;

	
	assign rd_r_div = rd_right >>> LOGN;
	assign rd_l_div = rd_left >>> LOGN;
	
	always_ff @(posedge clk) begin
		if(reset)
			begin
				accumulator_r <= 0;
				accumulator_l <= 0;
			end
		else if(write_ready & read_ready)
			begin
				accumulator_r <= nrd_right;
				accumulator_l <= nrd_left;
			end
	end
	
endmodule

module part3_testbench();
	logic read_ready, write_ready, clk, reset;
	logic signed [23:0] rd_left, rd_right;
	logic signed[23:0] nrd_left, nrd_right;
	
	part3 dut(.*);
	
	parameter CLOCK_PERIOD=100; 
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	initial begin
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; read_ready <= 1'b1; write_ready <= 1'b1; rd_left <= 24'd4; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -32; rd_right <= -13; @(posedge clk);
		rd_left <= -12; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -3; rd_right <= 24'd13; @(posedge clk);
		rd_left <= 24'd13; rd_right <= -16; @(posedge clk);
		rd_left <= 24'd12; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -10; rd_right <= 24'd16; @(posedge clk);
		rd_left <= 24'd48; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -32; rd_right <= -13; @(posedge clk);
		rd_left <= -12; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -3; rd_right <= 24'd13; @(posedge clk);
		rd_left <= 24'd13; rd_right <= -16; @(posedge clk);
		rd_left <= 24'd12; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -10; rd_right <= 24'd16; @(posedge clk);
		rd_left <= 24'd48; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -32; rd_right <= -13; @(posedge clk);
		rd_left <= -12; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -3; rd_right <= 24'd13; @(posedge clk);
		rd_left <= 24'd13; rd_right <= -16; @(posedge clk);
		rd_left <= 24'd12; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -10; rd_right <= 24'd16; @(posedge clk);
		rd_left <= 24'd48; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -32; rd_right <= -13; @(posedge clk);
		rd_left <= -12; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -3; rd_right <= 24'd13; @(posedge clk);
		rd_left <= 24'd13; rd_right <= -16; @(posedge clk);
		rd_left <= 24'd12; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -10; rd_right <= 24'd16; @(posedge clk);
		rd_left <= 24'd48; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -32; rd_right <= -13; @(posedge clk);
		rd_left <= -12; rd_right <= 24'd16; @(posedge clk);
		rd_left <= -3; rd_right <= 24'd13; @(posedge clk);
		rd_left <= 24'd13; rd_right <= -16; @(posedge clk);
		rd_left <= 24'd12; rd_right <= 24'd13; @(posedge clk);
		rd_left <= -10; rd_right <= 24'd16; @(posedge clk);
		rd_left <= 24'd48; rd_right <= 24'd13; @(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule 