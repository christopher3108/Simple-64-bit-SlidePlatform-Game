/* Noise-generating circuit for use in Lab 5, in case you have a noise-cancelling microphone.
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   enable - driven high when the Audio CODEC module can both produce and accept a new sample
 *
 * Outputs:
 *   Q      - noise value (signed) to add to sound sample
 */
module noise_generator (clk, enable, Q);

	input  logic clk, enable;
	output logic [23:0] Q;

	logic [2:0] counter;
	
	// if enable signal is low then reset counter back to zero,
	// else if enable signal is high then increment counter by 1
	always_ff @(posedge clk) begin
		if(~enable)
			counter <= 0;
		else if (enable) begin
			counter <= counter + 1'b1;
		end
	end //always_ff
	
	//generate Q that will be added to the original sound (this is the noise generated) 
	assign Q = {{10{counter[2]}}, counter, 11'd0};
	
endmodule //noise_generator
