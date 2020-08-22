module part2 (read_ready, write_ready, rd_left, rd_right, clk, reset, nrd_left, nrd_right);
	input logic signed[23:0]rd_left, rd_right;
	input logic clk, reset, read_ready, write_ready;
	output logic signed[23:0]nrd_left, nrd_right;
	
	logic signed[23:0] nrd_left2, nrd_right2, nrd_left3, nrd_right3, nrd_left4, nrd_right4, nrd_left5, nrd_right5, nrd_left6, nrd_right6, nrd_left7, nrd_right7, nrd_left8, nrd_right8;
	
	always_ff@(posedge clk) begin
		if(reset) begin
			nrd_left2 <= 24'd0;
			nrd_left3 <= 24'd0;
			nrd_left4 <= 24'd0;
			nrd_left5 <= 24'd0;
			nrd_left6 <= 24'd0;
			nrd_left7 <= 24'd0;
			nrd_left8 <= 24'd0;
			
			nrd_right2 <= 24'd0;
			nrd_right3 <= 24'd0;
			nrd_right4 <= 24'd0;
			nrd_right5 <= 24'd0;
			nrd_right6 <= 24'd0;
			nrd_right7 <= 24'd0;
			nrd_right8 <= 24'd0;
		end else if(write_ready && read_ready) begin
			nrd_left2 <= rd_left;
			nrd_left3 <= nrd_left2;
			nrd_left4 <= nrd_left3;
			nrd_left5 <= nrd_left4;
			nrd_left6 <= nrd_left5;
			nrd_left7 <= nrd_left6;
			nrd_left8 <= nrd_left7;
			
			nrd_right2 <= rd_right;
			nrd_right3 <= nrd_right2;
			nrd_right4 <= nrd_right3;
			nrd_right5 <= nrd_right4;
			nrd_right6 <= nrd_right5;
			nrd_right7 <= nrd_right6;
			nrd_right8 <= nrd_right7;
		end
	end
	
	assign nrd_left = ((rd_left >>> 3) + (nrd_left2 >>> 3) + (nrd_left3 >>> 3) + (nrd_left4 >>> 3) + (nrd_left5 >>> 3) + (nrd_left6 >>> 3) + (nrd_left7 >>> 3) + (nrd_left8 >>> 3));
	assign nrd_right = ((rd_right >>> 3) + (nrd_right2 >>> 3) + (nrd_right3 >>> 3) + (nrd_right4 >>> 3) + (nrd_right5 >>> 3) + (nrd_right6 >>> 3) + (nrd_right7 >>> 3) + (nrd_right8 >>> 3));
	
endmodule
	
module part2_testbench();
 logic signed [23:0]rd_left, rd_right;
 logic clk, reset, write_ready, read_ready;
 logic signed [23:0]nrd_left, nrd_right;

 part2 dut (.*);
 
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
		@(posedge clk);
		@(posedge clk);
		$stop;
	end
endmodule 