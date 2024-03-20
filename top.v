`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3
    input up,               // btnU
    input down,             // btnD
    output hsync,           // to VGA connector
    output vsync,           // to VGA connector
    output [11:0] rgb       // to DAC, 3 RGB bits to VGA connector
    );
    
    wire w_reset, w_up, w_down;
    wire w_video_on, w_p_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    wire[11:0] rgb_next;
    
    vga_controller vga(.clk_100MHz(clk_100MHz), .reset(w_reset), .video_on(w_video_on), 
                       .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    btn_debounce dReset(.clk(clk_100MHz), .btn_in(reset), .btn_out(w_reset));
    btn_debounce dUp(.clk(clk_100MHz), .btn_in(up), .btn_out(w_up));
    btn_debounce dDown(.clk(clk_100MHz), .btn_in(down), .btn_out(w_down));
    
    pixel_gen pg(.clk(clk_100MHz), .reset(w_reset), .up(w_up), .down(w_down), 
                 .left(w_left), .right(w_right), .video_on(w_video_on), 
                 .p_tick(w_p_tick), .x(w_x), .y(w_y), .rgb(rgb_next));
                 
                 
    
    // Buffer RGB
    always @(posedge clk_100MHz)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    assign rgb = rgb_reg;
    
endmodule
