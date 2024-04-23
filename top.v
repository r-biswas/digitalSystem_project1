`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module top(
  input clk_100MHz,
  input reset,
  input up,
  input down,
  output hsync,
  output vsync,
  output [11:0] rgb,
  output [6:0]LED_out,
  output [3:0] Anode_Activate,
  output [3:0]point
);


wire w_reset, w_up, w_down;
wire w_video_on, w_p_tick;
wire [9:0] w_x, w_y;
reg [11:0] rgb_reg;
wire [11:0] rgb_next;


Seven_segment_LED_Display_Controller(clk_100MHz, reset,score,Anode_Activate,LED_out);

vga_controller vga(.clk_100MHz(clk_100MHz), .reset(w_reset), .video_on(w_video_on), 
                   .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));

btn_debounce dReset(.clk(clk_100MHz), .btn_in(reset), .btn_out(w_reset));
btn_debounce dUp(.clk(clk_100MHz), .btn_in(up), .btn_out(w_up));
btn_debounce dDown(.clk(clk_100MHz), .btn_in(down), .btn_out(w_down));

pixel_gen pg(.clk(clk_100MHz), .reset(w_reset), .up(w_up), .down(w_down), 
             .x(w_x), .y(w_y), .video_on(w_video_on), .p_tick(w_p_tick), 
             .rgb(rgb_next), .hit(hit),.point(point));

always @(posedge clk_100MHz) begin
    if(w_p_tick)
        rgb_reg <= rgb_next;
end

assign rgb = rgb_reg;

endmodule
