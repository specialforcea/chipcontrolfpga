module triggerupdate
(

CLOCK_50_B5B,

readfromusb,
sendtousb,

data,


address,
WE,
CE,
OE,
LB,
UB,
LEDR,

KEY,
div0,
div1,
div2,
div3,
div4,
div5,
	
phase_delay0,
phase_delay1,
phase_delay2,
phase_delay3,
phase_delay4,
phase_delay5, 

nmbr,

DIO,

);


input CLOCK_50_B5B;

inout  [15:0]data;
input readfromusb;
input [3:0]KEY;
input	[1:4]	DIO;


output sendtousb;
output [17:0]address;
output WE;
output CE;
output OE;
output LB;
output UB;
output [767:0]nmbr;
output [7:0]div0;
output [7:0]div1;
output [7:0]div2;
output [7:0]div3;
output [7:0]div4;
output [7:0]div5;

output [7:0]phase_delay0;
output [7:0]phase_delay1;
output [7:0]phase_delay2;
output [7:0]phase_delay3;
output [7:0]phase_delay4;
output [7:0]phase_delay5;



output [9:0]LEDR;


reg [17:0]address;
reg [17:0]addresspre;
initial addresspre = 18'b000000000000000000;
reg [17:0]addressfinal;
initial addressfinal = 18'b000000000000000000;
reg [5:0]state;
reg [4:0]readstate;

reg [2:0]upstate;

reg [9:0]LEDR = 0;

reg [7:0]datapre;
reg [15:0]prestoreram;
integer datagroupnum = 0;
integer cyclenum =0;

reg [7:0]div0;
reg [7:0]div1;
reg [7:0]div2;
reg [7:0]div3;
reg [7:0]div4;
reg [7:0]div5;

reg [7:0]phase_delay0;
reg [7:0]phase_delay1;
reg [7:0]phase_delay2;
reg [7:0]phase_delay3;
reg [7:0]phase_delay4;
reg [7:0]phase_delay5;


reg WE;
reg CE;
reg OE;
reg LB;
reg UB;
reg [767:0]nmbr = 0;


reg up = 0;

reg show = 0;
reg auxup = 0;

reg [12:0]clockdiv=13'b0000000000000;
reg [6:0]clockdiv1 = 7'b0000000;
reg [6:0]clockdiv2 = 7'b0000000;

reg addone = 0;
reg addonew = 0;
reg addoner = 0;

reg [3:0]status = 0;
reg [7:0]receive = 0;
reg [7:0]bytetocorrect = 0;
reg [7:0]correctingbyte = 0;
reg transferring = 0;
reg readingfinal = 0;

//status map: 0000:standby
//            0001:receiving writing data number[1]
//            0010:receiving writing data number[2]
//				  0011:receiving writing data
//				  0100:receiving reading data number[1]
//            0101:receiving reading data number[2]
//				  0110:reading data
//				  0111:receiving correcting data number
//				  1000:receiving correcting data address[1]
//            1001:receiving correcting data address[2]
//            1010:receiving correcting data

wire readfromusb;
reg sendtousb;

wire CLOCK_50_B5B;





assign data[0] = (show == 0 && up == 0) ? datapre[0]:1'bz;
assign data[1] = (show == 0 && up == 0) ? datapre[1]:1'bz;
assign data[2] = (show == 0 && up == 0) ? datapre[2]:1'bz;
assign data[3] = (show == 0 && up == 0) ? datapre[3]:1'bz;
assign data[4] = (show == 0 && up == 0) ? datapre[4]:1'bz;
assign data[5] = (show == 0 && up == 0) ? datapre[5]:1'bz;
assign data[6] = (show == 0 && up == 0) ? datapre[6]:1'bz;
assign data[7] = (show == 0 && up == 0) ? datapre[7]:1'bz;

always @(posedge CLOCK_50_B5B)
begin

    if (clockdiv == 5208)
	 begin
	     clockdiv <= 0;
		  end
	 else begin
	     clockdiv <= clockdiv + 1;
		  end
