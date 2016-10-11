`timescale 1ns / 1ps

/*Modulo que hace de interprete e interface entre una uart y una alu para recibir
datos desde la pc y volver a enviar el resultado.*/




module Interface(input clk, wire [0:7] d_in, wire rx_done, wire tx_done,
					  output reg [0:7] d_out, output reg tx_start   );

	//Registro operandos (A y B) y el codigo de operacion
	reg [7:0] A = 0; 
	reg [7:0] B = 0;
	reg [7:0] Operacion = 0;
	
	//Estado del interprete
	reg [3:0] state = 0;

	always@(posedge rx_done)
		begin
			case(state)
				0: 
					A = d_in;
					state = state +1;
				1:
					Operacion = d_in;
					state = state +1;
				2:
					B = d_in;
					state = state + 1;
				default: //estado invalido
		end
		
	always@(posedge clk)
		begin
		if(state == 3)
			begin
			
			
			
			end
	
	
	
		end
	


endmodule
