module ahb_to_apb_bridge (
input wire hclk,
input wire hresetn,
input wire hsel,           //AHB bus would be selected 
input wire hreadyin,       //=1 cpu is ready for ip 

input wire [3:0] haddr,      //address bus 
input wire hwrite,        //control signal write 
input wire [1:0] htrans,    //transfer status
input wire [3:0] hwdata,   //data transfer 

output reg hreadyout,        //=1 cpu is ready for op 
output reg [1:0] hresp,      //response status
output reg [3:0] hrdata,     //S to M
  
output reg [3:0] paddr,      //APB bus 
output reg pwrite,          //control signal write 
output reg pbridge_sel,       //APB bus would be selected 
output reg penable,          //=1 transfer takes place 
output reg [3:0] pwdata,     //write data 
input wire [3:0] prdata,      //read data 
input wire pready,         	 //completion flag for transfer of data 
input wire pslverr         //0: OK, 1: Error
);

reg [1:0] apb_state;          //00--IDLE 01--APB Bus select 10--Transfer 
reg [3:0] latched_addr;         //holds the address till completion 
reg latched_write;            //to hold the value of control signal until an operation finishes 

always @(posedge hclk or negedge hresetn) begin
 if (!hresetn) begin
  apb_state <= 2'b00;
  hreadyout <= 1'b1;
  hresp <= 2'b00;
  hrdata <= 4'd0;
  paddr <= 4'd0;
  pwrite <= 1'b0;
  pbridge_sel <= 1'b0;
  penable <= 1'b0;
  pwdata <= 4'd0;
  latched_addr <= 4'd0;
  latched_write <= 1'b0;
  end else begin
   case (apb_state)
    2'b00: begin
     if (hsel && hreadyin && (htrans == 2'b10 || htrans == 2'b11)) begin
      latched_addr <= haddr;
      latched_write <= hwrite;
      hreadyout <= 1'b0; 
      apb_state <= 2'b01;
     end else begin
      hreadyout <= 1'b1;
      pbridge_sel <= 1'b0;
      penable <= 1'b0;
     end
    end
    2'b01: begin
     pbridge_sel <= 1'b1;
     penable <= 1'b0;
     paddr <= latched_addr;
     pwrite <= latched_write;
     if (latched_write) 
	   pwdata <= hwdata;
      apb_state <= 2'b10;
     end
     2'b10: begin
     penable <= 1'b1;
     if (pready) begin
      pbridge_sel <= 1'b0;
      penable <= 1'b0;
      if (!latched_write)
	    hrdata <= prdata;
       hresp <= pslverr ? 2'b01 : 2'b00; //01--error 00--OKAY 
       hreadyout <= 1'b1; 
       apb_state <= 2'b00;
      end
     end
     default: apb_state <= 2'b00;
   endcase
  end
end
endmodule
