`timescale 1ns / 1ps

module SeparadorNumeros
 #(parameter stateA = 'b0001, //idle
	parameter stateB = 'b0010, //convert
	parameter stateC = 'b0100	//send
	)
	
	(input [31:0] alu_in,
    input start_conversion,
    input tx_done,
	 input clk,
    output reg [7:0] value_to_send = 0,
	 output reg tx_start = 0
    );
	 
	reg [3:0] diez;
	reg [3:0] nueve;
	reg [3:0] ocho;
	reg [3:0] siete;
	reg [3:0] seis;
	reg [3:0] cinco;
	reg [3:0] cuatro;
	reg [3:0] tres;
	reg [3:0] dos;
	reg [3:0] uno;
	
	reg done_convert = 0;
	reg done_send = 0;
	
	reg [3:0] state = stateA;
	reg [3:0] next_state = stateA;
	
	integer enviando_valor = 10;
	
	always@(posedge clk)
	begin
		state = next_state;
	end
	
	always@(posedge clk)
	begin
		case(state)
			stateA:
			begin
				if(!start_conversion) next_state = stateA;
				else next_state = stateB;
			end
			stateB:
			begin
				if(!done_convert) next_state = stateB;
				else next_state = stateC;
			end
			stateC:
			begin
				if(!done_send)next_state = stateC;
				else next_state = stateA;
			end
		endcase
	end

	integer i;
	integer retardo = 0;
	
	always@(posedge clk)
	begin
	
		if(state == stateA)
		begin
			done_send = 0;
			done_convert = 0;
			tx_start = 0;
			enviando_valor = 10;
		end
	
		if(state == stateB)
		begin
			diez = 4'd0;
			nueve = 4'd0;
			ocho = 4'd0;
			siete = 4'd0;
			seis = 4'd0;
			cinco = 4'd0;
			cuatro = 4'd0;
			tres = 4'd0;
			dos = 4'd0;
			uno = 4'd0;
			
			for(i=31;i>=0; i=i-1)
			begin
				if(diez >= 5)
					diez = diez + 3;
				if(nueve >= 5)
					nueve = nueve + 3;
				if(ocho >= 5)
					ocho = ocho + 3;
				if(siete >= 5)
					siete = siete + 3;
				if(seis >= 5)
					seis = seis + 3;
				if(cinco >= 5)
					cinco = cinco + 3;
				if(cuatro >= 5)
					cuatro = cuatro + 3;
				if(tres >= 5)
					tres = tres + 3;
				if(dos >= 5)
					dos = dos + 3;
				if(uno >= 5)
					uno = uno + 3;
				
				diez = diez << 1;
				diez[0] = nueve[3];
				
				nueve = nueve << 1;
				nueve[0] = ocho[3];
				
				ocho = ocho << 1;
				ocho[0] = siete[3];
				
				siete = siete << 1;
				siete[0] = seis[3];
				
				seis = seis << 1;
				seis[0] = cinco[3];
				
				cinco = cinco << 1;
				cinco[0] = cuatro[3];
				
				cuatro = cuatro << 1;
				cuatro[0] = tres[3];
				
				tres = tres << 1;
				tres[0] = dos[3];
				
				dos = dos << 1;
				dos[0] = uno[3];
				
				uno = uno << 1;
				uno[0] = alu_in[i];	
			end
			done_convert = 1;
		end
		
		if(state == stateC)
		begin
			if(tx_done)
			begin
				case(enviando_valor)
					10:
					begin
						if(retardo == 0)
						begin
							value_to_send <= diez + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo - 1;
					end
					9:					
					begin
						if(retardo == 0)
						begin
							value_to_send <= nueve + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					8:
					begin
						if(retardo == 0)
						begin
							value_to_send <= ocho + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					7:
					begin
						if(retardo == 0)
						begin
							value_to_send <= siete + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					6:
					begin
						if(retardo == 0)
						begin
							value_to_send <= seis + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					5:
					begin
						if(retardo == 0)
						begin
							value_to_send <= cinco + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					4:
					begin
						if(retardo == 0)
						begin
							value_to_send <= cuatro + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					3:
					begin
						if(retardo == 0)
						begin
							value_to_send <= tres + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					2:
					begin
						if(retardo == 0)
						begin
							value_to_send <= dos + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					1:
					begin
						if(retardo == 0)
						begin
							value_to_send <= uno + 48;
							tx_start = 1;
							enviando_valor = enviando_valor - 1;
							retardo = 4;
						end
						else retardo = retardo -1;
					end
					default:
					begin
						tx_start = 0;
						enviando_valor = 10;
						done_send = 1;
					end
				endcase
			end
			else tx_start = 0;
		end
	end


endmodule
