module clk_div_six (
	input 	wire	clk,
	input	wire	reset,
	output	reg	clk_div2,
	output	reg	clk_div4,
	output	reg	clk_div8,
	output	reg	clk_div6
);
initial	clk_div2 = 1'b0;
initial	clk_div4 = 1'b0;
initial	clk_div8 = 1'b0;
initial	clk_div6 = 1'b0;

reg [1:0]	flag = 2'b0;

always @(posedge clk)
if (reset) begin
	clk_div2 <= 1'h0;
	flag = 2'b0;
end 
else if (flag == 2'b10) begin 
	clk_div6 <= ~clk_div6;
	flag = 2'b0;
end
else begin
	clk_div2 <= ~clk_div2; 
	flag = flag + 2'b1;
end

always @(posedge clk_div2)
if (reset) 
	clk_div4 <= 1'h0; 
else begin 
	clk_div4 <= ~clk_div4; 
end

always @(posedge clk_div4)
if (reset) 
	clk_div8 <= 1'h0; 
else begin 
	clk_div8 <= ~clk_div8; 
end

endmodule

`timescale 1ns/100ps
module top();
reg	clk_top;
reg	reset_top;

clk_div_six clk_div_six1(.clk(clk_top), .reset(reset_top));

initial clk_top = 1'b0;
initial reset_top = 1'b0;

always
begin
	#10
	clk_top = ~clk_top;
end

initial 
begin
	#200
	$stop;
end
endmodule