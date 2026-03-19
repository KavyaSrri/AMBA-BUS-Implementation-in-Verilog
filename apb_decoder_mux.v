module apb_decoder_mux (
    input wire [3:0] paddr,
    input wire pbridge_sel,
    output reg psel_1,
    output reg psel_2,
    
    input wire [3:0] prdata_1,
    input wire pready_1,
    input wire pslverr_1,
    
    input wire [3:0] prdata_2,
    input wire pready_2,
    input wire pslverr_2,
    
    output reg [3:0] prdata,
    output reg pready,
    output reg pslverr
);

    always @(*) begin
        psel_1 = 1'b0;
        psel_2 = 1'b0;
        if (pbridge_sel) begin
            if (paddr == 4'h0) psel_1 = 1'b1;
            else if (paddr == 4'h1) psel_2 = 1'b1;
        end
    end

    always @(*) begin
        if (psel_1) begin
            prdata = prdata_1;
            pready = pready_1;
            pslverr = pslverr_1;
        end else if (psel_2) begin
            prdata = prdata_2;
            pready = pready_2;
            pslverr = pslverr_2;
        end else begin
            prdata = 4'd0;
            pready = 1'b1;
            pslverr = 1'b0;
        end
    end
endmodule