end








wire refclk = (clockdiv == 0);








always @(posedge CLOCK_50_B5B)
begin
   case (state)
        5'b000000: if (refclk && readfromusb == 0)state <= 6'b000001; // Start bit
        6'b000001: if (refclk) state <= 6'b000010;                    // Bit 0
        6'b000010: if (refclk) state <= 6'b000011;                    // Bit 1
        6'b000011: if (refclk) state <= 6'b000100;                    // Bit 2
        6'b000100: if (refclk) state <= 6'b000101;                    // Bit 3
        6'b000101: if (refclk) state <= 6'b000110;                    // Bit 4
        6'b000110: if (refclk) state <= 6'b000111;                    // Bit 6
        6'b000111: if (refclk) state <= 6'b001000;                    // Bit 6
        6'b001000: if (refclk) state <= 6'b001001;                    // Bit 7
        6'b001001: if (refclk) state <= 6'b001010;                    // Stop bit
		  6'b001010: if (refclk) state <= 6'b001011;    //Start bit
		  6'b001011: if (refclk) state <= 6'b001100;
		  6'b001100: if (refclk) state <= 6'b001101;
		  6'b001101: if (refclk) state <= 6'b001110;
		  6'b001110: if (refclk) state <= 6'b001111;
		  6'b001111: if (refclk) state <= 6'b010000;
		  6'b010000: if (refclk) state <= 6'b010001;
		  6'b010001: if (refclk) state <= 6'b010010;
		  6'b010010: if (refclk) state <= 6'b010011;
		  6'b010011: if (refclk) state <= 6'b010100;
		  6'b010100: if (refclk) state <= 6'b000000;   //Start bit
		  6'b010101: if (refclk) state <= 6'b010110;
		  6'b010110: if (refclk) state <= 6'b010111;	
		  6'b010111: if (refclk) state <= 6'b011000;   
        6'b011000: if (refclk) state <= 6'b011001;    
        6'b011001: if (refclk) state <= 6'b011010;    
		  6'b011010: if (refclk) state <= 6'b011011;    
		  6'b011011: if (refclk) state <= 6'b011100;
		  6'b011100: if (refclk) state <= 6'b011101;
		  6'b011101: if (refclk) state <= 6'b011110;
		  6'b011110: if (refclk) state <= 6'b011111;
		  6'b011111: if (refclk) state <= 6'b100000;
		  6'b100000: if (refclk) state <= 6'b000000;
//		  6'b100001: if (refclk) state <= 6'b100010;
//		  6'b100010: if (refclk) state <= 6'b100011;
//		  6'b100011: if (refclk) state <= 6'b100100;
//		  6'b100100: if (refclk) state <= 6'b100101;
//		  6'b100101: if (refclk) state <= 6'b100110;
//		  6'b100110: if (refclk) state <= 6'b100111;	
//		  6'b100111: if (refclk) state <= 6'b101000;    // Bit 6
//      6'b101000: if (refclk) state <= 6'b101001;    // Bit 7
//      6'b101001: if (refclk) state <= 6'b101010;    // Stop bit
//		  6'b101010: if (refclk) state <= 6'b101011;    //operation
//		  6'b101011: if (refclk) state <= 6'b101100;
//		  6'b101100: if (refclk) state <= 6'b101101;
//		  6'b101101: if (refclk) state <= 6'b101110;
//		  6'b101110: if (refclk) state <= 6'b101111;
//		  6'b101111: if (refclk) state <= 6'b000000;
        default: state <= 6'b000000;                  
    endcase
end

always @(posedge CLOCK_50_B5B)
begin 

