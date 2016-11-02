`timescale 1ns / 1ps
/*Convierte de un simbolo ascii a un opcode de la alu.

Diccionario de valores:
	(43) + 		 ---> 8'b00100000
	(45) - 		 ---> 8'b00100010
	(65) A (AND) ---> 8'b00100100
	(79) O (OR)  ---> 8'b00100101
	(88) X (XOR) ---> 8'b00100110
	(78) N (NOR) ---> 8'b00100111
	(62) > (SRA) ---> 8'b00000011
	(47) / (SRL) ---> 8'b00000010
	
	Son mayusculas
	*/
	
module Conv_ASCII_Opcode( input wire [7:0] ASCII, output reg [7:0]opcode);
	
	always@*
	begin
		case(ASCII)
			43:  opcode = 8'b00100000;
			45:  opcode = 8'b00100010;
			65:  opcode = 8'b00100100;
			79:  opcode = 8'b00100101;
			88:  opcode = 8'b00100110;
			78:  opcode = 8'b00100111;
			62:  opcode = 8'b00000011;
			47:  opcode = 8'b00000010;
			default:
			begin
				if((ASCII<=57)&&(ASCII>=48)) opcode = ASCII-48;
				else opcode = -1;
			end
		endcase
	end
endmodule
