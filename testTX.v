`timescale 1ns / 1ps

module testTX;

	// Inputs
	reg clk;
	wire baud_rate;
	reg [7:0] d_in;
	reg tx_start;

	// Outputs
	wire tx;
	wire tx_done;

	reg [7:0] dato  = 'b10011001;
	reg [7:0] dato2  = 'b11011010;

	// Instantiate the Unit Under Test (UUT)
	
	BaudRateGenerator baud (
		.clk(clk), 
		.out(baud_rate)
	);
	
	TX uut (
		.clk(clk), 
		.baud_rate(baud_rate), 
		.d_in(d_in), 
		.tx_start(tx_start), 
		.tx(tx), 
		.tx_done(tx_done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		d_in = 0;
		tx_start = 0;

		// Wait 100 ns for global reset to finish
		#100;
		d_in = dato;
		tx_start = 1;        
		// Add stimulus here

	end
	
	always@(tx_done)
	begin
		if(tx_done == 1) tx_start = 0;
	end
	always
	begin
		#1; clk = 1;
		#1; clk = 0;
	end
      
endmodule

