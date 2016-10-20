`timescale 1ns / 1ps


module ConcatenadorNumeros 	
	#( parameter stateA = 'b00001,
		parameter stateB = 'b00010,
		parameter stateC = 'b00100,
		parameter stateD = 'b01000,
		parameter stateE = 'b10000)
		
		(input clk, input reset, input [7:0] dato, input num_ready, input fin,
		output integer resultado)
    );

	integer state = stateA;
	integer next_state = stateB;
	
	always@(posedge clk)
		begin
			if (reset) state = stateA;
			else state = next_state;
		end
		
	always@(num_ready)
		
		
	
			
	
	



endmodule
