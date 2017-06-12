module CTRL_DAC(
	SCLK,
	RESET_N,
	ACTIVE_N,
	SDIN1,
	SDIN2,
	SDIN3,
	SDIN4,
	SDIN5,
	SDIN6,
	SDIN7,
	SDIN8,
	SDIN9,
	SDIN10,
	SDIN11,
	SDIN12,
	SYNC,
	nmbr,
);

input SCLK;
input RESET_N;
input ACTIVE_N;
input [0:767]nmbr;
output [0:7]SDIN1;
output [0:7]SDIN2;
output [0:7]SDIN3;
output [0:7]SDIN4;
output [0:7]SDIN5;
output [0:7]SDIN6;
output [0:7]SDIN7;
output [0:7]SDIN8;
output [0:7]SDIN9;
output [0:7]SDIN10;
output [0:7]SDIN11;
output [0:7]SDIN12;
output SYNC;


reg SYNC;
reg [0:7]SDIN1;
reg [0:7]SDIN2;
reg [0:7]SDIN3;
reg [0:7]SDIN4;
reg [0:7]SDIN5;
reg [0:7]SDIN6;
reg [0:7]SDIN7;
reg [0:7]SDIN8;
reg [0:7]SDIN9;
reg [0:7]SDIN10;
reg [0:7]SDIN11;
reg [0:7]SDIN12;
reg [0:4]state;


