`timescale 1ns / 1ps
module clock_divider(
    input main_clk,
    output slow_clk
    );
    reg [7:0] counter = 8'h00;
    reg clk_reg = 1'b1;    
    always @(posedge main_clk) begin
    //counter to slow the clock down
        if(counter == 249) begin
            counter <= 8'h00;
            clk_reg <= ~clk_reg;
        end
        else
            counter <= counter + 1;
    end    
    assign slow_clk = clk_reg;    
endmodule
