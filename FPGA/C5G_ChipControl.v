// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

module C5G_ChipControl
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	CLOCK_50_B5B,
	CLOCK_50_B6A,
	CLOCK_50_B7A,
	CLOCK_50_B8A,
//	CLOCK_125_p,

	SW,

	RF,

	DIO,
	
	LEDR,

	SYNC,
	SCLK,

	S1MOSI,
	S2MOSI,
	S3MOSI,
	S4MOSI,
	S5MOSI,
	S6MOSI,
	S7MOSI,
	S8MOSI,
	S9MOSI,
	S10MOSI,
	S11MOSI,
	S12MOSI,
	
	readfromusb,
   sendtousb,
 
   address,
   WE,
   CE,
   OE,
   LB,
   UB,
   data,
	KEY,
	

// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
input			CLOCK_50_B5B;
inout			CLOCK_50_B6A;
input			CLOCK_50_B7A;
input			CLOCK_50_B8A;
//input			CLOCK_125_p;

input readfromusb;
output sendtousb;
output [17:0]address;
output WE;
output CE;
output OE;
output LB;
output UB;
output [9:0]LEDR;

input [3:0]KEY;

inout [15:0]data;



inout	[1:12] RF;

inout	[0:9] SW;

inout	[1:4]	DIO;

output			SYNC;
output			SCLK;

output	[1:8]	S1MOSI;
output	[1:8]	S2MOSI;
output	[1:8]	S3MOSI;
output	[1:8]	S4MOSI;
output	[1:8]	S5MOSI;
output	[1:8]	S6MOSI;
output	[1:8]	S7MOSI;
output	[1:8]	S8MOSI;
output	[1:8]	S9MOSI;
output	[1:8]	S10MOSI;
output	[1:8]	S11MOSI;
output	[1:8]	S12MOSI;

wire locked;
wire [0:5]c;
wire [63:0]reconfig_to_pll;
wire [63:0]reconfig_from_pll;
wire [31:0]mgmt_readdata;
wire mgmt_read;
wire mgmt_write;
wire [31:0]mgmt_writedata;
wire [0:767]nmbr;
wire [5:0]mgmt_address;
wire mgmt_reset;
wire mgmt_waitrequest;
wire reset;
wire [7:0]div0;
wire [7:0]div1;
wire [7:0]div2;
wire [7:0]div3;
wire [7:0]div4;
wire [7:0]div5;

wire [7:0]phase_delay0;
wire [7:0]phase_delay1;
wire [7:0]phase_delay2;
wire [7:0]phase_delay3;
wire [7:0]phase_delay4;
wire [7:0]phase_delay5;


assign reset = ~KEY[3];

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!


//=======================================================
//  Structural coding
//=======================================================

// Clock Generator
Gen_CLK Gen_CLK_inst(
	.CLOCK_50( CLOCK_50_B5B),
	.RESET_N( SW[1]),
	.REFCLK( DIO[1]),
	.refSCLK( SCLK)
	);


	


triggerupdate triggerupdate_inst(
   .CLOCK_50_B5B(CLOCK_50_B5B),

   .data(data[15:0]),
   .readfromusb(readfromusb),
   .sendtousb(sendtousb),
   .address(address[17:0]),
   .WE(WE),
   .CE(CE),
   .OE(OE),
   .LB(LB),
   .UB(UB),
	
	.DIO(DIO[1:4]),
	.KEY(KEY[3:0]),
	.LEDR(LEDR[9:0]),
	.div0(div0),
	.div1(div1),
	.div2(div2),
	.div3(div3),
	.div4(div4),
	.div5(div5),
	
	.phase_delay0(phase_delay0),
	.phase_delay1(phase_delay1),
	.phase_delay2(phase_delay2),
	.phase_delay3(phase_delay3),
	.phase_delay4(phase_delay4),
	.phase_delay5(phase_delay5),
	
//	.locked(locked),
//   .mgmt_waitrequest(mgmt_waitrequest),
//   .mgmt_readdata(mgmt_readdata[31:0]),
//   .mgmt_writedata(mgmt_writedata[31:0]),
//   .mgmt_read(mgmt_read),
//   .mgmt_write(mgmt_write),
//   .mgmt_address(mgmt_address[5:0]),
   .nmbr(nmbr[0:767])
);


RF_gen RF_gen_inst(
   .refclk( CLOCK_50_B5B),
	.outclk_0(c[0]),
	.outclk_1(c[1]),
	.outclk_2(c[2]),
	.outclk_3(c[3]),
	.outclk_4(c[4]),
	.outclk_5(c[5]),
	.div0(div0),
	.div1(div1),
	.div2(div2),
	.div3(div3),
	.div4(div4),
	.div5(div5),
	
	.phase_delay0(phase_delay0),
	.phase_delay1(phase_delay1),
	.phase_delay2(phase_delay2),
	.phase_delay3(phase_delay3),
	.phase_delay4(phase_delay4),
	.phase_delay5(phase_delay5),
	.reset(reset),
);
	// RF Sig Generator
//pll	b2v_inst(
//	.refclk( CLOCK_50_B5B),
//	.outclk_0(c[0]),
//	.outclk_1(c[1]),
//	.outclk_2(c[2]),
//	.outclk_3(c[3]),
//	.outclk_4(c[4]),
//	.outclk_5(c[5]),
//	.reconfig_to_pll(reconfig_to_pll),
//	.reconfig_from_pll(reconfig_from_pll),
//	.locked(locked),
//	.rst(reset)
//	);	

	
	
//pll_reconfig pll_reconfig_inst(
//      .mgmt_clk(CLOCK_50_B5B),
//		.mgmt_waitrequest(mgmt_waitrequest),
//      .mgmt_reset(mgmt_reset),		
//		.mgmt_readdata(mgmt_readdata),      
//		.mgmt_read(mgmt_read),        
//		.mgmt_write(mgmt_write),        
//		.mgmt_address(mgmt_address),      
//		.mgmt_writedata(mgmt_writedata),   
//		.reconfig_to_pll(reconfig_to_pll),   
//		.reconfig_from_pll(reconfig_from_pll)  
//	);
	//Mode Selector
ModeSelect ModeSelect_inst(
	.refclk( CLOCK_50_B5B),
	.RESET_N( SW[1]),
	.MODE( SW[2]),
	.C0( c),
	.RFout( RF[1:12]),
);	
	
 //DAC control Slot1
CTRL_DAC CTRL_DAC_inst(
	.SCLK( SCLK),
	.RESET_N (SW[1] ),
	.SYNC( SYNC),
	.ACTIVE_N( SW[2]),
	.SDIN1 ( S1MOSI[1:8]),
	.SDIN2 ( S2MOSI[1:8]),	
	.SDIN3 ( S3MOSI[1:8]),
	.SDIN4 ( S4MOSI[1:8]),	
	.SDIN5 ( S5MOSI[1:8]),
	.SDIN6 ( S6MOSI[1:8]),
	.SDIN7 ( S7MOSI[1:8]),
	.SDIN8 ( S8MOSI[1:8]),
	.SDIN9 ( S9MOSI[1:8]),	
	.SDIN10 ( S10MOSI[1:8]),	
	.SDIN11 ( S11MOSI[1:8]),	
	.SDIN12 ( S12MOSI[1:8]),
   .nmbr(nmbr[0:767])	
	);

endmodule