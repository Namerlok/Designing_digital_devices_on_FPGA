module decoder(
	input [2:0] N,
	output [7:0] res
);

assign res = 1'b1 << N;

endmodule

`timescale 1ns/100ps
module top();
reg [2:0] in;
wire [7:0] result;

decoder decoder_1(.N(in), .res(result));

initial in = 3'b0;

always 
begin
	#10
	
	in = in + 3'b1;
	$display("N (input) = %d", in);
	$display("res (output) = %d", result);
end

initial 
begin
	#80
	$stop;
end
endmodule

