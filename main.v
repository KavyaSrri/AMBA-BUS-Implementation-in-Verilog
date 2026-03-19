module main (
    input wire hclk,
    input wire hresetn,
    input wire [3:0] switch_pins,
    output wire [3:0] led_pins
);

    wire [3:0] haddr;
    wire hwrite;
    wire [2:0] hsize;
    wire [2:0] hburst;
    wire [3:0] hprot;
    wire [1:0] htrans;
    wire [3:0] hwdata;
    wire [3:0] hrdata;
    wire hready;
    wire [1:0] hresp;

    wire [3:0] paddr;
    wire pwrite;
    wire pbridge_sel;
    wire penable;
    wire [3:0] pwdata;
    wire [3:0] prdata;
    wire pready;
    wire pslverr;

    wire psel_1;
    wire psel_2;
    
    wire [3:0] prdata_1;
    wire pready_1;
    wire pslverr_1;
    
    wire [3:0] prdata_2;
    wire pready_2;
    wire pslverr_2;

    ahb_master u_ahb_master (
        .hclk(hclk),
        .hresetn(hresetn),
        .hready_out(hready),
        .hresp(hresp),
        .hrdata(hrdata),
        .haddr(haddr),
        .hwrite(hwrite),
        .hsize(hsize),
        .hburst(hburst),
        .hprot(hprot),
        .htrans(htrans),
        .hwdata(hwdata)
    );

    ahb_to_apb_bridge u_ahb_to_apb_bridge (
        .hclk(hclk),
        .hresetn(hresetn),
        .hsel(1'b1), 
        .hreadyin(hready),
        .haddr(haddr),
        .hwrite(hwrite),
        .htrans(htrans),
        .hwdata(hwdata),
        .hreadyout(hready),
        .hresp(hresp),
        .hrdata(hrdata),
        .paddr(paddr),
        .pwrite(pwrite),
        .pbridge_sel(pbridge_sel),
        .penable(penable),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    apb_decoder_mux u_apb_decoder_mux (
        .paddr(paddr),
        .pbridge_sel(pbridge_sel),
        .psel_1(psel_1),
        .psel_2(psel_2),
        .prdata_1(prdata_1),
        .pready_1(pready_1),
        .pslverr_1(pslverr_1),
        .prdata_2(prdata_2),
        .pready_2(pready_2),
        .pslverr_2(pslverr_2),
        .prdata(prdata),
        .pready(pready),
        .pslverr(pslverr)
    );

    apb_slave_inputs u_apb_slave_inputs (
        .pclk(hclk),
        .presetn(hresetn),
        .psel_1(psel_1),
        .penable(penable),
        .pwrite(pwrite),
        .switch_pins(switch_pins),
        .prdata_1(prdata_1),
        .pready_1(pready_1),
        .pslverr_1(pslverr_1)
    );

    apb_slave_leds u_apb_slave_leds (
        .pclk(hclk),
        .presetn(hresetn),
        .psel_2(psel_2),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata_2(prdata_2),
        .pready_2(pready_2),
        .pslverr_2(pslverr_2),
        .led_pins(led_pins)
    );

endmodule
