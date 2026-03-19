module ahb_master(   
input wire hclk,            //clock
input wire hresetn,          //Active low reset
input wire hready_out,       //0: master to wait 1: transfer complete, master can 

input wire [1:0] hresp,        //transfer response (SS ATTACHED)
input wire [3:0] hrdata,       //S to M 
output reg [3:0] haddr,        //Address bus AHB 
output reg hwrite,             //write control signal (for Master)
   
output wire [2:0] hsize,       //Hardcoded to 000 (SS ATTACHED)
output wire [2:0] hburst,      //Hardcoded to 000 (SS ATTACHED)
output wire [3:0] hprot,       //Hardcoded to 001 (SS ATTACHED)

output reg [1:0] htrans,       //Transfer type (SS ATTACHED)
output reg [3:0] hwdata        //M to S
);

assign hsize  = 3'b000;
assign hburst = 3'b000;
assign hprot  = 4'b0001; //data access and user access 

reg [2:0] state;                 //states
reg [3:0] switch_val;           //temp cells

always @(posedge hclk or negedge hresetn) begin
 if (!hresetn) begin
  state <= 3'd0;
  haddr <= 4'd0; 
  hwrite <= 1'b0;
  htrans <= 2'b00;
  hwdata <= 4'd0;
  switch_val <= 4'd0;
  end else begin
   case (state)
    3'd0: begin
     haddr <= 4'h0;
     hwrite <= 1'b0;
     htrans <= 2'b10; //NONSEQ
     state <= 3'd1;
    end
    3'd1: begin
     htrans <= 2'b00; //IDLE
     if (hready_out) begin
		switch_val <= hrdata;
		state <= 3'd2;
     end
    end
    3'd2: begin
     haddr <= 4'h1;
     hwrite <= 1'b1;
     htrans <= 2'b10;
     state <= 3'd3;
    end
 3'd3: begin
  hwdata <= switch_val;
  htrans <= 2'b00;
  if (hready_out) begin
		state <= 3'd0;
  end
 end
 default: state <= 3'd0;
endcase
  end
 end
endmodule
