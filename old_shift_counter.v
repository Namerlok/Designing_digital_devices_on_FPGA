// btn and reset are inverted
module module_button_push (
    input wire clk,
	 input wire btn,
	 
	 output wire push
);
    
	 reg btn_r;
	 reg btn_rr;
	 
	 assign push = btn_rr & ~btn_r;
	 
	 always @(posedge clk) begin
	     btn_r <= btn;
		  btn_rr <= btn_r;
	 end
endmodule

module module_sw (
    input wire clk,
	 input wire sw_raw,
	 
	 output reg sw
); 
	 always @(posedge clk)
	     sw <= sw_raw;
endmodule

// on recieving one-tact push left/right with writing load rigt/left bit
module module_shift_register
   #( parameter BITS = 8 ) (
	
   input wire clk,
   input wire reset,
   input wire push_left,
   input wire push_right,
   input wire load_left,
   input wire load_right,
	
   output reg [BITS - 1:0] register
);

   always @(posedge clk) begin
	    if (reset)
		     register <= { BITS { 1'b0 } };
	    else begin
		     if (push_left & ~push_right)
			       register <= { register[BITS - 1:1], load_right };
			  if (push_right & ~push_left)
			       register <= { load_left, register[BITS - 2:0] };
		 end
	end

endmodule


// bottons are inversed
module old_shift_counter
    #( parameter BITS = 8 ) (
	 
    input wire btn_shift_left,
	 input wire btn_shift_right,
	 input wire sw_load_left_raw,
	 input wire sw_load_right_raw,
    input wire btn_reset,
	 input wire clk,

    output wire [BITS - 1:0] leds
);

    wire push_left;
	 wire push_right;
	 wire sw_load_left;
	 wire sw_load_right;
	 wire [BITS - 1:0] shift_register_bus;
	 
	 assign leds = shift_register_bus;

    module_button_push
	 m_btn_push_left (
	     .clk (clk),
		  .btn (btn_shift_left),
		  .push (push_left)
	 );
	 
	 module_button_push
	 m_btn_push_right (
	     .clk (clk),
		  .btn (btn_shift_right),
		  .push (push_right)
	 );
	 
	 module_sw
	 m_sw_load_left (
	     .clk (clk),
		  .sw_raw (sw_load_left_raw),
		  .sw (sw_load_left)
	 );
	 
	 module_sw
	 m_sw_load_right (
	     .clk (clk),
		  .sw_raw (sw_load_right_raw),
		  .sw (sw_load_right)
	 );
	 
	 module_shift_register
	 m_shift_register (
	    .clk (clk),
		 .reset (~btn_reset),
		 .push_left (push_left),
		 .push_right (push_right),
		 .load_left (sw_load_left),
		 .load_right (sw_load_right),
		 .register (shift_register_bus)
	 );
endmodule