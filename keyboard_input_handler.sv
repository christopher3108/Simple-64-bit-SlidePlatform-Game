module keyboard_input_handler(reset, clk, makeBreak, scanCode, outCode, pressed);
	input logic reset, makeBreak, clk;
	input logic [7:0] scanCode, outCode;
	
	output logic pressed;
	
	enum{unpressed, isPressed} ps, ns;
	
	always_comb begin
		case(ps)
			unpressed: if(makeBreak && (outCode == scanCode)) ns = isPressed;
						  else ns = unpressed;
						  
			isPressed: if(!makeBreak && (outCode == scanCode)) ns = unpressed;
			           else ns = isPressed;  
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= unpressed;
		else 
			ps <= ns;
	end
	
	assign pressed = (ps == isPressed);
	
endmodule 

module keyboard_input_handler_test();
	logic reset, makeBreak, clk, pressed;
	logic [7:0] scanCode, outCode;
	
	keyboard_input_handler k1(.*);
	
	parameter T = 100;
	initial begin
		clk <= 0;
		forever #(T/2) clk <= ~clk;
	end  // clock initial
	
	initial begin 
		reset <= 1; makeBreak <= 0; scanCode <= 8'b00000001; outCode <= 8'b00000000; @(posedge clk);
		reset <= 0; makeBreak <= 1; outCode <= 8'b00000001;                          @(posedge clk);
																											  @(posedge clk);
																											  @(posedge clk);
																											  @(posedge clk);
	                               outCode <= 8'b00000000;                          @(posedge clk);
																											  @(posedge clk);
						makeBreak <= 0; outCode <= 8'b0000000;                           @(posedge clk);
																										     @(posedge clk);
                                        														  @(posedge clk);
		$stop;
	end

endmodule