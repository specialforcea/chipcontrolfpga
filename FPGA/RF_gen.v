module RF_gen
(

refclk,
outclk_0,
outclk_1,
outclk_2,
outclk_3,
outclk_4,
outclk_5,
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

reset,
);

input refclk;
input [7:0]div0;
input [7:0]div1;
input [7:0]div2;
input [7:0]div3;
input [7:0]div4;
input [7:0]div5;

input [7:0]phase_delay0;
input [7:0]phase_delay1;
input [7:0]phase_delay2;
input [7:0]phase_delay3;
input [7:0]phase_delay4;
input [7:0]phase_delay5;
input reset;


reg [7:0]count0 = 8'b00000000;
reg [7:0]count1 = 8'b00000000;
reg [7:0]count2 = 8'b00000000;
reg [7:0]count3 = 8'b00000000;
reg [7:0]count4 = 8'b00000000;
reg [7:0]count5 = 8'b00000000;
reg delay0 = 0;
reg delay1 = 0;
reg delay2 = 0;
reg delay3 = 0;
reg delay4 = 0;
reg delay5 = 0;


output outclk_0;
output outclk_1;
output outclk_2;
output outclk_3;
output outclk_4;
output outclk_5;

reg outclk_0 = 0;
reg outclk_1 = 0;
reg outclk_2 = 0;
reg outclk_3 = 0;
reg outclk_4 = 0;
reg outclk_5 = 0;
always @(posedge refclk)
begin

	 

    if(reset == 1)begin
		count0 <= 0;
		count1 <= 0;
		count2 <= 0;
		count3 <= 0;
		count4 <= 0;
		count5 <= 0;
		delay0 <= 1;
		delay1 <= 1;
		delay2 <= 1;
		delay3 <= 1;
		delay4 <= 1;
		delay5 <= 1;
		
		end
	else begin

    if (count0 == div0 + delay0*phase_delay0)
	 begin
	     count0 <= 0;
		  delay0 <= 0;
		  end
	 else begin
	     count0 <= count0 + 1;
		  end
		  
	 if (count1 == div1 + delay1*phase_delay1)
	 begin
	     count1 <= 0;
		  delay1 <= 0;
		  end
	 else begin
	     count1 <= count1 + 1;
		  end
		  
	 if (count2 == div2 + delay2*phase_delay2)
	 begin
	     count2 <= 0;
		  delay2 <= 0;
		  end
	 else begin
	     count2 <= count2 + 1;
		  end
		  
	 if (count3 == div3 + delay3*phase_delay3)
	 begin
	     count3 <= 0;
		  delay3 <= 0;
		  end
	 else begin
	     count3 <= count3 + 1;
		  end
		  
	 if (count4 == div4 + delay4*phase_delay4)
	 begin
	     count4 <= 0;
		  delay4 <= 0;
		  end
	 else begin
	     count4 <= count4 + 1;
		  end
		  
	 if (count5 == div5 + delay5*phase_delay5)
	 begin
	     count5 <= 0;
		  delay5 <= 0;
		  end
	 else begin
	     count5 <= count5 + 1;
		  end
		  
	end
	
	
	if(count0 == 0)begin outclk_0 <= ~outclk_0; end
	if(count1 == 0)begin outclk_1 <= ~outclk_1; end
	if(count2 == 0)begin outclk_2 <= ~outclk_2; end
	if(count3 == 0)begin outclk_3 <= ~outclk_3; end
	if(count4 == 0)begin outclk_4 <= ~outclk_4; end
	if(count5 == 0)begin outclk_5 <= ~outclk_5; end
	

end

endmodule