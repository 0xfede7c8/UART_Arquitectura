`timescale 1ns / 1ps

/*Modulo que hace de interprete e interface entre una uart y una alu para recibir
datos desde la pc y volver a enviar el resultado.*/




module Interface(input clk, input reset, wire [7:0] d_in, wire rx_done, wire tx_done , wire [7:0] d_in_alu,
					  output reg [7:0] d_out, output reg tx_start, output reg [7:0] A, output reg [7:0] B, output reg [7:0] opcode );

	//Registro operandos (A y B) y el codigo de operacion
	//Son entradas de la ALU
	
		reg [3:0] state;
		reg [3:0] next_state;
		reg [7:0] ASCII; //entrada del conversor
		wire [7:0] operacion;
		
	initial 
		begin
		A = 0; 		
		B = 0;
		opcode = 0;
		tx_start = 0;
		
		state = 0;
		next_state = 0;
		end

	/*Instancio el conversor
	  El registro de salida opcode tambien es la salida del conversor entonces lo que ponga
	  en el registro ASCII ya estara en la salida co0nvertido*/	
	  
	Conv_ASCII_Opcode conversor ( ASCII, operacion );
	

	//Un reset sincronizado con el clock y el cambio de estado
	always@(posedge clk)
			if (reset) state = 0;
			else state = next_state;
		

	//Logica del siguiente estado
	always@(posedge rx_done)
		begin
			case(state)
				0:
					next_state = 1;
				1:	
					next_state = 2;
				2:
					next_state = 3;
					
				default: //estado invalido
					next_state = 0;
			endcase
		end
		
	always@(state)
		begin
			case(state)
				0:;// idle
				1:
					A = d_in;
				2:
				begin
				//no puedo asignar ambos valores a la ves primero pasandolo por un combinacional ya que son operaciones paralelas
				//entonces a opcode se le asignaria el valor anterior de operacion que es 0
					ASCII = d_in;
					#1;		
					opcode = operacion;
				end
				3: begin
					B = d_in;
					#1;
					d_out = d_in_alu;
					if(tx_done) //tx done tiene que estar para transmitir
						begin
							tx_start = 1; //mando un pulso a la uart para que arranque a transmitir
							#1;
							tx_start = 0;
							next_state = 0;
						end
					else next_state = 3;
					end
				default:; // estado invalido
			endcase
		end

endmodule
