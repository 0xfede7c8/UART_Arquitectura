`timescale 1ns / 1ps

/*Modulo que hace de interprete e interface entre una uart y una alu para recibir
datos desde la pc y volver a enviar el resultado.*/

module Interface
 #(parameter stateA = 'b000000000001,
	parameter stateB = 'b000000000010,
	parameter stateC = 'b000000000100,
	parameter stateD = 'b000000001000,
	parameter stateE = 'b000000010000,
	parameter stateF = 'b000000100000,
	parameter stateG = 'b000001000000,
	parameter stateH = 'b000010000000,
	parameter stateI = 'b000100000000,
	parameter stateJ = 'b001000000000,
	parameter stateK = 'b010000000000,
	parameter stateL = 'b010000000000)
  (input clk,
	input reset,
	input [7:0] d_in, //data que viene del RX
	input rx_done, //rx_done que viene del RX
	input tx_done, //tx_done que viene del TX
	input [31:0] d_out_ALU, //dato resultado que sale de la ALU
	
	output reg [7:0] d_out, //d_out que va al TX
	output reg tx_start, //tx_start que va al TX
	output reg [31:0] A, //A de la ALU
	output reg [31:0] B, //B de la ALU
	output reg [5:0] opcode); // opcode de la ALU

	reg [11:0] state = stateA;
	reg [11:0] next_state = stateA;
	reg [7:0] d_in_ASCII; //dato que va de entrada al conversor ASCII
	wire [7:0] d_out_ASCII; //dato que sale del conversor ASCII
	//reg [31:0] d_in_conversor, //dato que va al conversor (FIFO)
	wire [31:0] d_out_concatenador; //dato que sale del conversor (FIFO)
	reg num_ready; //num_ready para el conversor (FIFO)
	reg fin; //fin para el conversor (FIFO)
	wire concatenador_done;
	
	reg A_end;
	reg B_end;
	reg A_ready;
	reg B_ready;
	
	reg rx_done_state = 0;
	reg rx_done_signal = 0;
	
	Conv_ASCII_Opcode conversor ( .ASCII(d_in_ASCII), .opcode(d_out_ASCII));
	//CONVERSOFIFO BLABLAB (d_out_ASCII, d_out_conversor, num_ready, fin);
	ConcatenadorNumeros concatenador(.clk(clk),.reset(reset),.dato(d_out_ASCII),
												.num_ready(num_ready),.fin(fin),.resultado(d_out_concatenador),
												.done(concatenador_done));

	//Un reset sincronizado con el clock y el cambio de estado
	always@(posedge clk or negedge reset)
	begin
		if (reset == 0) state = stateA;
		else state = next_state;
	end
	
	always@(posedge clk)
	begin
		if(rx_done_state == 0)
		begin
			if(rx_done == 1)
			begin
				rx_done_signal = 1;
				rx_done_state = 1;
			end
		end
		else
		begin
			rx_done_signal = 0;
			if(rx_done == 0) rx_done_state = 0;
		end
	end
	
	always@(posedge clk)
	begin
		case(state)
			//espera en el estado A por el rx_done, y cuando llega pasa al estado B
			stateA:
			begin
				if(rx_done_signal == 1) next_state = stateB;
				else next_state = stateA;
			end
			//en el estado B se verifica si dato ingresado es el delimitador
			stateB:
				next_state = stateC;
			//A_end indica que llego el delimitador, entonces pasa al estado D
			// si no llega el delimitador, toma un dato, lo envia al conversor y vuelve 
			//al estado A
			stateC:
			begin
				if(A_end == 1) next_state = stateD;
				else next_state = stateA;
			end
			//en el estado D se envia la señal al conversor de que termino de llegar
			// el dato A,se toma la salida del conversor, y se pasa al siguiente estado
			stateD:
			begin
				if(A_ready)	next_state = stateE;
				else next_state = stateD;
			end
			//el estado E espera por el rx_done del opcode
			stateE:
			begin
				if(rx_done_signal == 1) next_state = stateF;
				else next_state = stateE;
			end
			//en el estado F se ingresa el dato del opcode al conversor ascii
			//y se continua hacia el siguiente estado
			stateF:
			begin
				next_state = stateG;
			end
			//en el estado G se toma el resultado de la conversion ASCII y se lo guarda en
			//opcode
			stateG:
			begin
				next_state = stateH;
			end
			//en el estado H se espera por el rx_done que corresponde a los bytes del dato B
			//y se pasa hacia el siguiente estado cada vez que llega
			stateH:
			begin
				if(rx_done_signal == 1) next_state = stateI;
				else next_state = stateH;
			end
			//en el estado I se verifica si dato ingresado es el delimitador
			stateI:
				next_state = stateJ;
			stateJ:
			begin
				if(B_end == 1) next_state = stateK;
				else next_state = stateH;
			end
			stateK:
			begin
				if(B_ready) next_state = stateL;
				else next_state = stateK;
			end
			stateL:
			begin
				next_state = stateA;
			end
		endcase
			
	end
	
	always@(posedge clk)
	begin
		case(state)
			stateA:
			begin
				A_end = 0;
				num_ready = 0;
				fin = 0;
				tx_start = 0;
				A_ready = 0;
			end
			stateB:
				if(d_in == 'b00100000) A_end = 1;
				else
				begin
					A_end = 0;
					d_in_ASCII = d_in;
				end
			stateC:
			begin
				if(A_end == 0)
				begin
					num_ready = 1;
				end
				else fin = 1;
			end
			stateD:
			begin
				if(concatenador_done)
				begin
					A = d_out_concatenador;
					A_ready = 1;
					fin = 0;
				end
				num_ready = 0;
			end
			stateE:; //idle
			stateF:
			begin
				d_in_ASCII = d_in;
			end
			stateG:
			begin
				opcode = d_out_ASCII[5:0];
			end
			stateH:
			begin
				B_end = 0;
				num_ready = 0;
				fin = 0;
				B_ready = 0;
			end
			stateI:
			begin
				if(d_in == 'b00100000) B_end = 1;
				else
				begin
					B_end = 0;
					d_in_ASCII = d_in;
				end
			end
			stateJ:
			begin
				if(B_end == 0)
				begin
					num_ready = 1;
				end
				else fin = 1;
			end
			
			stateK:
			begin
				if(concatenador_done)
				begin
					B = d_out_concatenador;
					B_ready = 1;
					fin = 0;
				end
				num_ready = 0;
			end
			stateL:
			begin
				//aca hay que hacer la conversion al revez del dato de la ALU
				//por ahora envio el resultado al d_out 
				d_out = d_out_ALU;
				tx_start = 1;
			end
		endcase
	end
endmodule
