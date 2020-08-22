module platform_memory(clk, reset, create_platform, advance, location, camera_pos, platform_buffer);
	
	input logic clk, reset, create_platform, advance;
	input logic [8:0] location;
	input logic [9:0] camera_pos;
	output logic platform_buffer[0:479][0:639];
	
	logic [9:0] curr_camera;
	
	always_ff @(posedge clk) begin
		if(reset) begin
			for(int i = 60; i < 161; i++) begin
				platform_buffer[150][i] = 1'b1;
			end
			
			for(int i = 200; i < 301; i++) begin
				platform_buffer[300][i] = 1'b1;
			end
			
			curr_camera <= 10'd320;
		end
		
//		else if(camera_pos > curr_camera) begin
//			curr_camera <= camera_pos;
//			
//			for(int i = 0; i < 480; i++) begin
//				for(int j = 0; j < 640; j++) begin
//					if(j == 10'd639) platform_buffer[i][j] <= 0;
//					else platform_buffer[i][j] <= platform_buffer[i][j+1];
//				end
//			end
//		end
	end
	
endmodule
