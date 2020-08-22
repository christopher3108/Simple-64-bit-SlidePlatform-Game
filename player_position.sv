 module player_position(clk, reset, jump, left_press, right_press, gravity_on, x, y);
	input logic clk, reset, jump, left_press, right_press, gravity_on;
	output logic [9:0] x;
	output logic [8:0] y;
	
	//managing player position
	always_ff @(posedge clk) begin
		if(reset) 
			begin
				x <= 10'd100; 
				y <= 9'd100;
			end
		else if(left_press && x-3'b100 != 10'b1)
			x <= x - 1'b1;
		else if(right_press && x != 10'd320)
			x <= x + 1'b1;
      
		if(jump)
			y <= y - 3'b010;
		else if(gravity_on)
		   y <= y + 3'b001;
	end
endmodule