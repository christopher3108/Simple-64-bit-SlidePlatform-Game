module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, CLOCK2_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS,
					 PS2_DAT, PS2_CLK, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	
	//FPGA
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	//VGA
	input PS2_CLK, PS2_DAT;
	input CLOCK_50, CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	//Audio
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	assign reset = SW[9];
	
	
	//switch between CLOCK_50 and divided clock for simulation purpose.
	logic clock;
	assign clock = clk[18];
	
	logic [31:0] clk;
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));
	
	//jumping is assigned to KEY[0];
	logic jump, jump_press;
	assign jump_press = ~KEY[0]; 
	
	//instantiate audio driver
	audio_top_level audio(CLOCK_50, 
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
	AUD_DACDAT);
	
	//instaniate video driver
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
			 
	//logic for keyboard_press_driver instantiation
	logic valid, makeBreak;
	logic [7:0] outCode;
	
	//instantiate keyboard_press_driver
	keyboard_press_driver 
		k1(.CLOCK_50, .valid, .makeBreak, .outCode, 
		   .PS2_DAT, .PS2_CLK, .reset);
	
	//logic represeting inputs and scan codes of the left and right arrow keys on keyboard
	logic left_press, right_press;
	logic [7:0] left_scan, right_scan;
	
	//scan codes for left and right arrow keys
	assign left_scan = 8'h6B;
	assign right_scan = 8'h74;
	
	//FSM to manage key inputs. 
	keyboard_input_handler left1(.reset, .clk(CLOCK_50), .makeBreak(makeBreak), .scanCode(left_scan), .outCode, .pressed(left_press));
	keyboard_input_handler right1(.reset, .clk(CLOCK_50), .makeBreak(makeBreak), .scanCode(right_scan), .outCode, .pressed(right_press));
	
	assign LEDR[9] = left_press;
	assign LEDR[0] = right_press;
	
	
	logic [9:0] playerX, furthestX;
   logic [8:0]	playerY;
	
	logic platform_buffer[0:479][0:639];
	
	logic gravity_on;
	logic on_platform;
	
	assign on_platform = (platform_buffer[playerY+1'b1][playerX] == 1) | (platform_buffer[playerY+1'b1][playerX-3'b100] == 1);
	
	jump_handler j1(.clk(clock), .reset, .press(jump_press), .on_platform, .jump);
	
	
	//manage player position and avatar bounds
	player_position player(.clk(clock), .reset, .jump, .left_press, .right_press, .gravity_on, .x(playerX), .y(playerY));
	
	assign furthestX = (playerX > furthestX) ? playerX : furthestX;

	//manage pixels which pixels are part of platforms
	platform_memory platform(.clk(CLOCK_50), .reset, .create_platform(0), .advance(0), .location(0), .camera_pos(furthestX), .platform_buffer);
	
	always_comb begin
		if(on_platform)
			gravity_on <= 0;
		else
			gravity_on <= 1;
	end
	
	always_comb begin
		if(x <= playerX + 1'd1 && x == playerX - 3'd1 && x == playerX - 3'd3 && x == playerX - 3'd5 && y <= playerY && y >= playerY - 3'd2 || //set pixel colors for player 
				(x <= playerX && x <= playerX - 3'd6 && y <= playerY && y == playerY - 3'd3) || 
				(x <= playerX + 1'd1 && x <= playerX - 3'd5 && y <= playerY && y == playerY - 3'd4 && x != playerX - 3'd3) || 
				(x <= playerX + 1'd2 && x <= playerX - 3'd4 && y <= playerY && y == playerY - 3'd5)) 
			begin
				r = 8'd255;
				g = 8'd0;
				b = 8'd0;
			end
		
		else if(platform_buffer[y][x] == 1'b1) //set pixel colors for platforms
			begin
				r = 8'b0;
				b = 8'b0;
				g = 8'b0;
			end
		else //fill pixel colors for background
			begin
				r = 8'd150;
				g = 8'd150;
				b = 8'd150; 
			end
	end
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
endmodule

//Clock divider module
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...

module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks = 0;

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule 
