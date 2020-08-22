/* This module loads data into the TRDB LCM screen's control registers 
 * after system reset. 
 * 
 * Inputs:
 *   CLOCK_50 		- FPGA on board 50 MHz clock
 *   CLOCK2_50  	- FPGA on board 2nd 50 MHz clock
 *   KEY 			- FPGA on board pyhsical key switches
 *   FPGA_I2C_SCLK 	- FPGA I2C communication protocol clock
 *   FPGA_I2C_SDAT  - FPGA I2C communication protocol data
 *   AUD_XCK 		- Audio CODEC data
 *   AUD_DACLRCK 	- Audio CODEC data
 *   AUD_ADCLRCK 	- Audio CODEC data
 *   AUD_BCLK 		- Audio CODEC data
 *   AUD_ADCDAT 	- Audio CODEC data
 * 
 * Output:
 *   AUD_DACDAT 	- output Audio CODEC data
 */
 
module audio_top_level (
	CLOCK_50, 
	CLOCK2_50, 
	KEY, 
	SW,
	FPGA_I2C_SCLK, 
	FPGA_I2C_SDAT, 
	AUD_XCK, 
	AUD_DACLRCK, 
	AUD_ADCLRCK, 
	AUD_BCLK,
	AUD_ADCDAT,
	AUD_DACDAT
);

	input logic CLOCK_50, CLOCK2_50;
	input logic [1:0] KEY;
	input logic [9:0] SW;
	output logic FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	output logic AUD_XCK;
	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input logic AUD_ADCDAT;
	output logic AUD_DACDAT;
	
	logic read_ready, write_ready;
	logic read, write;
	logic [23:0] readdata_left, readdata_right;
	logic [23:0] nreaddata_left, nreaddata_right, nreaddata_left2, nreaddata_right2, nreaddata_left3, nreaddata_right3;
	logic [23:0] writedata_left, writedata_right;
	logic [23:0] sfx;
	logic [23:0] read_r_noise, read_l_noise;
	logic reset;
	
	assign reset = ~KEY[1];
	
	//outputting jump sound effect if switch 9 is off
	assign writedata_left = SW[9] ? 24'd0 : sfx;	
	assign writedata_right = SW[9] ? 24'd0 : sfx;	
	
	always_ff@(posedge CLOCK_50) begin
		read <= read_ready & write_ready;		
		write <= write_ready & read_ready;		
	end
	
	clock_generator my_clock_gen(
		CLOCK2_50,
		reset,
		AUD_XCK
	);

	audio_and_video_config cfg(
		CLOCK_50,
		reset,
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		CLOCK_50,
		reset,
		read,	
		write,
		writedata_left, 
		writedata_right,
		AUD_ADCDAT,
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
	
	square_wave_generator sound(.clk(CLOCK_50), .reset, .enable(~KEY[0]), .Q(sfx));
endmodule
