`timescale 1ns / 1ps



module Main( input wire rx, clk, reset,
				output wire tx );
	 
	 
	wire out_baudrate;
	wire [7:0] d_in;
	wire rx_done;
	wire [7:0] d_out;
	wire tx_start;
	wire tx_done;
	wire [7:0] data_out_alu;
	wire [7:0] data_out_alu;
	wire [7:0] A;
	wire [7:0] B;
	wire [5:0] opcode;
	
	BaudRateGenerator baudrate (
	.clk(clk), 
	.out(out_baudrate)
	);
	
	RX Rx (
		.clk(clk), 
		.baud_rate(out_baudrate), 
		.rx(rx), 
		.d_out(d_in), 
		.rx_done(rx_done)
	);
	
	TX Tx (
		.clk(clk), 
		.baud_rate(out_baudrate), 
		.d_in(d_out), 
		.tx_start(tx_start), 
		.tx(tx), 
		.tx_done(tx_done)
	);
	
	 Interface interface (
		.clk(clk), 
		.reset(reset),
		.d_in(d_in),
		.rx_done(rx_done),
		.tx_done(tx_done),
		.d_in_alu(d_in_alu),
		.d_out(d_out),
		.tx_start(tx_start),
		.A(A),
		.B(B),
		.opcode(opcode)
	);
	
	ALU alu(
		.A(A),
		.B(B),
		.Opcode(opcode),
		.Out(d_in_alu)
	);

endmodule
