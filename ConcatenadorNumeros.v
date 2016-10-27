`timescale 1ns / 1ps


module ConcatenadorNumeros 	
	#( parameter stateA = 5'b00001,	//cargando datos en fifo
		parameter stateB = 5'b00010,	//calculando datos
		parameter stateC = 5'b00100,	//devuelvo
		parameter stateD = 5'b01000,	
		parameter stateE = 5'b10000)	
		
		(input clk, input reset, input [7:0] dato, input num_ready, input fin,
		output integer resultado = 0, output reg done = 0
    );
	 
	wire [7:0] fifo_data_out;			//salida de la fifo
	wire [4:0] fifo_data_count;		//indica la cantidad de elementos dentro de la fifo
	wire fifo_empty;				//indica si esta vacio
	wire fifo_full;				//indica siesta lleno
	reg [7:0] fifo_data_in = 0;
	reg fifo_wr_en = 0;			//escribe en la fifo lo que este en fifo_data_in cuando viene el posedge
	reg fifo_rd_en = 0;			//saca por fifo_data_out lo que este en la fifo cuando viene el posedge
	reg fifo_n_reset = 1;  //reset de la fifo. En 1 es NO RESET
	 
	integer state = stateA;
	integer next_state = stateA;
	
	reg flag_fin_carga; 		//flag que indica cuando se terminaron de cargar datos
	
	reg flag_pulso_wr_enable = 0;	//flags para mandar pulsos
	reg flag_pulso_rd_enable = 0;
	reg flag_pulso_reset_fifo = 0;
	reg flag_pulso_done = 0;
	reg flag_procesando = 0; //si estoy haciendo la cuenta
	reg flag_dato_nuevo = 0; //flag para el estado B de ponderacion de numeros
	
	integer result_tmp = 0;
	
	 //https://eewiki.net/pages/viewpage.action?pageId=20939499
	 
		FIFO_v fifo (
			.data_out(fifo_data_out),
			.data_count(fifo_data_count),
			.empty(fifo_empty),
			.full(fifo_full),
			.almst_empty(),
			.almst_full(),
			.err(),
			.data_in(fifo_data_in),
			.wr_en(fifo_wr_en),
			.rd_en(fifo_rd_en),
			.n_reset(fifo_n_reset),
			.clk(clk)
		);
		
	/*RESET Y NEXT STATE*/
	always@(posedge clk)
		begin
			if (reset) 
				begin
					next_state <= stateA;
					flag_pulso_reset_fifo <= 1;
				end
			else state <= next_state;
		end
		
	/*CAMBIO DE ESTADOS*/
		
	always@(posedge clk or posedge fin)
		begin
			case(state)
				stateA: 
					begin
						if(fin) //si llego fin
							begin
								flag_procesando <= 1;		//cambio flag de procesamiento de datos
								next_state <= stateB;
							end
					end
				stateB: if(!flag_procesando) next_state <= stateC;
				stateC: next_state = stateD;
				stateD: next_state = stateA;
			endcase
		end
		
/*--------------------CARGA DE NUMEROS----------------------*/	
		
	always@(posedge num_ready)
		begin
			case(state)
			stateA:
				begin
					fifo_data_in <= dato;
					flag_pulso_wr_enable <= 1; //mando pulso para escribir en fifo
				end
			endcase
		end
		
/*--------PROCESAMIENTO DE NUMEROS-------------------------*/
/*Primer always me extrae los numeros de la fifo*/

	always@(posedge clk)
		begin
			if(state == stateB)	//si estoy procesando
				begin
					if(!fifo_empty)	//y quedan datos
						begin
							flag_pulso_rd_enable <= 1; //saca el dato de la fifo
						end
					else flag_procesando <= 0;
				end
			
		end
		
/*Segundo always calcula el resultado ponderando los valores*/
	always@(posedge clk)
		begin
			if(state == stateB)
				if(flag_dato_nuevo == 1)
				begin
						result_tmp <= result_tmp + fifo_data_out*(10**fifo_data_count); //la magia
						flag_dato_nuevo <= 0;
				end
		end
		

/*---------------------Envio de resultado------*/

	always@(posedge clk)
		begin
			if(state == stateC)
				begin
					resultado <= result_tmp;
					flag_pulso_done = 1;
				end
		end
		
		
		
	always@(posedge clk)
		begin
			if(state == stateD) result_tmp = 0;
		end
		
/*--------MANDA PULSOS----------*/	
	always@(posedge clk)
		begin
			/*wr_enable*/
			if(flag_pulso_wr_enable == 1)
			begin
				if(fifo_wr_en == 0) fifo_wr_en <= 1;
				else 
					begin
						fifo_wr_en <= 0;
						flag_pulso_wr_enable <=0;
					end
			end
			
			/*rd_enable*/
			if(flag_pulso_rd_enable == 1)
			begin
				if(fifo_rd_en == 0) 
					begin
						fifo_rd_en <= 1;

					end
				else 
					begin
						fifo_rd_en <= 0;
						flag_pulso_rd_enable <=0;
						flag_dato_nuevo <= 1;
					end
			end
			
			/*reset fifo*/
			if(flag_pulso_reset_fifo == 1)
			begin
				if(fifo_n_reset == 1) fifo_n_reset <= 0;
				else 
					begin
						fifo_n_reset <= 1;
						flag_pulso_reset_fifo <= 0;
					end
			end
			
			
			/*pulso done*/
			if(flag_pulso_done == 1)
			begin
				if(done == 0) done <= 1;
				else 
					begin
						done <= 0;
						flag_pulso_done <= 0;
					end
			end
		end
		

	

endmodule
