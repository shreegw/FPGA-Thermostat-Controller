`timescale 1ns / 1ps
module topModule(
    input         topCLK, //main clock
    input         switch0, //switch[0] on the board
    input         buttonUp, //button to increase
    input         buttonDown, //button to decrease
    output  LED_Red, 
    output  LED_Red2,
    output  LED_Blue,
    output  LED_Blue2, 
    inout         Temperature_SDA, //temp sensor
    output        Temperature_SCL, //temp sensor
    output [6:0]  SEG, //7 segment display
    output [7:0]  AN //the 8 digits
    );
    wire clk2; //divided clock                  
    wire [7:0] celsius_8_bits; //temperature data in celsius              
    wire [7:0] fahrenheit_8_bits; //temperature data in fahrenheit              
    i2c i1(
        .CLK(clk2),
        .Temperature_8_Bit(celsius_8_bits),
        .SDA(Temperature_SDA),
        .SCL(Temperature_SCL)
    );
    clock_divider c1(
        .main_clk(topCLK),
        .slow_clk(clk2)
    );    
    seven_seg_decoder s1(
        .main_clk(topCLK),
        .switch0(switch0),
        .buttonUp(buttonUp),
        .buttonDown(buttonDown),
        .LED_Red(LED_Red),
        .LED_Red2(LED_Red2),
        .LED_Blue(LED_Blue),
        .LED_Blue2(LED_Blue2),
        .celsius_8_bits(celsius_8_bits),
        .fahrenheit_8_bits(fahrenheit_8_bits),
        .SEG(SEG),
        .AN(AN)
    );    
    Temperature_Converter t1(
        .celsius(celsius_8_bits),
        .fahrenheit(fahrenheit_8_bits)
    );
endmodule