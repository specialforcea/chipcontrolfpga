module ModeSelect(
refclk,
RESET_N,
MODE,
C0,
RFout
);

input refclk;
input MODE;
input RESET_N;
input [0:5]C0;
output [1:12]RFout;

wire [1:12]RFout;

wire [0:5]Clk6;

assign Clk6=refclk & refclk & refclk & refclk & refclk & refclk;

assign RFout[1:6] = (MODE) ? C0[0:5] : Clk6;
assign RFout[7:12] = (MODE) ? C0[0:5] : Clk6;

endmodule