case(status)
		4'b0000:begin //standby
	case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= receive[7];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   
											  transferring <= 0; end// Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     if(transferring== 0)begin status <= receive[3:0]; transferring <= 1;end
											end  
											
			 
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0001:begin //receiving writing data number[1]
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   
											  addressfinal[7:0] <= receive;
											  transferring <= 0;
											  end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring== 0)begin status <= 4'b0010; transferring <= 1; end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0010:begin //receiving writing data number[2]
		 case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											 transferring <= 0;
											addressfinal[15:8] <= receive; end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring==0)begin status <= 4'b0011; transferring <= 1;end
											  addresspre <= 0;
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0011:begin //0011:receiving writing data
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  datapre[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  datapre[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  datapre[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  datapre[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  datapre[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  datapre[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  datapre[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  datapre[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 0;								          
	                            WE <= 0;
											  OE <= 1;							          
	                                LB <= 0;
	                                UB <= 1;
										 sendtousb <= 0; 
									    address <= addresspre;	 end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  addonew <= 0;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
			                          if (addonew == 0) begin addresspre <= addresspre + 1;addonew <= 1;end
											  
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											 transferring<= 0; end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     if (addresspre == addressfinal && transferring == 0)begin  status <= 0;  transferring <= 1; cyclenum <= 0;datagroupnum <= 0;end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0100:begin //0100:receiving reading data number[1]
		 
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											transferring <= 0; 
										addressfinal[7:0] <= receive;	end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring==0)begin status <= 4'b101; transferring <= 1;end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0101:begin //0101:receiving reading data number[2]
		 
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 1;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											  addressfinal[15:8] <= receive;
											  transferring<= 0;
											  end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring == 0)begin status <= 4'b0110; addresspre <= 0; show <= 1; end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0110:begin //0110:reading data
		 
		case (readstate)
	
         5'b00000:   begin 
						                 sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end                       // Start bit
         5'b00001:  begin 
			               sendtousb <= 1;
			               WE <= 1;
	                     CE <= 0;
								OE <= 0;
	                     LB <= 0;
	                     UB <= 1;
								prestoreram[0] <= data[0];
								prestoreram[1] <= data[1];
								prestoreram[2] <= data[2];
								prestoreram[3] <= data[3];
								prestoreram[4] <= data[4];
								prestoreram[5] <= data[5];
								prestoreram[6] <= data[6];
								prestoreram[7] <= data[7];
								address[0] <= addresspre[0];
								address[1] <= addresspre[1];
								address[2] <= addresspre[2];
								address[3] <= addresspre[3];
								address[4] <= addresspre[4];
								address[5] <= addresspre[5];
								address[6] <= addresspre[6];
								address[7] <= addresspre[7];
								address[8] <= addresspre[8];
								address[9] <= addresspre[9];
								address[10] <= addresspre[10];
								address[11] <= addresspre[11];
								address[12] <= addresspre[12];
								address[13] <= addresspre[13];
								address[14] <= addresspre[14];
								address[15] <= addresspre[15];
								address[16] <= addresspre[16];
								address[17] <= addresspre[17];
						   end			  
         5'b00010:  begin 	     CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										     sendtousb <= 0; 
										 end    
         5'b00011:  begin  sendtousb <= prestoreram[0];
			                
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b00100:  begin  sendtousb <= prestoreram[1];
			                 
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b00101:  begin sendtousb <= prestoreram[2];
			                
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b00110:  begin sendtousb <= prestoreram[3];
			                 
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b00111:  begin sendtousb <= prestoreram[4];
			                 
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b01000:  begin  sendtousb <= prestoreram[5];
			                 
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end   
         5'b01001:  begin  sendtousb <= prestoreram[6];
			                
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end                         
	

			5'b01010:  begin  sendtousb <= prestoreram[7];
			                 
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end       
		
		
			5'b01011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											  addoner <= 0;// Stop bit 	
											  
									   end
         5'b01100:  begin sendtousb <= 1;
			                          if (addoner == 0 ) begin addresspre <= addresspre + 1;addoner <= 1;end
											  
											  CE <= 1;		WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end 
         
         5'b01101:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											  if(addresspre == addressfinal)begin status <= 4'b0000; addresspre <= 0; show <= 0; transferring <= 1;cyclenum <= 0;datagroupnum <= 0;end
											  
											  
											  end
											   
			
         
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b0111:begin //0111:receiving correcting data number
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											 transferring <= 0; 
											 bytetocorrect <= receive;
											 correctingbyte <= 0;end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring == 0) begin status <= 4'b1000; transferring <= 1; end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b1000:begin //1000:receiving correcting data address[1]
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   
											  addresspre[7:0] <= receive;
											  transferring <= 0;end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring == 0) begin status <= 4'b1001; transferring <= 1; end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		 
		4'b1001:begin //1001:receiving correcting data address[2]
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  receive[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  receive[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  receive[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  receive[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  receive[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  receive[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  receive[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  receive[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 1;								          
	                            WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   
											  addresspre[15:8] <= receive;
											  transferring <= 0;end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(transferring == 0)begin status <= 4'b1010; transferring <= 1;end
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		4'b1010:begin //1010:receiving correcting data
		case (state)
	
         6'b000000:   begin sendtousb <= 1;
	                                CE <= 1;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  WE <= 1'bZ;
											  OE <= 1'bZ; 
									   end                         // Start bit
         6'b000001:  begin sendtousb <= 1;  datapre[0] <= readfromusb; CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;								          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
											 // writing <= 0;
											  
								           end			  // Bit 0
         6'b000010:  begin sendtousb <= 1;  datapre[1] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 1
         6'b000011:  begin sendtousb <= 1;  datapre[2] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 2
         6'b000100:  begin sendtousb <= 1;  datapre[3] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 3
         6'b000101:  begin sendtousb <= 1;  datapre[4] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 4
         6'b000110:  begin sendtousb <= 1;  datapre[5] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end    // Bit 5
         6'b000111:  begin sendtousb <= 1;  datapre[6] <= readfromusb;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end    // Bit 6
         6'b001000:  begin sendtousb <= 1;  datapre[7] <= readfromusb;   CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											   end    // Bit 7
         6'b001001:  begin sendtousb <= 1;  CE <= 1;WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end                         // Stop bit 
	

			6'b001010:begin 	    CE <= 0;								          
	                            WE <= 0;
											  OE <= 1;							          
	                                LB <= 0;
	                                UB <= 1;
										 sendtousb <= 0; 
									    address <= addresspre;	 end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= status[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  addonew <= 0;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= status[1];
			                          if (addonew == 0) begin correctingbyte <= correctingbyte + 1;addonew <= 1;end
											  
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= status[2];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= status[3];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 3
         6'b001111:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 4
         6'b010000:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end // Bit 5
         6'b010001:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end // Bit 6
         6'b010010:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end  // Bit 7
         6'b010011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   
											  transferring <= 0;end
											   // Stop bit 	
			 6'b010100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     if (correctingbyte == bytetocorrect && transferring == 0)begin  status <= 0; transferring <= 1; cyclenum <= 0;datagroupnum <= 0;end
											  if (correctingbyte < bytetocorrect && transferring == 0)begin status <= 4'b1000;transferring <= 1;end 
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		 default:status <= 0;
		 
		 
	 endcase
	 
	 
	
	 
	 


    
    
	 

			
			
	 
	 if(DIO[2] == 1) begin
	      auxup <= 1;
			end
			
	 if (auxup == 1 && DIO[2] == 0) begin
	     up <= 1;
		  auxup <= 0;
		  end

		  

//		  
	 
	 
		  
	 if (up == 1)begin
	 case (upstate)
	 
	      3'b000:begin
			       CE <= 1;								          
	             WE <= 1'bZ;
				    OE <= 1'bZ;							          
	             LB <= 1'bZ;
	             UB <= 1'bZ;
					 addresspre <= cyclenum * 108 + datagroupnum;
					 end
					 
			3'b001:begin
	              WE <= 1;
	              CE <= 0;
	              OE <= 0;
	              LB <= 0;
	              UB <= 1;
	                     address[0] <= addresspre[0];
								address[1] <= addresspre[1];
								address[2] <= addresspre[2];
								address[3] <= addresspre[3];
								address[4] <= addresspre[4];
								address[5] <= addresspre[5];
								address[6] <= addresspre[6];
								address[7] <= addresspre[7];
								address[8] <= addresspre[8];
								address[9] <= addresspre[9];
								address[10] <= addresspre[10];
								address[11] <= addresspre[11];
								address[12] <= addresspre[12];
								address[13] <= addresspre[13];
								address[14] <= addresspre[14];
								address[15] <= addresspre[15];
								address[16] <= addresspre[16];
								address[17] <= addresspre[17];
	 if (datagroupnum == 0) begin
	 div0[0] <= data[0];
	 div0[1] <= data[1];
	 div0[2] <= data[2];
	 div0[3] <= data[3];
	 div0[4] <= data[4];
	 div0[5] <= data[5];
	 div0[6] <= data[6];
	 div0[7] <= data[7];

	 end
	 if (datagroupnum == 1) begin
	 div1[0] <= data[0];
	 div1[1] <= data[1];
	 div1[2] <= data[2];
	 div1[3] <= data[3];
	 div1[4] <= data[4];
	 div1[5] <= data[5];
	 div1[6] <= data[6];
	 div1[7] <= data[7];
	 end
	 if (datagroupnum == 2) begin
	 div2[0] <= data[0];
	 div2[1] <= data[1];
	 div2[2] <= data[2];
	 div2[3] <= data[3];
	 div2[4] <= data[4];
	 div2[5] <= data[5];
	 div2[6] <= data[6];
	 div2[7] <= data[7];
	 end
	 if (datagroupnum == 3) begin
	 div3[0] <= data[0];
	 div3[1] <= data[1];
	 div3[2] <= data[2];
	 div3[3] <= data[3];
	 div3[4] <= data[4];
	 div3[5] <= data[5];
	 div3[6] <= data[6];
	 div3[7] <= data[7];
	 end
	 if (datagroupnum == 4) begin
	 div4[0] <= data[0];
	 div4[1] <= data[1];
	 div4[2] <= data[2];
	 div4[3] <= data[3];
	 div4[4] <= data[4];
	 div4[5] <= data[5];
	 div4[6] <= data[6];
	 div4[7] <= data[7];
	 end
	 if (datagroupnum == 5) begin
	 div5[0] <= data[0];
	 div5[1] <= data[1];
	 div5[2] <= data[2];
	 div5[3] <= data[3];
	 div5[4] <= data[4];
	 div5[5] <= data[5];
	 div5[6] <= data[6];
	 div5[7] <= data[7];
	 end
	 if (datagroupnum == 6) begin
	 phase_delay0[0] <= data[0];
	 phase_delay0[1] <= data[1];
	 phase_delay0[2] <= data[2];
	 phase_delay0[3] <= data[3];
	 phase_delay0[4] <= data[4];
	 phase_delay0[5] <= data[5];
	 phase_delay0[6] <= data[6];
	 phase_delay0[7] <= data[7];
	 end
	 if (datagroupnum == 7) begin
	 phase_delay1[0] <= data[0];
	 phase_delay1[1] <= data[1];
	 phase_delay1[2] <= data[2];
	 phase_delay1[3] <= data[3];
	 phase_delay1[4] <= data[4];
	 phase_delay1[5] <= data[5];
	 phase_delay1[6] <= data[6];
	 phase_delay1[7] <= data[7];
	 end
	 if (datagroupnum == 8) begin
	 phase_delay2[0] <= data[0];
	 phase_delay2[1] <= data[1];
	 phase_delay2[2] <= data[2];
	 phase_delay2[3] <= data[3];
	 phase_delay2[4] <= data[4];
	 phase_delay2[5] <= data[5];
	 phase_delay2[6] <= data[6];
	 phase_delay2[7] <= data[7];
	 end
	 if (datagroupnum == 9) begin
	 phase_delay3[0] <= data[0];
	 phase_delay3[1] <= data[1];
	 phase_delay3[2] <= data[2];
	 phase_delay3[3] <= data[3];
	 phase_delay3[4] <= data[4];
	 phase_delay3[5] <= data[5];
	 phase_delay3[6] <= data[6];
	 phase_delay3[7] <= data[7];
	 end
	 if (datagroupnum == 10) begin
	 phase_delay4[0] <= data[0];
	 phase_delay4[1] <= data[1];
	 phase_delay4[2] <= data[2];
	 phase_delay4[3] <= data[3];
	 phase_delay4[4] <= data[4];
	 phase_delay4[5] <= data[5];
	 phase_delay4[6] <= data[6];
	 phase_delay4[7] <= data[7];
	 end
	 if (datagroupnum == 11) begin
	 phase_delay5[0] <= data[0];
	 phase_delay5[1] <= data[1];
	 phase_delay5[2] <= data[2];
	 phase_delay5[3] <= data[3];
	 phase_delay5[4] <= data[4];
	 phase_delay5[5] <= data[5];
	 phase_delay5[6] <= data[6];
	 phase_delay5[7] <= data[7];
	 end
	
	 if (datagroupnum > 11 ) begin
	 nmbr[(datagroupnum-12)*8+0] <= data[0];
	 nmbr[(datagroupnum-12)*8+1] <= data[1];
	 nmbr[(datagroupnum-12)*8+2] <= data[2];
	 nmbr[(datagroupnum-12)*8+3] <= data[3];
	 nmbr[(datagroupnum-12)*8+4] <= data[4];
	 nmbr[(datagroupnum-12)*8+5] <= data[5];
	 nmbr[(datagroupnum-12)*8+6] <= data[6];
	 nmbr[(datagroupnum-12)*8+7] <= data[7];
	 
	 LEDR[0] <= 1;
	 
	 end
    addone <= 0;
	 end
	 3'b010:begin
	      CE <= 1;								          
	      WE <= 1'bZ;
		   OE <= 1'bZ;							          
	      LB <= 1'bZ;
	      UB <= 1'bZ;
			
	 if (addone == 0)begin		
	 if(datagroupnum == 107) begin
	 cyclenum <= cyclenum + 1;
	 up <= 0;
	 datagroupnum <= 0;
	 LEDR[0] <= 0;
	 addone <= 1;
	 end
	 else begin
	      datagroupnum <= datagroupnum + 1;
			addone <= 1;
			end
	   end
		end
	 default:begin
	     CE <= 1;								          
	     WE <= 1'bZ;
		  OE <= 1'bZ;							          
	     LB <= 1'bZ;
	     UB <= 1'bZ;
		  end
		endcase
end


end




always @(posedge CLOCK_50_B5B)
begin
   case (readstate)
        5'b00000: if (refclk && show) readstate <= 5'b00001; 
        5'b00001: if (refclk) readstate <= 5'b00010;    
        5'b00010: if (refclk) readstate <= 5'b00011;    
        5'b00011: if (refclk) readstate <= 5'b00100;    
        5'b00100: if (refclk) readstate <= 5'b00101;   
        5'b00101: if (refclk) readstate <= 5'b00110;    
        5'b00110: if (refclk) readstate <= 5'b00111;    
        5'b00111: if (refclk) readstate <= 5'b01000;    
        5'b01000: if (refclk) readstate <= 5'b01001;    
        5'b01001: if (refclk) readstate <= 5'b01010;
        5'b01010: if (refclk) readstate <= 5'b01011;
        5'b01011: if (refclk) readstate <= 5'b01100;
        5'b01100: if (refclk) readstate <= 5'b01101;		  
		  5'b01101: if (refclk) readstate <= 5'b00000;
        default: readstate <= 5'b00000;                  
    endcase
end
//
always @(posedge CLOCK_50_B5B)
begin
   case (upstate)
        3'b000: if (refclk && up) upstate <= 3'b001; // Start bit
        3'b001: if (refclk) upstate <= 3'b010;    // Bit 0
        3'b010: if (refclk) upstate <= 3'b000;    // Bit 1
        
		  default: upstate <= 'b000;                  
    endcase
end


	endmodule	 