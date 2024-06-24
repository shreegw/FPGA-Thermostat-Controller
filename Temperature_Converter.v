`timescale 1ns / 1ps
module Temperature_Converter(
    input [7:0] celsius,
    output [7:0] fahrenheit
    );
    Convert_To_F f1(.celsius_value(celsius), .fahrenheit_value(fahrenheit)); 
endmodule