integer i;

	always@(posedge SCLK) begin
		if(ACTIVE_N ==1'b1) begin

		if( RESET_N == 1'b0)begin
			state <= 5'b00000;
			SDIN1  <= 3'b000;
			SDIN2  <= 3'b000;
			SDIN3  <= 3'b000;
			SDIN4  <= 3'b000;
			SDIN5  <= 3'b000;
			SDIN6  <= 3'b000;
			SDIN7  <= 3'b000;
			SDIN8  <= 3'b000;
			SDIN9  <= 3'b000;
			SDIN10  <= 3'b000;
			SDIN11  <= 3'b000;
			SDIN12  <= 3'b000;
			SYNC <= 1'b1;
		end else begin
			case( state)
			5'b00000:begin // transfer start bit power down mode (PD1)
				state <= 5'b00001;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;				
				SYNC <= 1'b0;
			end
			5'b00001: begin // transfer start bit power down mode (PD0)
				state <= 5'b00010;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b00010:begin
				state <= 5'b00011;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96];
				SDIN2[i] <= nmbr[i*96+8];
				SDIN3[i] <= nmbr[i*96+2*8];
				SDIN4[i] <= nmbr[i*96+3*8];
				SDIN5[i] <= nmbr[i*96+4*8];
				SDIN6[i] <= nmbr[i*96+5*8];
				SDIN7[i] <= nmbr[i*96+6*8];
				SDIN8[i] <= nmbr[i*96+7*8];
				SDIN9[i] <= nmbr[i*96+8*8];
				SDIN10[i] <= nmbr[i*96+9*8];
				SDIN11[i] <= nmbr[i*96+10*8];
				SDIN12[i] <= nmbr[i*96+11*8];
				end
				
			end
			5'b00011:begin
				state <= 5'b00100;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+1];
				SDIN2[i] <= nmbr[i*96+8+1];
				SDIN3[i] <= nmbr[i*96+2*8+1];
				SDIN4[i] <= nmbr[i*96+3*8+1];
				SDIN5[i] <= nmbr[i*96+4*8+1];
				SDIN6[i] <= nmbr[i*96+5*8+1];
				SDIN7[i] <= nmbr[i*96+6*8+1];
				SDIN8[i] <= nmbr[i*96+7*8+1];
				SDIN9[i] <= nmbr[i*96+8*8+1];
				SDIN10[i] <= nmbr[i*96+9*8+1];
				SDIN11[i] <= nmbr[i*96+10*8+1];
				SDIN12[i] <= nmbr[i*96+11*8+1];
				end
			end
			5'b00100:begin // transfer start bit
				state <= 5'b00101;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+2];
				SDIN2[i] <= nmbr[i*96+8+2];
				SDIN3[i] <= nmbr[i*96+2*8+2];
				SDIN4[i] <= nmbr[i*96+3*8+2];
				SDIN5[i] <= nmbr[i*96+4*8+2];
				SDIN6[i] <= nmbr[i*96+5*8+2];
				SDIN7[i] <= nmbr[i*96+6*8+2];
				SDIN8[i] <= nmbr[i*96+7*8+2];
				SDIN9[i] <= nmbr[i*96+8*8+2];
				SDIN10[i] <= nmbr[i*96+9*8+2];
				SDIN11[i] <= nmbr[i*96+10*8+2];
				SDIN12[i] <= nmbr[i*96+11*8+2];
				end
				end
			5'b00101:begin // transfer start bit
				state <= 5'b00110;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+3];
				SDIN2[i] <= nmbr[i*96+8+3];
				SDIN3[i] <= nmbr[i*96+2*8+3];
				SDIN4[i] <= nmbr[i*96+3*8+3];
				SDIN5[i] <= nmbr[i*96+4*8+3];
				SDIN6[i] <= nmbr[i*96+5*8+3];
				SDIN7[i] <= nmbr[i*96+6*8+3];
				SDIN8[i] <= nmbr[i*96+7*8+3];
				SDIN9[i] <= nmbr[i*96+8*8+3];
				SDIN10[i] <= nmbr[i*96+9*8+3];
				SDIN11[i] <= nmbr[i*96+10*8+3];
				SDIN12[i] <= nmbr[i*96+11*8+3];
				end
				end
			5'b00110:begin // transfer start bit
				state <= 5'b00111;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+4];
				SDIN2[i] <= nmbr[i*96+8+4];
				SDIN3[i] <= nmbr[i*96+2*8+4];
				SDIN4[i] <= nmbr[i*96+3*8+4];
				SDIN5[i] <= nmbr[i*96+4*8+4];
				SDIN6[i] <= nmbr[i*96+5*8+4];
				SDIN7[i] <= nmbr[i*96+6*8+4];
				SDIN8[i] <= nmbr[i*96+7*8+4];
				SDIN9[i] <= nmbr[i*96+8*8+4];
				SDIN10[i] <= nmbr[i*96+9*8+4];
				SDIN11[i] <= nmbr[i*96+10*8+4];
				SDIN12[i] <= nmbr[i*96+11*8+4];
				end
			end
			5'b00111:begin // transfer start bit
				state <= 5'b01000;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+5];
				SDIN2[i] <= nmbr[i*96+8+5];
				SDIN3[i] <= nmbr[i*96+2*8+5];
				SDIN4[i] <= nmbr[i*96+3*8+5];
				SDIN5[i] <= nmbr[i*96+4*8+5];
				SDIN6[i] <= nmbr[i*96+5*8+5];
				SDIN7[i] <= nmbr[i*96+6*8+5];
				SDIN8[i] <= nmbr[i*96+7*8+5];
				SDIN9[i] <= nmbr[i*96+8*8+5];
				SDIN10[i] <= nmbr[i*96+9*8+5];
				SDIN11[i] <= nmbr[i*96+10*8+5];
				SDIN12[i] <= nmbr[i*96+11*8+5];
				end
			end
			5'b01000:begin // transfer start bit
				state <= 5'b01001;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+6];
				SDIN2[i] <= nmbr[i*96+8+6];
				SDIN3[i] <= nmbr[i*96+2*8+6];
				SDIN4[i] <= nmbr[i*96+3*8+6];
				SDIN5[i] <= nmbr[i*96+4*8+6];
				SDIN6[i] <= nmbr[i*96+5*8+6];
				SDIN7[i] <= nmbr[i*96+6*8+6];
				SDIN8[i] <= nmbr[i*96+7*8+6];
				SDIN9[i] <= nmbr[i*96+8*8+6];
				SDIN10[i] <= nmbr[i*96+9*8+6];
				SDIN11[i] <= nmbr[i*96+10*8+6];
				SDIN12[i] <= nmbr[i*96+11*8+6];
				end
				end
			5'b01001:begin // transfer start bit
				state <= 5'b01010;
				for (i = 0;i < 8;i = i + 1)begin
				SDIN1[i] <= nmbr[i*96+7];
				SDIN2[i] <= nmbr[i*96+8+7];
				SDIN3[i] <= nmbr[i*96+2*8+7];
				SDIN4[i] <= nmbr[i*96+3*8+7];
				SDIN5[i] <= nmbr[i*96+4*8+7];
				SDIN6[i] <= nmbr[i*96+5*8+7];
				SDIN7[i] <= nmbr[i*96+6*8+7];
				SDIN8[i] <= nmbr[i*96+7*8+7];
				SDIN9[i] <= nmbr[i*96+8*8+7];
				SDIN10[i] <= nmbr[i*96+9*8+7];
				SDIN11[i] <= nmbr[i*96+10*8+7];
				SDIN12[i] <= nmbr[i*96+11*8+7];
				end
			end
			5'b01010:begin
				state <= 5'b01011;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b01011:begin
				state <= 5'b01100;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b01100:begin
				state <= 5'b01101;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end		
			5'b01101:begin // transfer bit
				state <= 5'b01110;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b01110:begin // transfer bit
				state <= 5'b01111;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b01111:begin // transfer Bit
				state <= 5'b10000;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			end
			5'b10000:begin
				state <= 5'b00000;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
			SYNC <= 1'b1;
			end
			default:begin
				state <= 5'b00000;
				SDIN1  <= 3'b000;
				SDIN2  <= 3'b000;
				SDIN3  <= 3'b000;
				SDIN4  <= 3'b000;
				SDIN5  <= 3'b000;
				SDIN6  <= 3'b000;
				SDIN7  <= 3'b000;
				SDIN8  <= 3'b000;
				SDIN9  <= 3'b000;
				SDIN10  <= 3'b000;
				SDIN11  <= 3'b000;
				SDIN12  <= 3'b000;
				SYNC <= 1'b1;
			end
			endcase
		end
		end

	end
	
endmodule