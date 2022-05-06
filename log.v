module log(
	input [7:0]	deg,
	output [2:0]	res
);
assign res =	{3{deg[0]}} & 3'h0 |
		{3{deg[1]}} & 3'h1 |
		{3{deg[2]}} & 3'h2 |
		{3{deg[3]}} & 3'h3 |
		{3{deg[4]}} & 3'h4 |
		{3{deg[5]}} & 3'h5 |
		{3{deg[6]}} & 3'h6 |
		{3{deg[7]}} & 3'h7;

endmodule

`timescale 1ns/100ps
module top();
reg [7:0]	test;
wire [2:0]	res_top;
log log1(.deg(test), .res(res_top));
initial test = 8'b1;
always
begin
	#10
	test = test << 1;
	$display("data = %d", test);
	$display("tes  = %d", res_top);
end

initial 
begin
	#80
	$stop;
end
endmodule
