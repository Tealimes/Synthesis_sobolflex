//outputs the random number
`ifndef sobolflex_core
`define sobolflex_core

module sobolflex_core #(
    parameter BITWIDTH = 8
) (
    input wire iClk, //clock
    input wire iRstN, //asynch reset active low
    input wire iSel,
    input wire iClr,
    input wire [BITWIDTH - 1: 0] iOneHot, //iOneHot
    input wire [BITWIDTH*BITWIDTH - 1: 0] dirVec,
    output wire [BITWIDTH - 1: 0] oRand //output random number
);

    wire [BITWIDTH * BITWIDTH - 1: 0] orVec;
    wire [BITWIDTH - 1: 0] vec;
    reg [BITWIDTH - 1: 0] oRand0;
    reg [BITWIDTH - 1: 0] oRand1;
    wire [BITWIDTH - 1: 0] oRand_vec;
    

    assign orVec[BITWIDTH - 1: 0] = iOneHot[0] ? dirVec[BITWIDTH - 1: 0] : 0;

    genvar i;
    generate 
        for(i = 1; i < BITWIDTH; i = i + 1) begin
            assign orVec[(i+1)*BITWIDTH-1:i*BITWIDTH] = orVec[i*BITWIDTH-1:(i-1)*BITWIDTH] | (iOneHot[i] ? dirVec[(i+1)*BITWIDTH-1 : i*BITWIDTH] : 0);
        end
    endgenerate

    assign vec = orVec[BITWIDTH*BITWIDTH - 1: (BITWIDTH-1)*BITWIDTH];

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oRand0 <= 0;
            oRand1 <= 0;
        end else begin
            if(iClr) begin
                oRand0 <= 0;
                oRand1 <= 0;
            end else begin    
                if(iSel) begin
                    oRand0 <= oRand0;
                    oRand1 <= oRand_vec;
                end else begin 
                    oRand0 <= oRand_vec;
                    oRand1 <= oRand1;
                end 
            end 
        end
    end
    
    assign oRand_vec = oRand ^ vec;
    assign oRand = (iSel) ? oRand1 : oRand0;
    
endmodule

`endif

