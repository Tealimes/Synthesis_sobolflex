//By Alexander Peacock, undergrad at UCF ECE
//email: alexpeacock56ten@gmail.com

//Generates position of lsz
`ifndef cntwithsel
`define cntwithsel

module cntwithsel #(
    parameter BITWIDTH = 4 //specifies bitwidth
) (
    input wire iClk, //clock
    input wire iRstN, //asynch reset active low
    input wire iSel, 
    input wire iClr, 
    output wire [BITWIDTH - 1:0] oCnt
);

    reg [BITWIDTH - 1:0] oCnt0;
    reg [BITWIDTH - 1:0] oCnt1;
    wire [BITWIDTH - 1:0] oCnt_plus_1;
    
    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oCnt0 <= 0;
            oCnt1 <= 0;
        end else begin
            if(iClr) begin
                oCnt0 <= 0;
                oCnt1 <= 0;
            end else begin   
                if(iSel) begin
                    oCnt0 <= oCnt0;
                    oCnt1 <= oCnt_plus_1;
                end else begin
                    oCnt0 <= oCnt_plus_1;
                    oCnt1 <= oCnt1;
                end     
            end
        end
    end
    
    assign oCnt_plus_1 = oCnt + 1;
    assign oCnt = ((iSel) ? oCnt1 : oCnt0);


endmodule

`endif













