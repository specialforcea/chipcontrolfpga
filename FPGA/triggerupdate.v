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

locked,
mgmt_waitrequest,
mgmt_readdata,
mgmt_writedata,
mgmt_read,
mgmt_write,
mgmt_address,
nmbr,
);


input CLOCK_50_B5B;

inout  [15:0]data;
input readfromusb;
input [3:0]KEY;
input mgmt_waitrequest;
input locked;

output sendtousb;
output [17:0]address;
output WE;
output CE;
output OE;
output LB;
output UB;
output [767:0]nmbr;
input [31:0]mgmt_readdata;
output [31:0]mgmt_writedata;
output [5:0]mgmt_address;
output mgmt_read;
output mgmt_write;
output [9:0]LEDR;

reg [17:0]address;
reg [17:0]addresspre;
initial addresspre = 18'b000000000000000000;
reg [17:0]addressfinal;
initial addressfinal = 18'b000000000000000000;
reg [5:0]state;
reg [4:0]readstate;
reg [5:0]reconstate = 6'b100000;
reg [2:0]upstate;
reg reconfig = 0;
reg [9:0]LEDR = 0;

reg [7:0]datapre;
reg [15:0]prestoreram;
integer datagroupnum = 0;
integer cyclenum =0;

reg [31:0]N;
reg [31:0]M;
reg [31:0]C0;
reg [31:0]C1;
reg [31:0]C2;
reg [31:0]C3;
reg [31:0]C4;
reg [31:0]C5;
reg [31:0]sft0;
reg [31:0]sft1;
reg [31:0]sft2;
reg [31:0]sft3;
reg [31:0]sft4;
reg [31:0]sft5;
reg WE;
reg CE;
reg OE;
reg LB;
reg UB;
reg [767:0]nmbr = 0;

reg [31:0]mgmt_writedata;
reg [5:0]mgmt_address;
reg mgmt_read = 0;
reg mgmt_write = 0;
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



//always @(posedge refclk)
//begin
//
//    if (clockdiv1 == 100 | readfromusb == 0)begin
//	     clockdiv1 <= 0;
//		  end
//	 else if (writing == 1) begin
//	     clockdiv1 <= clockdiv1 + 1;
//		  end
//end




wire refclk = (clockdiv == 0);
//wire refclk1 = (clockdiv1 == 0);


	  



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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  addonew <= 0;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
			                          if (addonew == 0) begin addresspre <= addresspre + 1;addonew <= 1;end
											  
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
										     if (addresspre == addressfinal && transferring == 0)begin  status <= 0;  transferring <= 1;end
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
										 sendtousb <= 0;   end       // Start bit	
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
										     
											  if(transferring == 0)begin status <= 4'b0110; addresspre <= 0; show <= 1;end
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
         5'b00011:  begin sendtousb <= prestoreram[0];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end    
         5'b00100:  begin sendtousb <= prestoreram[1];
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
         5'b01000:  begin sendtousb <= prestoreram[5];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end   
         5'b01001:  begin sendtousb <= prestoreram[6];
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
									   end                         
	

			5'b01010:  begin sendtousb <= prestoreram[7];
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
											  addoner <= 0;
											  
									   end
         5'b01100:  begin sendtousb <= 1;
			                          if (addoner == 0 ) begin addresspre <= addresspre + 1;addoner <= 1;end
												
											  CE <= 1;		WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end // Bit 1
         
         5'b10011:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  
											  
											  
											  end
											   // Stop bit 	
			 5'b10100:  begin sendtousb <= 1;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; 
										     
											  if(addresspre == addressfinal)begin status <= 4'b0000; addresspre <= 0; show <= 0;end
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
											 bytetocorrect <= receive;end
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
		
		
			6'b001011:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;
											  addonew <= 0;
											  //writing <= 1; 
								           end			  // Bit 0
         6'b001100:  begin sendtousb <= 0;
			                          if (addonew == 0) begin correctingbyte <= correctingbyte + 1;addonew <= 1;end
											  
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;   end// Bit 1
         6'b001101:  begin sendtousb <= 0;
	                                CE <= 1;								          
	                                WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ;  end  // Bit 2
         6'b001110:  begin sendtousb <= 0;
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
										     if (correctingbyte == bytetocorrect && transferring == 0)begin  status <= 0;  end
											  if (correctingbyte < bytetocorrect && transferring == 0)begin status <= 4'b1000;end 
											end  
			
	     default: begin sendtousb <= 1;  CE <= 1;	WE <= 1'bZ;
											  OE <= 1'bZ;							          
	                                LB <= 1'bZ;
	                                UB <= 1'bZ; end     		

         
       endcase
		 end
		 
		 
	 endcase
	 
	 
	
	 
	 
