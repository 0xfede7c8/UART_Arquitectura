`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:55:22 10/06/2016
// Design Name:   BaudRateGenerator
// Module Name:   /home/juanso/dev/xilinx/UART_Arquitectura/testBaudRate.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BaudRateGenerator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testBaudRate;

	// Inputs
	reg clk;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	BaudRateGenerator uut (
		.clk(clk), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always
	begin
		#100; clk = 0;
		#100; clk = 1;
	end
endmodule

