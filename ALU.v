`timescale 1ns / 1ps

module ALU 
	#(parameter bus=8)
	(input signed [bus-1:0]A, input signed [bus-1:0]B,input [5:0]Opcode,
	output reg[bus-1:0]Out);
	always@(*)
	begin
		case (Opcode)
			'b100000: Out=A+B; //ADD
			'b100010: Out=A-B; //SUB
			'b100100: Out=A&B; //AND
			'b100101: Out=A|B; //OR
			'b100110: Out=A^B; //XOR
			'b100111: Out=~(A|B); //NOR
			'b000011: Out=A>>>B; //SRA
			'b000010: Out=A>>B; //SRL
			default: Out= 0;
		endcase
	end

endmodule
