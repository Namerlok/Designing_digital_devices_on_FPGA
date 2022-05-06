module column_counter (
	input clock,
	input reset,
	input butt_add,
	input butt_sub,
	output reg [8:0] led
);

reg butt_r_add;
reg butt_rr_add;
reg push_add;

reg butt_r_sub;
reg butt_rr_sub;
reg push_sub;

reg [3:0] num;

always@(posedge clock)
begin
	if(!reset)
	begin
		led <= 0;
		num <= 0;
	end
	
	else if (num == 4'b1001)
		num <= 4'b0;
		
	else if (num == 4'b1111)
		num <= 4'b1000;
	
	else if(push_add)
		num <= num + 4'h1;
		
	else if(push_sub)
		num <= num - 4'h1;
			
	led <= 8'b11111111 >> (4'b1000 - num);
end

always@(posedge clock)
begin
	butt_r_add <= butt_add;
	butt_rr_add <= butt_r_add;
	push_add <= butt_rr_add & ~butt_r_add;
end

always@(posedge clock)
begin
	butt_r_sub <= butt_sub;
	butt_rr_sub <= butt_r_sub;
	push_sub <= butt_rr_sub & ~butt_r_sub;
end	
endmodule