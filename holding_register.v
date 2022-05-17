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


module holding_register (

	input wire sw_load_left_raw,
	input wire btn_reset,
	input wire clk,
	input wire btn_load,
	input wire btn_transmit,
	input wire [7:0] sw_load_value_raw,

	output wire [7:0] leds_red,
	output wire [7:0] leds_green,

	output wire low_seg7_up,
	output wire low_seg7_middle,
	output wire low_seg7_bottom,
	output wire low_seg7_bottom_left,
	output wire low_seg7_bottom_right,
	output wire low_seg7_up_left,
	output wire low_seg7_up_right,

	output wire high_seg7_up,
	output wire high_seg7_middle,
	output wire high_seg7_bottom,
	output wire high_seg7_bottom_left,
	output wire high_seg7_bottom_right,
	output wire high_seg7_up_left,
	output wire high_seg7_up_right
	);

	reg push_transmit;
	reg push_load;
	reg sw_load_left;
	reg [7:0] sw_load_value;
	reg [7:0] shift_register_bus_red;
	reg [7:0] shift_register_bus_green;

	assign leds_red = shift_register_bus_red;
	assign leds_green = shift_register_bus_green;

	reg btn_transmit_r;
	reg btn_transmit_rr;
	reg btn_load_r;
	reg btn_load_rr;

	always @(posedge clk) begin
		btn_transmit_r <= btn_transmit;
		btn_transmit_rr <= btn_transmit_r;
		push_transmit <= btn_transmit_rr & ~btn_transmit_r;

		btn_load_r <= btn_load;
		btn_load_rr <= btn_load_r;
		push_load <= btn_load_rr & ~btn_load_r;
		
		sw_load_left <= sw_load_left_raw;
		sw_load_value <= sw_load_value_raw;
	end
	 
	 
	always @(posedge clk) begin
		if (!btn_reset) begin
			shift_register_bus_red <= 8'b0;
			shift_register_bus_green <= 8'b0;
			end
		else begin
			if (push_load)
				shift_register_bus_red <= sw_load_value;
			else if (push_transmit) begin
					shift_register_bus_red <= (shift_register_bus_red >> 1) | { sw_load_left, { 7'b0 } };
					shift_register_bus_green <= (shift_register_bus_green >> 1) | { shift_register_bus_red[0], { 7'b0 } };
			end
		end
	end
	 
	 module_hex_to_7seg
	 m_hex_to_7seg_low (
	    .hex (shift_register_bus_red[3:0]),
		 
		 .up (low_seg7_up),
       .middle (low_seg7_middle),
       .bottom (low_seg7_bottom),
       .bottom_left (low_seg7_bottom_left),
       .bottom_right (low_seg7_bottom_right),
       .up_left (low_seg7_up_left),
       .up_right (low_seg7_up_right)
	 );
	 
	 module_hex_to_7seg
	 m_hex_to_7seg_high (
	    .hex (shift_register_bus_red[7:4]),
		 
		 .up (high_seg7_up),
       .middle (high_seg7_middle),
       .bottom (high_seg7_bottom),
       .bottom_left (high_seg7_bottom_left),
       .bottom_right (high_seg7_bottom_right),
       .up_left (high_seg7_up_left),
       .up_right (high_seg7_up_right)
	 );
endmodule