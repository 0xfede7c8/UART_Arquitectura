`timescale 1ns / 1ps


module testConcat;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] dato;
	reg num_ready;
	reg fin;

	// Outputs
	wire [31:0] resultado;

	// Instantiate the Unit Under Test (UUT)
	ConcatenadorNumeros uut (
		.clk(clk), 
		.reset(reset), 
		.dato(dato), 
		.num_ready(num_ready), 
		.fin(fin),
		.resultado(resultado)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		dato = 0;
		num_ready = 0;
		fin = 0;

		// Wait 100 ns for global reset to finish
		#50;
		reset = 1;
		#20;
		dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 8; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 1; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
		dato = 4; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 8; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 1; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
		dato = 4; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
		dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#40;
		fin = 1;
		#20;
		fin=0;
		
		
		
		#800;
		
		
		
							dato = 1; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 1; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 1; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
							dato = 7; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 7; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 5; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 3; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
							dato = 4; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 4; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#40;
		fin = 1;
		#20;
		fin=0;
		
		
		#800;
		
		
							dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 8; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 1; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
							dato = 4; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 8; 					//2
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 1; 					//3
		#20
		num_ready = 1;
		#20;
		num_ready = 0;		
		#20;
							dato = 4; 					//4
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#20;
							dato = 9; 					//1
		#20
		num_ready = 1;
		#20;
		num_ready = 0;
		#40;
		fin = 1;
		#20;
		fin=0;
		
		
	//	reset = 0;
		
        
		// Add stimulus here

	end
	
	
		always
	begin
		#10; clk = 1;
		#10; clk = 0;
	end
      
endmodule

