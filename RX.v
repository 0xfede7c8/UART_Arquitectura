`timescale 1ns / 1ps

module RX
	#( parameter stateA = 'b00001,
		parameter stateB = 'b00010,
		parameter stateC = 'b00100,
		parameter stateD = 'b01000,
		parameter stateE = 'b10000)
	(input clk,
	input baud_rate,
	input rx,
	output reg [7:0] d_out,
	output reg rx_done);
	
	integer state = stateA;
	integer next_state = stateA;
	
	reg tick_enable = 0;
	integer count = 0;
	reg rst_count = 1;
	integer bits_count = 0;
	
	always@(posedge clk)
	begin
		state = next_state;
	end
	
	always@(posedge clk)
	begin
		case(state)
			//el estado A espera por el bit de start
			stateA:
				if(rx == 1) next_state = stateA;
				else next_state = stateB;
			//una vez recibido el bit de start se pasa al estado B, donde se 
			//esperan 7 cuentas
			stateB:
				if(count == 7) next_state = stateC;
				else next_state = stateB;
			//cuando se cumplen las 7 cuentas se pasa al estado C, en donde
			//se resetea el counter y se pasa inmediatamente al proximo estado
			stateC:
				next_state = stateD;
			//en el estado B, se comienzan a recibir los datos
			//cuando se cumplen los 8 bits, se pasa al estado E
			stateD:
				if(bits_count == 8) next_state = stateE;
				else next_state = stateD;
			//en el estado E se espera por el bit de stop para volver al estado idle
			stateE:
				if(rx_done == 1) next_state = stateA;
				else next_state = stateE;
		endcase
	end
	
	always@(posedge clk)
	begin
		case(state)
			//en el estado A, se deshabilita el contador y rx_done se pone en 0
			stateA:
			begin
				rst_count = 1;
				tick_enable = 0;
				rx_done = 0;
			end
			//en el estado B se habilita el contador, y se esperan 7 cuentas para 
			//pasar al estado C
			stateB:
			begin
				tick_enable = 1;
			end
			//en el estado C se resetea el contador y se pasa inmediatamente
			//al estado D
			stateC:
			begin
				rst_count = 0;
			end
			//en el estado B, cada vez que la cuenta llega a 16, se toma un bit y se guarda en d_out
			//se incrementa la cuenta de bits leidos y se resetea el contador
			stateD:
			begin
				rst_count = 1;
				if(count == 16)
				begin
					d_out = d_out>>1;
					d_out[7] = rx;
					bits_count = bits_count + 1;
					rst_count = 0;
				end
			end
			stateE:
			begin
				if(count == 16 && rx == 1)
				begin
					rx_done = 1;
					bits_count = 0;
					rst_count = 0;
				end
			end
		endcase
	end
				
				
	//contador de ticks
	always@(posedge baud_rate or negedge rst_count)
	begin
		//reset cuenta
		if(rst_count == 0) count = 0;
		//contar si esta habilitado
		else
		begin
			if(tick_enable == 1) count = count+1;
		end
	end

endmodule
