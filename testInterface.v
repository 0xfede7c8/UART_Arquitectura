`timescale 1ns / 1ps


module testInterface;

	// Inputs
	reg clk;
	reg reset = 0;
	reg [7:0] d_in;
	reg rx_done;
	reg tx_done;
	reg [31:0] d_out_ALU;

	// Outputs
	wire [7:0] d_out;
	wire tx_start;
	wire [31:0] A;
	wire [31:0] B;
	wire [5:0] opcode;

	// Instantiate the Unit Under Test (UUT)
	Interface uut (
		.clk(clk), 
		.reset(reset), 
		.d_in(d_in), 
		.rx_done(rx_done), 
		.tx_done(tx_done), 
		.d_out_ALU(d_out_ALU), 
		.d_out(d_out), 
		.tx_start(tx_start), 
		.A(A), 
		.B(B), 
		.opcode(opcode)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		d_in = 0;
		rx_done = 0;
		tx_done = 0;

		#1;
		reset = 0;
		#2;
		reset = 1;
		// Wait 100 ns for global reset to finish
		#20;
        
		// Add stimulus here
		//primer dato
		d_in = 5;
		rx_done = 1;
		#20;
		rx_done = 0;
		#20;
		//primer dato
		d_in = 4;
		rx_done = 1;
		#20;
		rx_done = 0;
		#20;
		//delimitador
		d_in = 32;
		rx_done = 1;
		#20;
		rx_done = 0;
		#20;
		//opcode
		d_in = 43;
		rx_done = 1;
		#20;
		rx_done = 0;
		#20;
		//segundo dato
		d_in = 7;
		rx_done = 1;
		#20;
		rx_done = 0;
		#20;
		//delimitador
		d_in = 32;
		rx_done = 1;
		#20;
		rx_done = 0;

	end
	
	always
	begin
		#1; clk = 1;
		#1; clk = 0;
	end
      
endmodule

