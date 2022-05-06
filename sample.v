module my_and
(
	input a,
	input b,
	output c
);
	assign c = a & b;
endmodule

module    my_and_4 (
    input        a0, a1, a2, a3,
    output        z
);
wire    a0a1_and, a2a3_and;    // ????????????? ???????
my_and
and_01 (
    .a ( a0 ),
    .b ( a1 ),
    .c ( a0a1_and ) );

my_and
and_23 (
    .a ( a2 ),
    .b ( a3 ),
    .c ( a2a3_and ) );

my_and
and_0123 (
     .a ( a0a1_and  ),
    .b ( a2a3_and  ),
    .c ( z) );
endmodule 

module top();

wire [3:0]     data;
wire        result;
wire        temp;

my_and_4
and4
(
    .a0    (data[0]),
    .a1    (data[1]),
    .a2    (data[2]),
    .a3    (data[3]),
    .z    (result)
);

assign    data =    4'hf;
assign    temp =    ~result;
endmodule