//	 if(KEY[0] == 0) begin
//	     show <= 1;
//		  end
//	 

    
    
	 
//	 if(clockdiv1 == 100) begin
//	      addresspre <= 18'b000000000000000000;
//			cyclenum <= 0;
//			datagroupnum <= 0;
			
			
	 
	 if(KEY[2] == 0) begin
	      auxup <= 1;
			end
			
	 if (auxup == 1 && KEY[2] == 1) begin
	     up <= 1;
		  auxup <= 0;
		  end

	 if (up == 1)begin
	 case (upstate)
	 
	      3'b000:begin
			       CE <= 1;								          
	             WE <= 1'bZ;
				    OE <= 1'bZ;							          
	             LB <= 1'bZ;
	             UB <= 1'bZ;
					 addresspre <= cyclenum * 110 + datagroupnum;
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
	 N[0] <=data[0];
	 N[1] <=data[1];
	 N[2] <=data[2];
	 N[3] <=data[3];
	 N[4] <=data[4];
	 N[5] <=data[5];
	 N[6] <=data[6];
	 N[7] <=data[7];
	 N[8] <=data[0];
	 N[9] <=data[1];
	 N[10] <=data[2];
	 N[11] <=data[3];
	 N[12] <=data[4];
	 N[13] <=data[5];
	 N[14] <=data[6];
	 N[15] <=data[7];
	 N[16] <= 0;
	 N[17] <= 0;
	 N[31:18] <= 14'b00000000000000;
	 end
	 if (datagroupnum == 1) begin
	 M[0] <=data[0];
	 M[1] <=data[1];
	 M[2] <=data[2];
	 M[3] <=data[3];
	 M[4] <=data[4];
	 M[5] <=data[5];
	 M[6] <=data[6];
	 M[7] <=data[7];
	 M[8] <=data[0];
	 M[9] <=data[1];
	 M[10] <=data[2];
	 M[11] <=data[3];
	 M[12] <=data[4];
	 M[13] <=data[5];
	 M[14] <=data[6];
	 M[15] <=data[7];
	 M[16] <= 0;
	 M[17] <= 0;
	 M[31:18] <= 14'b00000000000000;
	 end
	 if (datagroupnum == 2) begin
	 C0[0] <=data[0];
	 C0[1] <=data[1];
	 C0[2] <=data[2];
	 C0[3] <=data[3];
	 C0[4] <=data[4];
	 C0[5] <=data[5];
	 C0[6] <=data[6];
	 C0[7] <=data[7];
	 C0[8] <=data[0];
	 C0[9] <=data[1];
	 C0[10] <=data[2];
	 C0[11] <=data[3];
	 C0[12] <=data[4];
	 C0[13] <=data[5];
	 C0[14] <=data[6];
	 C0[15] <=data[7];
	 C0[16] <= 0;
	 C0[17] <= 0;
	 C0[22:18] <= 5'b00000;
	 end
	 if (datagroupnum == 3) begin
	 C1[0] <=data[0];
	 C1[1] <=data[1];
	 C1[2] <=data[2];
	 C1[3] <=data[3];
	 C1[4] <=data[4];
	 C1[5] <=data[5];
	 C1[6] <=data[6];
	 C1[7] <=data[7];
	 C1[8] <=data[0];
	 C1[9] <=data[1];
	 C1[10] <=data[2];
	 C1[11] <=data[3];
	 C1[12] <=data[4];
	 C1[13] <=data[5];
	 C1[14] <=data[6];
	 C1[15] <=data[7];
	 C1[16] <= 0;
	 C1[17] <= 0;
	 C1[22:18] <= 5'b00001;
	 C1[31:23] <= 9'b000000000;
	 end
	 if (datagroupnum == 4) begin
	 C2[0] <=data[0];
	 C2[1] <=data[1];
	 C2[2] <=data[2];
	 C2[3] <=data[3];
	 C2[4] <=data[4];
	 C2[5] <=data[5];
	 C2[6] <=data[6];
	 C2[7] <=data[7];
	 C2[8] <=data[0];
	 C2[9] <=data[1];
	 C2[10] <=data[2];
	 C2[11] <=data[3];
	 C2[12] <=data[4];
	 C2[13] <=data[5];
	 C2[14] <=data[6];
	 C2[15] <=data[7];
	 C2[16] <= 0;
	 C2[17] <= 0;
	 C2[22:18] <= 5'b00010;
	 C2[31:23] <= 9'b000000000;
	 end
	 if (datagroupnum == 5) begin
	 C3[0] <=data[0];
	 C3[1] <=data[1];
	 C3[2] <=data[2];
	 C3[3] <=data[3];
	 C3[4] <=data[4];
	 C3[5] <=data[5];
	 C3[6] <=data[6];
	 C3[7] <=data[7];
	 C3[8] <=data[0];
	 C3[9] <=data[1];
	 C3[10] <=data[2];
	 C3[11] <=data[3];
	 C3[12] <=data[4];
	 C3[13] <=data[5];
	 C3[14] <=data[6];
	 C3[15] <=data[7];
	 C3[16] <= 0;
	 C3[17] <= 0;
	 C3[22:18] <= 5'b00011;
	 C3[31:23] <= 9'b000000000;
	 end
	 if (datagroupnum == 6) begin
	 C4[0] <=data[0];
	 C4[1] <=data[1];
	 C4[2] <=data[2];
	 C4[3] <=data[3];
	 C4[4] <=data[4];
	 C4[5] <=data[5];
	 C4[6] <=data[6];
	 C4[7] <=data[7];
	 C4[8] <=data[0];
	 C4[9] <=data[1];
	 C4[10] <=data[2];
	 C4[11] <=data[3];
	 C4[12] <=data[4];
	 C4[13] <=data[5];
	 C4[14] <=data[6];
	 C4[15] <=data[7];
	 C4[16] <= 0;
	 C4[17] <= 0;
	 C4[22:18] <= 5'b00100;
	 C4[31:23] <= 9'b000000000;
	 end
	 if (datagroupnum == 7) begin
	 C5[0] <=data[0];
	 C5[1] <=data[1];
	 C5[2] <=data[2];
	 C5[3] <=data[3];
	 C5[4] <=data[4];
	 C5[5] <=data[5];
	 C5[6] <=data[6];
	 C5[7] <=data[7];
	 C5[8] <=data[0];
	 C5[9] <=data[1];
	 C5[10] <=data[2];
	 C5[11] <=data[3];
	 C5[12] <=data[4];
	 C5[13] <=data[5];
	 C5[14] <=data[6];
	 C5[15] <=data[7];
	 C5[16] <= 0;
	 C5[17] <= 0;
	 C5[22:18] <= 5'b00101;
	 C5[31:23] <= 9'b000000000;
	 end
	 if (datagroupnum == 8) begin
	 sft0[0] <=data[0];
	 sft0[1] <=data[1];
	 sft0[2] <=data[2];
	 sft0[3] <=data[3];
	 sft0[4] <=data[4];
	 sft0[5] <=data[5];
	 sft0[6] <=data[6];
	 sft0[7] <=data[7];
	 sft0[15:8] <= 8'b00000000;
	 sft0[20:16] <= 5'b00000;
	 sft0[21] <= 1;
	 sft0[31:22] <= 10'b0000000000;
	 end
	 if (datagroupnum == 9) begin
	 sft1[0] <=data[0];
	 sft1[1] <=data[1];
	 sft1[2] <=data[2];
	 sft1[3] <=data[3];
	 sft1[4] <=data[4];
	 sft1[5] <=data[5];
	 sft1[6] <=data[6];
	 sft1[7] <=data[7];
	 sft1[15:8] <= 8'b00000000;
	 sft1[20:16] <= 5'b00001;
	 sft1[21] <= 1;
	 sft1[31:22] <= 10'b0000000000;
	 end
	 if (datagroupnum == 10) begin
	 sft2[0] <=data[0];
	 sft2[1] <=data[1];
	 sft2[2] <=data[2];
	 sft2[3] <=data[3];
	 sft2[4] <=data[4];
	 sft2[5] <=data[5];
	 sft2[6] <=data[6];
	 sft2[7] <=data[7];
	 sft2[15:8] <= 8'b00000000;
	 sft2[20:16] <= 5'b00010;
	 sft2[21] <= 1;
	 sft2[31:22] <= 10'b0000000000;
	 end
	 if (datagroupnum == 11) begin
	 sft3[0] <=data[0];
	 sft3[1] <=data[1];
	 sft3[2] <=data[2];
	 sft3[3] <=data[3];
	 sft3[4] <=data[4];
	 sft3[5] <=data[5];
	 sft3[6] <=data[6];
	 sft3[7] <=data[7];
	 sft3[15:8] <= 8'b00000000;
	 sft3[20:16] <= 5'b00011;
	 sft3[21] <= 1;
	 sft3[31:22] <= 10'b0000000000;
	 end
	 if (datagroupnum == 12) begin
	 sft4[0] <=data[0];
	 sft4[1] <=data[1];
	 sft4[2] <=data[2];
	 sft4[3] <=data[3];
	 sft4[4] <=data[4];
	 sft4[5] <=data[5];
	 sft4[6] <=data[6];
	 sft4[7] <=data[7];
	 sft4[15:8] <= 8'b00000000;
	 sft4[20:16] <= 5'b00100;
	 sft4[21] <= 1;
	 sft4[31:22] <= 10'b0000000000;
	 end
	 if (datagroupnum == 13) begin
	 sft5[0] <=data[0];
	 sft5[1] <=data[1];
	 sft5[2] <=data[2];
	 sft5[3] <=data[3];
	 sft5[4] <=data[4];
	 sft5[5] <=data[5];
	 sft5[6] <=data[6];
	 sft5[7] <=data[7];
	 sft5[15:8] <= 8'b00000000;
	 sft5[20:16] <= 5'b00101;
	 sft5[21] <= 1;
	 sft5[31:22] <= 10'b0000000000;
	 reconfig <= 1;
	 end
	 if (datagroupnum > 13 ) begin
	 nmbr[(datagroupnum-14)*8+0] <= data[0];
	 nmbr[(datagroupnum-14)*8+1] <= data[1];
	 nmbr[(datagroupnum-14)*8+2] <= data[2];
	 nmbr[(datagroupnum-14)*8+3] <= data[3];
	 nmbr[(datagroupnum-14)*8+4] <= data[4];
	 nmbr[(datagroupnum-14)*8+5] <= data[5];
	 nmbr[(datagroupnum-14)*8+6] <= data[6];
	 nmbr[(datagroupnum-14)*8+7] <= data[7];
	 
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
	 if(datagroupnum == 109) begin
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

   
LEDR[4] <= reconfig;
LEDR[3] <= ~locked;
LEDR[2] <= mgmt_waitrequest;
if (reconfig == 1) begin
case(reconstate)
    6'b100000: begin
