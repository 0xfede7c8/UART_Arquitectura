`timescale 1ns / 1ps

module testConversor;

	// Inputs
	reg [7:0] ASCII;

	// Outputs
	wire [7:0] opcode;

	// Instantiate the Unit Under Test (UUT)
	Conv_ASCII_Opcode uut (
		.ASCII(ASCII), 
		.opcode(opcode)
	);

	initial begin
		
		
		
		ASCII = 0;

			ASCII = 43;
			#100;			
			ASCII = 45; 
			#100;
			ASCII = 65;
			#100;			
			ASCII = 79;
			#100;			
			ASCII = 88;
			#100;			
			ASCII = 78;
			#100;
			ASCII = 62;
			#100;			
			ASCII = 47;
			#100;
        


	end
      
endmodule

