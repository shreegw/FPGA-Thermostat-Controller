# Thermostat Controller Module using FPGA
The project is a Thermostat control module utilizing a built-in temperature sensor to display the ambient temperature on the right four digits of a seven-segment display. Users can input their desired temperature on the left four digits using the push buttons on the board. If the user sets the desired temperature below the ambient temperature, blue LEDs will illuminate to indicate that the AC should be activated. Conversely, if the user sets the desired temperature above the ambient temperature, red LEDs will illuminate to signal that the heater should be turned on. Additionally, a switch allows users to toggle between Fahrenheit and Celsius modes.


# Files
- clock_divider.v
- Convert_to_F.v
- Temperature_Converter.v
- seven_seg_decoder.v
- topModule.v
- i2c.v

 # System Diagram
 ![System Diagram For Thermostat Controller using FPGA ](https://github.com/shreegw/FPGA-Thermostat-Controller/blob/main/Picture1.jpg "a title")