//	          mgmt_write <= 1;
//				 mgmt_writedata <= 32'b00000000000000000000000000000001;
//				 mgmt_address <= 6'b000000;
//				 mgmt_read <= 0;
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b000000: begin
//	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[31]; 
//				 mgmt_address <= 6'b000001;
//				 mgmt_read <= 1;
	          mgmt_write <= 1;
				 mgmt_writedata <= 0;
				 mgmt_address <= 6'b000000;
				 mgmt_read <= 0;
//				
				 end
	 6'b000001: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				
				 end
	 6'b000010: begin
//	          
	          mgmt_address <= 6'b000011;
				 mgmt_writedata <= N;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
//				 
				 end
	 6'b000011: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b000100: begin	          
	          mgmt_address <= 6'b000100;
				 mgmt_writedata <= M;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b000101: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 
				 end
	 6'b000110: begin
	          
	          mgmt_address <= 6'b000101;
				 mgmt_writedata <= C0;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b000111: begin
	          mgmt_write <= 0;
//			    LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b001000: begin
             mgmt_address <= 6'b000101;
				 mgmt_writedata <= C1;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b001001: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
// 			 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 
				 end
    6'b001010: begin
	          mgmt_address <= 6'b000101;
				 mgmt_writedata <= C2;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b001011: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b001100: begin
	          mgmt_address <= 6'b000101;
				 mgmt_writedata <= C3;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b001101: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b001110: begin
	          mgmt_address <= 6'b000101;
				 mgmt_writedata <= C4;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end		 
	 6'b001111: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b010000: begin
	          mgmt_address <= 6'b000101;
				 mgmt_writedata <= C5;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				
				 end
	 6'b010001: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				
				 end
	 6'b010010: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft0;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 
				 end
	 6'b010011: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b010100: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft1;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b010101: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b010110: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft2;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b010111: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b011000: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft3;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b011001: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
    6'b011010: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft4;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b011011: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b011100: begin
	          mgmt_address <= 6'b000110;
				 mgmt_writedata <= sft5;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 end
	 6'b011101: begin
	          mgmt_write <= 0;
