`timescale 1ns / 1ps

module pruebaRX(input rx, input clk, output reg [7:0] leds);
	
	
	wire baud_rate;	
	wire rx_done;
	wire [7:0] d_out;
	
	BaudRateGenerator baud (
		.clk(clk), 
		.out(baud_rate)
	);
	
	RX receptor (
		.clk(clk), 
		.baud_rate(baud_rate), 
		.rx(rx), 
		.d_out(d_out), 
		.rx_done(rx_done)
	);
	
	always@(posedge rx_done)
	begin
		leds = d_out;
	end

endmodule
