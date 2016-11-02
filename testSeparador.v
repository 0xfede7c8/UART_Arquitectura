`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:26:30 10/31/2016
// Design Name:   SeparadorNumeros
// Module Name:   /home/fede/DatosWindows/Facultad/Arquitectura de Computadoras/WorkspaceXilinxIse/UART/UART_Arquitectura/testSeparador.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SeparadorNumeros
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testSeparador;

	// Inputs
	reg [31:0] alu_in;
	reg start_conversion;
	reg tx_done;
	reg clk;

	// Outputs
	wire [7:0] value_to_send;
	wire tx_start;

	// Instantiate the Unit Under Test (UUT)
	SeparadorNumeros uut (
		.alu_in(alu_in), 
		.start_conversion(start_conversion), 
		.tx_done(tx_done), 
		.clk(clk),
		.value_to_send(value_to_send), 
		.tx_start(tx_start)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		alu_in = 0;
		start_conversion = 0;
		tx_done = 1;
		
		alu_in = 1234567898;
		#4;
		start_conversion = 1;
		#4;
		start_conversion = 0;
		#400;
		
		
		alu_in = 43;
		#4;
		start_conversion = 1;
		#4;
		start_conversion = 0;

	end
	
	always@(posedge clk)
	begin
	if(tx_start)
	begin	
		tx_done = 0;
		#30;
		tx_done = 1;
	end
	end

always
	begin
		#1; clk = 1;
		#1; clk = 0;
	end
      
	
      
endmodule

