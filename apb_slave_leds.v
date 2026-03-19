module apb_slave_leds (
 input wire pclk,
 input wire presetn,
 input wire psel_2,
 input wire penable,
 input wire pwrite,
 input wire [3:0] pwdata,
 output reg [3:0] prdata_2,
 output reg pready_2,
 output reg pslverr_2,
 output reg [3:0] led_pins
);

 always @(posedge pclk or negedge presetn) begin
  if (!presetn) begin
	pready_2 <= 1'b0;
	pslverr_2 <= 1'b0;
	prdata_2 <= 4'd0;
	led_pins <= 4'd0;
  end else begin
	pready_2 <= 1'b0;
	pslverr_2 <= 1'b0;

	if (psel_2 && penable) begin
		 pready_2 <= 1'b1;
		 pslverr_2 <= 1'b0;
		 
		 if (pwrite) begin
			  led_pins <= pwdata;
		 end 
	end
	end
  end
 
endmodule
