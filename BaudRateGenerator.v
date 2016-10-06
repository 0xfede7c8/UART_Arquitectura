`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:44 10/06/2016 
// Design Name: 
// Module Name:    BaudRateGenerator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BaudRateGenerator(input clk, output reg out);

	integer cuenta = 0;
	always@(posedge clk)
	begin
		out=0;
		cuenta = cuenta + 1;
		if(cuenta == 163)
		begin
			out = 1;
			cuenta = 0;
		end
	end

endmodule
