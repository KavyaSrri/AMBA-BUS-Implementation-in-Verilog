module apb_slave_inputs (
input wire pclk,
input wire presetn,
input wire psel_1,
input wire penable,
input wire pwrite,
input wire [3:0] switch_pins,
output reg [3:0] prdata_1,
output reg pready_1,
output reg pslverr_1
);

always @(posedge pclk or negedge presetn) begin
 if (!presetn) begin
  pready_1 <= 1'b0;
  pslverr_1 <= 1'b0;
  prdata_1 <= 4'd0;
 end else begin
  pready_1 <= 1'b0;
  pslverr_1 <= 1'b0;
  if (psel_1 && penable) begin
	pready_1 <= 1'b1;
	pslverr_1 <= 1'b0;
   if (!pwrite) begin
	 prdata_1 <= switch_pins;
	end
  end
 end
end
endmodule
