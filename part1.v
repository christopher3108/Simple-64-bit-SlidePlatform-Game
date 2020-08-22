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
 
module part1 (
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

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [9:0] SW;
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	wire read_ready, write_ready;
	reg read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] nreaddata_left, nreaddata_right, nreaddata_left2, nreaddata_right2, nreaddata_left3, nreaddata_right3;
	wire [23:0] writedata_left, writedata_right;
	wire Q;
	wire [23:0] read_r_noise, read_l_noise;
	wire reset = ~KEY[0];
	
	assign read_r_noise = readdata_right + Q;
	assign read_l_noise = readdata_left + Q;
	
	/* Your code goes here */
	
//	assign writedata_left = SW[9] ? nreaddata_left : read_l_noise;	//Your code goes here
//	assign writedata_right = SW[9] ? nreaddata_right : read_r_noise;	//Your code goes here
	
//	assign writedata_left = SW[9] ? nreaddata_left2 : nreaddata_left;
//	assign writedata_right = SW[9] ? nreaddata_right2 : nreaddata_right;	//Your code goes here

//	assign writedata_left = SW[9] ? nreaddata_left2 : nreaddata_left3;	//Your code goes here
//	assign writedata_right = SW[9] ? nreaddata_right2 : nreaddata_right3;	//Your code goes here
	
	assign writedata_left = SW[9] ? 24'd0 : nreaddata_left2;	//Your code goes here
	assign writedata_right = SW[9] ? 24'd0 : nreaddata_right2;	//Your code goes here
	
	always@(posedge CLOCK_50) begin
		read <= read_ready & write_ready;		//Your code goes here 
		write <= write_ready & read_ready;		//Your code goes here 
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
	
	noise_generator n1(.clk(CLOCK_50), .enable(SW[7]), .Q(Q));
	part2 filter(.read_ready(read_ready), .write_ready(write_ready), .rd_left(read_l_noise), .rd_right(read_r_noise), .clk(CLOCK_50), .reset(reset), .nrd_left(nreaddata_left), .nrd_right(nreaddata_right));
	part3 filter2(.read_ready(read_ready), .write_ready(write_ready), .rd_left(read_l_noise), .rd_right(read_r_noise), .clk(CLOCK_50), .reset(reset), .nrd_left(nreaddata_left2), .nrd_right(nreaddata_right2));
	part3 #(24, 128, 7)filter3(.read_ready(read_ready), .write_ready(write_ready), .rd_left(read_l_noise), .rd_right(read_r_noise), .clk(CLOCK_50), .reset(reset), .nrd_left(nreaddata_left3), .nrd_right(nreaddata_right3));
endmodule

//module part1_testbench();
//	wire CLOCK_50, CLOCK2_50;
//	wire [0:0] KEY;
//	wire [9:0] SW;
//	wire FPGA_I2C_SCLK;
//	wire FPGA_I2C_SDAT;
//	wire AUD_XCK;
//	wire AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
//	wire AUD_ADCDAT;
//	wire AUD_DACDAT;
//	
//	parama
//	
//endmodule