//				 LEDR[1] <= mgmt_readdata[0]; 
//				 mgmt_address <= 6'b000001;
				 mgmt_read <= 0;
				 end
	 6'b011110: begin
	          mgmt_address <= 6'b000010;
				 mgmt_writedata <= 1;
				 mgmt_write <= 1;
				 mgmt_read <= 0;
				 
				 end		 
	 6'b011111: begin
	          mgmt_write <= 0;
				 reconfig <= 0;
				 mgmt_read <= 0;
				 end
	 default: begin 
	          reconfig <= 0;
	          mgmt_write <= 0; 
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

always @(posedge CLOCK_50_B5B)
begin
   case (reconstate)
        6'b100000: if (refclk && reconfig) reconstate <= 6'b000000;
		  6'b000000: if (refclk) reconstate <= 6'b000001; // Start bit
        6'b000001: if (refclk) reconstate <= 6'b000010;    // Bit 0
        6'b000010: if (refclk) reconstate <= 6'b000011;    // Bit 1
        6'b000011: if (refclk) reconstate <= 6'b000100;    // Bit 2
        6'b000100: if (refclk) reconstate <= 6'b000101;    // Bit 3
        6'b000101: if (refclk) reconstate <= 6'b000110;    // Bit 4
        6'b000110: if (refclk) reconstate <= 6'b000111;    // Bit 6
        6'b000111: if (refclk) reconstate <= 6'b001000;    // Bit 6
        6'b001000: if (refclk) reconstate <= 6'b001001;    // Bit 7
        6'b001001: if (refclk) reconstate <= 6'b001010;    // Stop bit
		  6'b001010: if (refclk) reconstate <= 6'b001011;    //operation
		  6'b001011: if (refclk) reconstate <= 6'b001100;
		  6'b001100: if (refclk) reconstate <= 6'b001101;
		  6'b001101: if (refclk) reconstate <= 6'b001110;
		  6'b001110: if (refclk) reconstate <= 6'b001111;
		  6'b001111: if (refclk) reconstate <= 6'b010000;
		  6'b010000: if (refclk) reconstate <= 6'b010001;
		  6'b010001: if (refclk) reconstate <= 6'b010010;    // Bit 0
        6'b010010: if (refclk) reconstate <= 6'b010011;    // Bit 1
        6'b010011: if (refclk) reconstate <= 6'b010100;    // Bit 2
        6'b010100: if (refclk) reconstate <= 6'b010101;    // Bit 3
        6'b010101: if (refclk) reconstate <= 6'b010110;    // Bit 4
        6'b010110: if (refclk) reconstate <= 6'b010111;    // Bit 6
        6'b010111: if (refclk) reconstate <= 6'b011000;    // Bit 6
        6'b011000: if (refclk) reconstate <= 6'b011001;    // Bit 7
        6'b011001: if (refclk) reconstate <= 6'b011010;    // Stop bit
		  6'b011010: if (refclk) reconstate <= 6'b011011;	  
		  6'b011011: if (refclk) reconstate <= 6'b011100;
		  6'b011100: if (refclk) reconstate <= 6'b011101;
		  6'b011101: if (refclk) reconstate <= 6'b011110;
		  6'b011110: if (refclk) reconstate <= 6'b011111;
		  6'b011111: if (refclk) reconstate <= 6'b100000;
		  default: reconstate <= 6'b100000;                  
    endcase
end
	
	
	
	endmodule	 