`timescale 1ns / 1ps
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
