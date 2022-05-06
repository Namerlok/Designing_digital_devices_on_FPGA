module counter (
	input clock,
	input reset,
	input butt_add,
	input butt_sub,
	output reg [6:0] sevenseg
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
		sevenseg <= 0;
		num <= 0;
	end
	
	else if(push_add)
		num <= num + 4'h1;
		
	else if(push_sub)
	begin
		if (num != 4'h0)
			num <= num - 4'h1;
	end
			
	sevenseg <= (num == 4'h0) ? 7'b1000000:
		    (num == 4'h1) ? 7'b1111001:
  		    (num == 4'h2) ? 7'b0100100:
		    (num == 4'h3) ? 7'b0110000:
		    (num == 4'h4) ? 7'b0011001:
		    (num == 4'h5) ? 7'b0010010:
		    (num == 4'h6) ? 7'b0000010:
		    (num == 4'h7) ? 7'b1111000:
		    (num == 4'h8) ? 7'b0000000:
		    (num == 4'h9) ? 7'b0010000:
		    (num == 4'ha) ? 7'b0001000:
		    (num == 4'hb) ? 7'b0000011:
		    (num == 4'hc) ? 7'b1000110:
		    (num == 4'hd) ? 7'b0100001:
		    (num == 4'he) ? 7'b0000110:
		    7'b0001110;
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