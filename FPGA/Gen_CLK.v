module Gen_CLK(
CLOCK_50,
RESET_N,
REFCLK,
refSCLK
);

input CLOCK_50;
input RESET_N;
output REFCLK;
output refSCLK;

reg CLKreg;
reg [11:0]count;

always@( posedge CLOCK_50 or negedge RESET_N)begin	
	if ( RESET_N == 1'b0)begin
		CLKreg <= 1'b0;
		count <= 12'b0;
	end else begin
	if (count == 12'd1000) begin
		count <= 12'b0;
		CLKreg <= ~CLKreg;
	end else begin
		count <= count + 1'b1;
	end
	end
end

assign refSCLK = REFCLK;
assign REFCLK = CLKreg;

endmodule