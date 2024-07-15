`timescale 1ns / 1ps
module i2c(
    input CLK, //clock               
    inout SDA, //temp sensor
    output [7:0] Temperature_8_Bit, //temperature from the sensor
    output SCL //temp sensor
    );
    wire SDA_Direction;
    reg [3:0] counter = 4'b0; 
    reg CLK_Reg = 1'b1;      
    assign SCL = CLK_Reg;   
    parameter [7:0] SensorAddress = 8'b1001_0111;
    reg [7:0] MSB_temp = 8'b0;                                  
    reg [7:0] LSB_temp = 8'b0;                                  
    reg o_bit = 1'b1;                                       
    reg [11:0] count = 12'b0;                               
    reg [7:0] Temperature_8_Bit_Reg;
    
    //all the steps for i2c communication with the temperature sensor					           			
    parameter [4:0]  POWER_UP   = 5'b00000,
                     START      = 5'b00001,
                     Address_6 = 5'b00010,
					 Address_5 = 5'b00011,
					 Address_4 = 5'b00100,
					 Address_3 = 5'b00101,
					 Address_2 = 5'b00110,
					 Address_1 = 5'b00111,
					 Address_0 = 5'b01000,
					 RW     = 5'b01001,
                     Acknowledge_Receive    = 5'b01010,
                     MSB_7  = 5'b01011,
					 MSB_6	= 5'b01100,
					 MSB_5	= 5'b01101,
					 MSB_4	= 5'b01110,
					 MSB_3	= 5'b01111,
					 MSB_2	= 5'b10000,
					 MSB_1	= 5'b10001,
					 MSB_0	= 5'b10010,
                     Acknowledge_Send   = 5'b10011,
                     LSB_7  = 5'b10100,
					 LSB_6	= 5'b10101,
					 LSB_5	= 5'b10110,
					 LSB_4	= 5'b10111,
					 LSB_3	= 5'b11000,
					 LSB_2	= 5'b11001,
					 LSB_1	= 5'b11010,
					 LSB_0	= 5'b11011,
                     NACK   = 5'b11100;      
    reg [4:0] state_reg = POWER_UP;                   
    always @(posedge CLK) begin
            if(counter == 9) begin
                counter <= 4'b0;
                CLK_Reg <= ~CLK_Reg;
            end
            else
                counter <= counter + 1;
			count <= count + 1;
            case(state_reg)
                POWER_UP    : begin
                                if(count == 12'd1999)
                                    state_reg <= START;
                end
                START       : begin
                                if(count == 12'd2004)
                                    o_bit <= 1'b0;  
                                if(count == 12'd2013)
                                    state_reg <= Address_6; 
                end
                Address_6  : begin
                                o_bit <= SensorAddress[7];
                                if(count == 12'd2033)
                                    state_reg <= Address_5;
                end
				Address_5  : begin
                                o_bit <= SensorAddress[6];
                                if(count == 12'd2053)
                                    state_reg <= Address_4;
                end
				Address_4  : begin
                                o_bit <= SensorAddress[5];
                                if(count == 12'd2073)
                                    state_reg <= Address_3;
                end
				Address_3  : begin
                                o_bit <= SensorAddress[4];
                                if(count == 12'd2093)
                                    state_reg <= Address_2;
                end
				Address_2  : begin
                                o_bit <= SensorAddress[3];
                                if(count == 12'd2113)
                                    state_reg <= Address_1;
                end
				Address_1  : begin
                                o_bit <= SensorAddress[2];
                                if(count == 12'd2133)
                                    state_reg <= Address_0;
                end
				Address_0  : begin
                                o_bit <= SensorAddress[1];
                                if(count == 12'd2153)
                                    state_reg <= RW;
                end
				RW     : begin
                                o_bit <= SensorAddress[0];
				if(count == 12'd2169)
                                    state_reg <= Acknowledge_Receive;
                end
                Acknowledge_Receive     : begin
                                if(count == 12'd2189)
                                    state_reg <= MSB_7;
                end
                MSB_7     : begin
                                MSB_temp[7] <= i_bit;
                                if(count == 12'd2209)
                                    state_reg <= MSB_6;
                                
                end
				MSB_6     : begin
                                MSB_temp[6] <= i_bit;
                                if(count == 12'd2229)
                                    state_reg <= MSB_5;
                                
                end
				MSB_5     : begin
                                MSB_temp[5] <= i_bit;
                                if(count == 12'd2249)
                                    state_reg <= MSB_4;
                                
                end
				MSB_4     : begin
                                MSB_temp[4] <= i_bit;
                                if(count == 12'd2269)
                                    state_reg <= MSB_3;
                                
                end
				MSB_3     : begin
                                MSB_temp[3] <= i_bit;
                                if(count == 12'd2289)
                                    state_reg <= MSB_2;
                                
                end
				MSB_2     : begin
                                MSB_temp[2] <= i_bit;
                                if(count == 12'd2309)
                                    state_reg <= MSB_1;
                                
                end
				MSB_1     : begin
                                MSB_temp[1] <= i_bit;
                                if(count == 12'd2329)
                                    state_reg <= MSB_0;
                                
                end
				MSB_0     : begin
								o_bit <= 1'b0;
                                MSB_temp[0] <= i_bit;
                                if(count == 12'd2349)
                                    state_reg <= Acknowledge_Send;
                                
                end
                Acknowledge_Send   : begin
                                if(count == 12'd2369)
                                    state_reg <= LSB_7;
                end
                LSB_7    : begin
                                LSB_temp[7] <= i_bit;
                                if(count == 12'd2389)
									state_reg <= LSB_6;
                end
                LSB_6    : begin
                                LSB_temp[6] <= i_bit;
                                if(count == 12'd2409)
									state_reg <= LSB_5;
                end
				LSB_5    : begin
                                LSB_temp[5] <= i_bit;
                                if(count == 12'd2429)
									state_reg <= LSB_4;
                end
				LSB_4    : begin
                                LSB_temp[4] <= i_bit;
                                if(count == 12'd2449)
									state_reg <= LSB_3;
                end
				LSB_3    : begin
                                LSB_temp[3] <= i_bit;
                                if(count == 12'd2469)
									state_reg <= LSB_2;
                end
				LSB_2    : begin
                                LSB_temp[2] <= i_bit;
                                if(count == 12'd2489)
									state_reg <= LSB_1;
                end
				LSB_1    : begin
                                LSB_temp[1] <= i_bit;
                                if(count == 12'd2509)
									state_reg <= LSB_0;
                end
				LSB_0    : begin
								o_bit <= 1'b1;
                                LSB_temp[0] <= i_bit;
                                if(count == 12'd2529)
									state_reg <= NACK;
                end
                NACK        : begin
                                if(count == 12'd2559) begin
									count <= 12'd2000;
                                    state_reg <= START;
								end
                end
            endcase     
    end      
    always @(posedge CLK)
        if(state_reg == NACK)
            Temperature_8_Bit_Reg <= { MSB_temp[6:0], LSB_temp[7] };
    assign SDA_Direction = (state_reg == POWER_UP || state_reg == START || state_reg == Address_6 || state_reg == Address_5 ||
					  state_reg == Address_4 || state_reg == Address_3 || state_reg == Address_2 || state_reg == Address_1 ||
                      state_reg == Address_0 || state_reg == RW || state_reg == Acknowledge_Send || state_reg == NACK) ? 1 : 0;
    assign SDA = SDA_Direction ? o_bit : 1'bz;
    assign i_bit = SDA;
    assign Temperature_8_Bit = Temperature_8_Bit_Reg;
endmodule