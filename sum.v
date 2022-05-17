module module_hex_to_7seg (
	input wire [3:0] hex,

	output wire up,
	output wire middle,
	output wire bottom,
	output wire bottom_left,
	output wire bottom_right,
	output wire up_left,
	output wire up_right
);

	assign             up = (hex == 4'h1) ? 1'b1 :
		(hex == 4'h4) ? 1'b1 :
		(hex == 4'hb) ? 1'b1 :
		(hex == 4'hd) ? 1'b1 : 1'b0;

	assign         middle = (hex == 4'h0) ? 1'b1 :
		(hex == 4'h1) ? 1'b1 :
		(hex == 4'h7) ? 1'b1 :
		(hex == 4'hc) ? 1'b1 : 1'b0;

	assign         bottom = (hex == 4'h1) ? 1'b1 :
		(hex == 4'h4) ? 1'b1 :
		(hex == 4'h7) ? 1'b1 :
		(hex == 4'ha) ? 1'b1 :
		(hex == 4'hf) ? 1'b1 : 1'b0;

	assign    bottom_left = (hex == 4'h1) ? 1'b1 :
		(hex == 4'h3) ? 1'b1 :
		(hex == 4'h4) ? 1'b1 :
		(hex == 4'h5) ? 1'b1 :
		(hex == 4'h7) ? 1'b1 :
		(hex == 4'h9) ? 1'b1 : 1'b0;

	assign   bottom_right = (hex == 4'h2) ? 1'b1 :
		(hex == 4'hc) ? 1'b1 :
		(hex == 4'he) ? 1'b1 :
		(hex == 4'hf) ? 1'b1 : 1'b0;

	assign        up_left = (hex == 4'h1) ? 1'b1 :
		(hex == 4'h2) ? 1'b1 :
		(hex == 4'h3) ? 1'b1 :
		(hex == 4'h7) ? 1'b1 :
		(hex == 4'hd) ? 1'b1 : 1'b0;

	assign       up_right = (hex == 4'h5) ? 1'b1 :
		(hex == 4'h6) ? 1'b1 :
		(hex == 4'hb) ? 1'b1 :
		(hex == 4'hc) ? 1'b1 :
		(hex == 4'he) ? 1'b1 :
		(hex == 4'hf) ? 1'b1 : 1'b0;

	endmodule

module sum (
	input wire btn_reset,
	input wire clk,
	input wire btn_sum,
	input wire [7:0] sw_load_a_raw,
	input wire [7:0] sw_load_b_raw,

	output wire [7:0] leds_red_a,
	output wire [7:0] leds_red_b,
	output wire [7:0] leds_green_sum,
	output reg led_overflow,

	output wire a_low_seg7_up,
	output wire a_low_seg7_middle,
	output wire a_low_seg7_bottom,
	output wire a_low_seg7_bottom_left,
	output wire a_low_seg7_bottom_right,
	output wire a_low_seg7_up_left,
	output wire a_low_seg7_up_right,
	output wire a_high_seg7_up,
	output wire a_high_seg7_middle,
	output wire a_high_seg7_bottom,
	output wire a_high_seg7_bottom_left,
	output wire a_high_seg7_bottom_right,
	output wire a_high_seg7_up_left,
	output wire a_high_seg7_up_right,

	output wire b_low_seg7_up,
	output wire b_low_seg7_middle,
	output wire b_low_seg7_bottom,
	output wire b_low_seg7_bottom_left,
	output wire b_low_seg7_bottom_right,
	output wire b_low_seg7_up_left,
	output wire b_low_seg7_up_right,
	output wire b_high_seg7_up,
	output wire b_high_seg7_middle,
	output wire b_high_seg7_bottom,
	output wire b_high_seg7_bottom_left,
	output wire b_high_seg7_bottom_right,
	output wire b_high_seg7_up_left,
	output wire b_high_seg7_up_right,

	output wire sum_low_seg7_up,
	output wire sum_low_seg7_middle,
	output wire sum_low_seg7_bottom,
	output wire sum_low_seg7_bottom_left,
	output wire sum_low_seg7_bottom_right,
	output wire sum_low_seg7_up_left,
	output wire sum_low_seg7_up_right,
	output wire sum_high_seg7_up,
	output wire sum_high_seg7_middle,
	output wire sum_high_seg7_bottom,
	output wire sum_high_seg7_bottom_left,
	output wire sum_high_seg7_bottom_right,
	output wire sum_high_seg7_up_left,
	output wire sum_high_seg7_up_right
	);

	reg push_sum;
	reg [7:0] sw_load_a;
	reg [7:0] sw_load_b;
	reg [7:0] bus_sum_out;
	reg [7:0] bus_sum_through;
	reg bus_overflow;

	assign leds_red_a = sw_load_a;
	assign leds_red_b = sw_load_b;
	assign leds_green_sum = bus_sum_out;
	 
	reg btn_sum_r;
	reg btn_sum_rr;

	always @(posedge clk) begin
		btn_sum_r <= btn_sum;
		btn_sum_rr <= btn_sum_r;
		push_sum <= btn_sum_rr & ~btn_sum_r;
		
		sw_load_a <= sw_load_a_raw;
		sw_load_b <= sw_load_b_raw;
		
	end
	
	always @(posedge clk) begin
		if (!btn_reset) begin
			bus_sum_out <= { 8'b0 };
			led_overflow <= { 1'b0 };
		end else if (push_sum) begin
			bus_sum_out <= bus_sum_through;
			led_overflow <= bus_overflow;
		end
	end
	 
	reg [8:0] temp_sum;
	
	always @(posedge clk) begin
		temp_sum = sw_load_a + sw_load_b;
		bus_overflow = temp_sum[8];
		bus_sum_through = temp_sum[7:0];
	end

	module_hex_to_7seg
	m_hex_to_7seg_a_low (
		.hex (sw_load_a[3:0]),

		.up (a_low_seg7_up),
		.middle (a_low_seg7_middle),
		.bottom (a_low_seg7_bottom),
		.bottom_left (a_low_seg7_bottom_left),
		.bottom_right (a_low_seg7_bottom_right),
		.up_left (a_low_seg7_up_left),
		.up_right (a_low_seg7_up_right)
	);

	module_hex_to_7seg
	m_hex_to_7seg_a_high (
		.hex (sw_load_a[7:4]),

		.up (a_high_seg7_up),
		.middle (a_high_seg7_middle),
		.bottom (a_high_seg7_bottom),
		.bottom_left (a_high_seg7_bottom_left),
		.bottom_right (a_high_seg7_bottom_right),
		.up_left (a_high_seg7_up_left),
		.up_right (a_high_seg7_up_right)
	);
	 
	module_hex_to_7seg
	m_hex_to_7seg_b_low (
		.hex (sw_load_b[3:0]),

		.up (b_low_seg7_up),
		.middle (b_low_seg7_middle),
		.bottom (b_low_seg7_bottom),
		.bottom_left (b_low_seg7_bottom_left),
		.bottom_right (b_low_seg7_bottom_right),
		.up_left (b_low_seg7_up_left),
		.up_right (b_low_seg7_up_right)
	);
	 
	module_hex_to_7seg
	m_hex_to_7seg_b_high (
		.hex (sw_load_b[7:4]),

		.up (b_high_seg7_up),
		.middle (b_high_seg7_middle),
		.bottom (b_high_seg7_bottom),
		.bottom_left (b_high_seg7_bottom_left),
		.bottom_right (b_high_seg7_bottom_right),
		.up_left (b_high_seg7_up_left),
		.up_right (b_high_seg7_up_right)
	);
	 
	module_hex_to_7seg
	m_hex_to_7seg_sum_low (
		.hex (bus_sum_out[3:0]),

		.up (sum_low_seg7_up),
		.middle (sum_low_seg7_middle),
		.bottom (sum_low_seg7_bottom),
		.bottom_left (sum_low_seg7_bottom_left),
		.bottom_right (sum_low_seg7_bottom_right),
		.up_left (sum_low_seg7_up_left),
		.up_right (sum_low_seg7_up_right)
	);
	 
	module_hex_to_7seg
	m_hex_to_7seg_sum_high (
		.hex (bus_sum_out[7:4]),

		.up (sum_high_seg7_up),
		.middle (sum_high_seg7_middle),
		.bottom (sum_high_seg7_bottom),
		.bottom_left (sum_high_seg7_bottom_left),
		.bottom_right (sum_high_seg7_bottom_right),
		.up_left (sum_high_seg7_up_left),
		.up_right (sum_high_seg7_up_right)
	);
	 
endmodule