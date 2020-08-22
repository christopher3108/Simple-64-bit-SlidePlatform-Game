module square_wave_generator (clk, reset, enable, Q);

	input  logic clk, reset, enable;
	output logic signed [23:0] Q;

	logic [20:0] counter, temp, ntemp;
	logic signed [23:0] sq_wave_reg;
	
	// Amplitude of the square wave
	assign sq_wave_reg = 24'd200000;

	always_ff @(posedge clk) begin
	// if enable signal is low then reset counter back to zero,
	// else if enable signal is high then increment counter by 1
		if(reset) begin
			counter <= 0;
			temp <= 0;
		end else if(enable) begin
			counter <= counter + 1'b1;
			temp <= ntemp;
		end
	end //always_ff
	
	//generate Q that will be written to the right and left write data (this is the wave generated) 
	always_comb begin
		if(counter % 20'd227273 == 0) 
			ntemp = temp + 20'd227273;
		else
			ntemp = temp;
	end //always_comb
	
	// Period = 454546
	always_comb begin
		if(temp / 20'd227273 % 20'd2 == 0)
			Q = sq_wave_reg; //generate a positive amplitude every even cycle of 50MHz clock
		else
			Q = ~sq_wave_reg; //generate a negative ampliude every odd cycle of 50MHz clock
	end //always_comb
	
endmodule //square_wave_generator

module square_wave_generator_testbench();
	logic clk, reset, enable;
	logic signed [23:0] Q;
	
	square_wave_generator dut(.*);
	
	parameter CLOCK_PERIOD=100; 
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	initial begin
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; enable <= 1'b1; @(posedge clk);
		for (int i = 0; i < 1000000; i++) begin
			@(posedge clk);
		end
		enable <= 1'b0; @(posedge clk);
		$stop;
	end
endmodule
