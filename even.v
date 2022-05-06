module even(
	input [7:0] 	data,
	output 		res);

assign res = ~data[0];

endmodule

`timescale 1ns/100ps
module top();
reg	test;
wire	res_top;
even even1(.data(test), .res(res_top));
initial test = 8'b0;
always
begin
	#10
	test = test + 1'b1;
	$display("data = %d", test);
	$display("tes  = %d", res_top);
end

initial 
begin
	#100
	$stop;
end
endmodule
