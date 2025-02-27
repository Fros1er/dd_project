`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/13 14:02:28
// Design Name: 
// Module Name: clock_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_div(
    input clk, rst,
    output reg clk_out
    );
    parameter period = 4;
    reg cnt;
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            cnt <= 0;
            clk_out <= 0;
            end
        else
            if (cnt == ((period >> 1) - 1)) begin
                clk_out <= ~clk_out;
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
    end
endmodule
