`timescale 1ns / 1ps

module pruebaTX(input clk, output tx);
	
	wire baud_rate;	
	wire [7:0] d_in = 'b1000001;
	reg tx_start;
	wire tx_done;
	
	BaudRateGenerator baud (
		.clk(clk), 
		.out(baud_rate)
	);
	
	TX transmisor (
		.clk(clk), 
		.baud_rate(baud_rate), 
		.d_in(d_in), 
		.tx_start(tx_start), 
		.tx(tx), 
		.tx_done(tx_done)
	);
	
	always@(posedge clk)
	begin
		tx_start = 1;
	end

endmodule
