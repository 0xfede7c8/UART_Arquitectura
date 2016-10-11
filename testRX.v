`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:27:40 10/06/2016
// Design Name:   RX
// Module Name:   /home/juanso/dev/xilinx/UART_Arquitectura/testRX.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RX
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testRX;

	// Inputs
	reg clk;
	wire baud_rate;
	reg rx;
	// Outputs
	wire [7:0] d_out;
	wire rx_done;
	
	reg [7:0] dato  = 'b10011001;
	reg [7:0] dato2 = 'b01100110;
	integer count = 0;
	integer bit_count = 0;
	
	BaudRateGenerator baud (
		.clk(clk), 
		.out(baud_rate)
	);
	// Instantiate the Unit Under Test (UUT)
	RX uut (
		.clk(clk), 
		.baud_rate(baud_rate), 
		.rx(rx), 
		.d_out(d_out), 
		.rx_done(rx_done)
	);
	

	initial begin
		// Initialize Inputs
		clk = 0;
		rx = 1;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here

	end
	
	always
	begin
		#1; clk = 1;
		#1; clk = 0;
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
      
endmodule

