module jump_handler(clk, reset, press, on_platform, jump);
	input logic clk, reset, press, on_platform;
	output logic jump;
	
	logic [5:0] time_held;
	
	enum{unpressed, hold, waiting} ps, ns;
	
	always_comb begin
		case(ps) 
			unpressed: if(press && on_platform) ns = hold;
						  else ns = unpressed;
			hold: if(!press) ns = unpressed;
			      else if(time_held == 6'd25) ns = waiting;
					else ns = hold;
			waiting: if(!press) ns = unpressed;
			         else ns = waiting;
		
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= unpressed;
			time_held <= 0;
		end
		else
			begin
				if(ps == hold) time_held <= time_held + 1'b1;
				else time_held <= 0;
				
				ps <= ns;
			end
	end
	
	assign jump = (ps == hold);

endmodule