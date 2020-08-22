module DFF2( clk, reset, D, Q);
	output logic Q;
	input logic clk, reset, D;

	parameter NumOfDff = 4;
	logic [ NumOfDff - 1 : 0 ] q;

	always_ff @( posedge clk ) begin
		if ( reset == 1'b1 ) begin
			q <= '0;
		end else begin
			q <= { q[ NumOfDff - 2 : 0], D };
		end
	end

	assign Q = q[ NumOfDff - 1 ];

endmodule 

module DFF2_testbench();   
	logic  clk, reset;
	logic  key;
	logic  out;     

	DFF2 dut ( .clk, .reset, .D( key ), .Q( out ) );      

	// Set up the clock.   
	parameter CLOCK_PERIOD = 100;   
	initial begin    
		clk <= 0;    
		forever #( CLOCK_PERIOD / 2 ) clk <= ~clk;   
	end      

	// Set up the inputs to the design.  Each line is a clock cycle.   
	initial begin                        
									 @( posedge clk );    
		reset <= 1;           @( posedge clk );    
		reset <= 0; key <= 0; @( posedge clk );                        
									 @( posedge clk );                        
									 @( posedge clk );                        
									 @( posedge clk );                
						key <= 1; @( posedge clk );                
						key <= 0; @( posedge clk );                
						key <= 1; @( posedge clk );                        
									 @( posedge clk );                        
									 @( posedge clk );                        
									 @( posedge clk );               
						key <= 0; @( posedge clk );                        
									 @( posedge clk ); 
									 @( posedge clk ); 
									 @( posedge clk ); 							  
		$stop; // End the simulation.   
	end  
endmodule 