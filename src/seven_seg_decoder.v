`timescale 1ns / 1ps
module seven_seg_decoder(
    input main_clk,
    input switch0,
    input buttonUp,
    input buttonDown, 
    input [7:0] celsius_8_bits, 
    input [7:0] fahrenheit_8_bits,
    output reg LED_Red, 
    output reg LED_Red2,
    output reg LED_Blue,
    output reg LED_Blue2,
    output reg [6:0] SEG, 
    output reg [7:0] AN  
    );
    reg [7:0] valueF = 8'b0101_0000; //have starting display be 80 for button control
    wire [3:0] valueF_tens, valueF_ones;
    assign valueF_tens = valueF / 10; //get the value for tens place for button control          
    assign valueF_ones = valueF % 10; //get value for ones place for button control
    
    reg [7:0] valueC = 8'b0000_1111; //have starting display be 15 for button control
    wire [3:0] valueC_tens, valueC_ones;
    assign valueC_tens = valueC / 10; //get the value for tens place for button control         
    assign valueC_ones = valueC % 10; //get the value for ones place for button control
    
    wire [3:0] celsius_tens, celsius_ones; 
    assign celsius_tens = celsius_8_bits / 10; //get the value for tens place for C temperature reading           
    assign celsius_ones = celsius_8_bits % 10; //get the value for ones place for C temperature reading   
                
    wire [3:0] fahrenheit_tens, fahrenheit_ones;
    assign fahrenheit_tens = fahrenheit_8_bits / 10; //get the value for tens place for F temperature reading            
    assign fahrenheit_ones = fahrenheit_8_bits % 10; //get the value for ones place for F temperature reading    
    
    //the seven segments that have to be turned on for each required digit        
    parameter ZERO  = 7'b000_0001;  //0 
    parameter ONE   = 7'b100_1111;  //1
    parameter TWO   = 7'b001_0010;  //2 
    parameter THREE = 7'b000_0110;  //3
    parameter FOUR  = 7'b100_1100;  //4
    parameter FIVE  = 7'b010_0100;  //5
    parameter SIX   = 7'b010_0000;  //6
    parameter SEVEN = 7'b000_1111;  //7
    parameter EIGHT = 7'b000_0000;  //8
    parameter NINE  = 7'b000_0100;  //9
    parameter DEG   = 7'b001_1100;  //degrees
    parameter C     = 7'b011_0001;  //C
    parameter F     = 7'b011_1000;  //F
    reg [2:0] anode_select;
    reg [16:0] anode_timer;
    reg buttonUp_prev;
    reg buttonDown_prev;
    reg [7:0] debounce_counter;
    always @(posedge main_clk) begin
    
    //if switch is not flipped enter this
    if (switch0 == 1'b0) begin
        //if user value is less than temperature read from sensor, turn on blue lights
        if (valueF < fahrenheit_8_bits) begin
            LED_Red = 1'b0;
            LED_Red2 = 1'b0;
            LED_Blue = 1'b1; 
            LED_Blue2 = 1'b1;
            end
        //if user value is more than temperature read from sensor, turn on red lights    
        if(valueF > fahrenheit_8_bits) begin
            LED_Red = 1'b1;
            LED_Red2 = 1'b1;
            LED_Blue = 1'b0;
            LED_Blue2 = 1'b0;
            end
        //if user value is same as temperature read from sensor, have no lights on   
        if(valueF == fahrenheit_8_bits) begin
            LED_Red = 1'b0;
            LED_Red2 = 1'b0;
            LED_Blue = 1'b0;
            LED_Blue2 = 1'b0;
            end
        //had to debounce the button because if I didn't then if you pushed the button it would go crazy fast
        if (buttonUp != buttonUp_prev) begin
            debounce_counter <= 8'b0000_0000;
        end else if (buttonUp && (debounce_counter == 8'b0000_0000)) begin
                valueF <= valueF + 1; //counter to increase the user desired temperature
            debounce_counter <= 8'b1111_1111;
        end
        if (buttonDown != buttonDown_prev) begin
            debounce_counter <= 8'b0000_0000;
        end else if (buttonDown && (debounce_counter == 8'b0000_0000)) begin
                valueF <= valueF - 1; //counter to decrease the user desired temperature
            debounce_counter <= 8'b1111_1111;
        end
        buttonUp_prev <= buttonUp;
        buttonDown_prev <= buttonDown;
    end
    //if switch is flipped enter this
    else if (switch0 == 1'b1) begin 
        //if user value is less than temperature read from sensor, turn on blue lights
        if (valueC < celsius_8_bits) begin
            LED_Red = 1'b0;
            LED_Red2 = 1'b0;
            LED_Blue = 1'b1;
            LED_Blue2 = 1'b1;
            end
        //if user value is more than temperature read from sensor, turn on red lights       
        if(valueC > celsius_8_bits) begin
            LED_Red = 1'b1;
            LED_Red2 = 1'b1;
            LED_Blue = 1'b0;
            LED_Blue2 = 1'b0;
            end
        //if user value is same as temperature read from sensor, have no lights on      
        if(valueC == celsius_8_bits) begin
            LED_Red = 1'b0;
            LED_Red2 = 1'b0;
            LED_Blue = 1'b0;
            LED_Blue2 = 1'b0;
            end
        //had to debounce the button because if I didn't then if you pushed the button it would go crazy fast    
        if (buttonUp != buttonUp_prev) begin
            debounce_counter <= 8'b0000_0000;
        end else if (buttonUp && (debounce_counter == 8'b0000_0000)) begin
                valueC <= valueC + 1; //counter to increase the user desired temperature
            debounce_counter <= 8'b1111_1111;
        end
        if (buttonDown != buttonDown_prev) begin
            debounce_counter <= 8'b0000_0000;
        end else if (buttonDown && (debounce_counter == 8'b0000_0000)) begin
                valueC <= valueC - 1; //counter to decrease the user desired temperature
            debounce_counter <= 8'b1111_1111;
        end
        buttonUp_prev <= buttonUp;
        buttonDown_prev <= buttonDown;
    end
end
    //timer so the digits can refresh when updated
    always @(posedge main_clk) begin
        if(anode_timer == 99_999) begin
            anode_timer <= 0;
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end

    always @(anode_select) begin
        case(anode_select)
        //assigning which digit is what position 
            3'o0 : AN = 8'b1111_1110;
            3'o1 : AN = 8'b1111_1101;
            3'o2 : AN = 8'b1111_1011;
            3'o3 : AN = 8'b1111_0111;
            3'o4 : AN = 8'b1110_1111;
            3'o5 : AN = 8'b1101_1111;
            3'o6 : AN = 8'b1011_1111;
            3'o7 : AN = 8'b0111_1111;
        endcase
    end    
    always @* 
    
        case(anode_select)
            
            //first digit is C or F depending what mode it's in
            3'o0 : begin
            //if switch is on then we are in celsius mode, off we are in fahrenheit mode
                        if (switch0 == 1)
                            SEG = C;
                        else
                            SEG = F;
                   end
            //second digit is the degree symbol       
            3'o1 : SEG = DEG;
            //third digit is the ones place of the temperature sensor reading    
            3'o2 : begin
                        //if switch is on we are showing celsius ones place
                        if (switch0 == 1'b1)
                            case(celsius_ones)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                        else
                        //if switch is off we are showing fahrenheit ones place
                            case(fahrenheit_ones)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                    end
            //fourth digit is the tens place of the temperature sensor reading
            3'o3 : begin 
                        //if switch is on we are showing celsius tens place
                        if (switch0 == 1'b1)
                            case(celsius_tens)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                        else
                        //if switch is off we are showing fahrenheit tens place
                            case(fahrenheit_tens)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                    end
            //fifth digit is C or F depending what mode it's in
            3'o4 : begin
                        //if switch is on then we are in celsius mode, off we are in fahrenheit mode
                        if (switch0 == 1)
                            SEG = C;
                        else
                            SEG = F;
                   end
            //sixth digit is the degree symbol        
            3'o5 : SEG = DEG;
            //seventh digit is the ones place of the desired user temperature     
            3'o6 : begin
                        //if switch is on we are showing celsius ones place
                        if (switch0 == 1'b1)
                            case(valueC_ones)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                        else
                        //if switch is on we are showing fahrenheit ones place
                            case(valueF_ones)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                    end
            //eigth digit is the tens place of the desired user temperature    
            3'o7 : begin 
                        //if switch is on we are showing celsius tens place
                        if (switch0 == 1'b1)
                            case(valueC_tens)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                        else
                        //if switch is on we are showing fahrenheit tens place
                            case(valueF_tens)
                                4'b0000 : SEG = ZERO;
                                4'b0001 : SEG = ONE;
                                4'b0010 : SEG = TWO;
                                4'b0011 : SEG = THREE;
                                4'b0100 : SEG = FOUR;
                                4'b0101 : SEG = FIVE;
                                4'b0110 : SEG = SIX;
                                4'b0111 : SEG = SEVEN;
                                4'b1000 : SEG = EIGHT;
                                4'b1001 : SEG = NINE;
                            endcase
                    end    
        endcase  
endmodule
