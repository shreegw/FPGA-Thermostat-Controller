`timescale 1ns / 1ps
module Convert_To_F(
    input [7:0] celsius_value,
    output reg [15:0] fahrenheit_value
    );
    reg [15:0] temp;
    reg [15:0] temp2;
    always @(*) begin
        temp = celsius_value * 9; //first part of conversion is multiplying C value by 9
        temp2 = temp / 5; //divide that value by 5
        fahrenheit_value = temp2 + 32; //add 32 and you get the fahrenheit value
    end
endmodule
