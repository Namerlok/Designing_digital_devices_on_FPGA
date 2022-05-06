module shift_counter (
	input wire butt_shift_left,
	input wire butt_shift_right,
	input wire sw_load_left_raw,
	input wire sw_load_right_raw,
	input wire reset,
	input wire clock,
	output wire [7:0] leds
);

	reg sw_load_left;
	reg sw_load_right;
	reg [7:0] shift_led_bus;

	assign leds = shift_led_bus;

	reg butt_r_shift_left;
	reg butt_rr_shift_left;
	reg push_left;

	reg butt_r_shift_right;
	reg butt_rr_shift_right;
	reg push_right;
	 
	always @(posedge clock)
		sw_load_left <= sw_load_left_raw;

	always @(posedge clock)
		sw_load_right <= sw_load_right_raw;

	always @(posedge clock) begin
		if (!reset)
			shift_led_bus <= 8'b0;
		else begin
			if (push_left & ~push_right) begin
				shift_led_bus <= { leds[6:0], sw_load_right };
			end

			if (push_right & ~push_left) begin 
				shift_led_bus <= { sw_load_left, leds[7:1] };
			end			
		end
	end
		 
	always@(posedge clock) begin
		butt_r_shift_left <= butt_shift_left;
		butt_rr_shift_left <= butt_r_shift_left;
		push_left <= butt_rr_shift_left & ~butt_r_shift_left;
	end

	always@(posedge clock) begin
		butt_r_shift_right <= butt_shift_right;
		butt_rr_shift_right <= butt_r_shift_right;
		push_right <= butt_rr_shift_right & ~butt_r_shift_right;
	end
	 
endmodule