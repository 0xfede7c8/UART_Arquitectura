`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:31:47 10/30/2016
// Design Name:   Main
// Module Name:   /home/fede/DatosWindows/Facultad/Arquitectura de Computadoras/WorkspaceXilinxIse/UART/UART_Arquitectura/testMain.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMain;

	// Inputs
	reg rx;
	reg clk;
	reg reset;
	reg baud_rate;

	// Outputs
	wire tx;

	// Instantiate the Unit Under Test (UUT)
	Main uut (
		.rx(rx), 
		.clk(clk), 
		.reset(reset), 
		.tx(tx)
	);
	
	BaudRateGenerator baud (
		.clk(clk), 
		.out(baud_rate)
	);

	initial begin
		// Initialize Inputs
		rx = 0;
		clk = 0;
		reset = 0;

		#100; 

	end
	
	always@(posedge baud_rate)
	begin
		count = count + 1;
	end
	
	always@(posedge baud_rate)
	begin
		if(count == 16)
		begin
			if(bit_count == 0)
			begin
				rx = 0;
				bit_count = bit_count + 1;
			end
			else
			begin
				if(bit_count < 9)
				begin
					rx = dato[7];
					dato = dato << 1;
				end
				if(bit_count == 9) rx = 1; //stop bit
				if(bit_count == 11) rx = 0; //start bit
				if(bit_count > 11 && bit_count < 20)
				begin
					rx = dato2[7];
					dato2 = dato2 << 1;
				end
				if(bit_count == 21) rx = 1; //stop bit
				bit_count = bit_count+1;
			end
			count = 0;
		end
	end

	
	always
	begin
		#1; clk = 1;
		#1; clk = 0;
	end
      
endmodule

