`timescale 1ns / 1ps


module ConcatenadorNumeros 	
	#( parameter stateA = 5'b00001,	//cargando datos en fifo
		parameter stateB = 5'b00010,	//calculando datos
		parameter stateC = 5'b00100,	//devuelvo
		parameter stateD = 5'b01000,	//reseteo 
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
	 
	reg [4:0] state = stateA;
	reg [4:0] next_state = stateA;
	
	reg flag_fin_carga; 		//flag que indica cuando se terminaron de cargar datos
	
	reg flag_procesando = 0; //si estoy haciendo la cuenta
	reg flag_dato_nuevo = 0; //flag para el estado B de ponderacion de numeros
	reg end_proc = 0;
	
	integer result_tmp = 0;
	integer aux;
	integer i;
	
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
	
	reg [2:0] res_state = 0;
	
	always@(posedge clk)
		begin
			if(res_state == 0)
				begin
				if (!reset) 
					begin
						//next_state <= stateA;
						fifo_n_reset <= 0;
						res_state <= 1;
					end
				else state <= next_state;
				end
			else 
				begin
				fifo_n_reset <= 1;
				res_state <= 0;
				end
		end
		
	/*CAMBIO DE ESTADOS*/
		
	always@(posedge clk)
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
				stateB: 
					begin
					if(end_proc == 1) flag_procesando <= 0;
					if(!flag_procesando) next_state <= stateC;
					end
				stateC: next_state <= stateD;
				stateD: next_state <= stateA;
			endcase
		end
		
/*--------------------CARGA DE NUMEROS----------------------*/	
		
	reg [2:0] num_ready_state = 0;	
	
	always@(posedge clk)
	begin
		if(num_ready_state == 0)
		begin
			if(state == stateA)
			begin
				if(num_ready)
					begin
						fifo_data_in <= dato;
						fifo_wr_en = 1;
						num_ready_state = 1;
					end
			end
		end
		else begin
			if(num_ready == 0) 
				begin
				num_ready_state = 0;
				fifo_wr_en = 0;
				end
		end
		end
		
/*--------PROCESAMIENTO DE NUMEROS-------------------------*/
/*Primer always me extrae los numeros de la fifo*/

	reg [2:0] rd_en_state = 0;

	always@(posedge clk)
		begin
			if(rd_en_state == 0)
				begin
				if(state == stateB)
					begin
						if(!fifo_empty)
							begin
							fifo_rd_en <= 1;
							rd_en_state <= 1;
							end
						else 
							begin
								if(flag_procesando == 1) end_proc <= 1;
								else end_proc <= 0;
							end
					end
				end
			if(rd_en_state == 1) 
					begin
					rd_en_state <= 2;
					fifo_rd_en <= 0;
					flag_dato_nuevo <= 1;
					end
			if(rd_en_state == 2) 
				begin
				flag_dato_nuevo <= 0;
				rd_en_state <= 0;
				end
		end
		
/*Segundo always calcula el resultado ponderando los valores*/
	always@(posedge clk)
		begin
			if(state == stateB)
				if(flag_dato_nuevo == 1)
				begin
					aux = 1;
					for(i = 0; i<16;i=i+1)
					begin
						if(i<fifo_data_count) aux = aux*10;
					end
					result_tmp = result_tmp + fifo_data_out*aux;
					//result_tmp <= result_tmp + fifo_data_out*(10**fifo_data_count); //la magia
				end
			if(state == stateD) result_tmp = 0;	
		end
		

/*---------------------Envio de resultado------*/

	reg [2:0] done_state = 0;

	always@(posedge clk)
		begin
			if(done_state == 0)
			begin
				if(state == stateC)
					begin
						done_state <= 1;
						resultado <= result_tmp;
						done <= 1;
					end
			end
			else
				begin
				done_state <= 0;
				done <= 0;
				end
		end
		
endmodule
