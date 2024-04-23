`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module pixel_gen(
  input clk,
  input reset,
  input up,
  input down,
  input [9:0] x,
  input [9:0] y,
  input video_on,
  input p_tick,
  output reg [11:0] rgb,
  output reg hit,
  output reg [3:0]point

);
//  output reg [3:0]score
reg score;

// Color Parameters
parameter RED   = 12'hF00;
parameter GREEN = 12'h0F0;
parameter BLACK = 12'h000;
parameter YELLOW = 12'h0FF;     
parameter VIOLET = 12'hF0F;     
parameter BLUE = 12'h00F;     

// Other parameters
  wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0; 
    reg count;
    
    // ********************************************************************************
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
    
    // Box
    // square rom boundaries
    parameter BOXX_SIZE = 28;
    parameter X_START = 60;                
    parameter Y_START = 210;                
    
    parameter Y_TOP = 30;                   
    parameter Y_BOTTOM = 451;               
    
    reg obs1y,obs2y,obs3y,obs4y;            
    wire [9:0] y_boxx_t, y_boxx_b;          

    reg [9:0] y_boxx_reg = Y_START;         
    reg [9:0] x_boxx_reg = X_START;          
       
    reg [9:0] obs1x_reg = X_MAX-1;
    reg [9:0] obs2x_reg = X_MAX-1;
    reg [9:0] obs3x_reg = X_MAX-1;
    reg [9:0] obs4x_reg = X_MAX-1;
    
    reg [9:0] y_boxx_next, x_boxx_next, obs1x_next, obs2x_next, obs3x_next, obs4x_next;     
    parameter BOXX_VELOCITY = 2;            // boxx velocity 
    parameter OBS_VELOCITY = 1;              // OBS velocity 
        
    
always @(posedge clk or posedge reset) begin
    if(reset || hit) begin
        // Reset case
        x_boxx_reg <= 40;
        y_boxx_reg <= 40;
        obs1x_reg <= X_MAX-1;
        obs2x_reg <= X_MAX-1;
        obs3x_reg <= X_MAX-1;
        obs4x_reg <= X_MAX-1;
        obs1y = 100;
        obs2y = 200;
        obs3y = 300;
        obs4y = 400;
        count <= 0;
    end else begin
        // Next state assignment
        x_boxx_reg <= x_boxx_next;
        y_boxx_reg <= y_boxx_next;
        obs1x_reg <= obs1x_next;
        obs2x_reg <= obs2x_next;
        obs3x_reg <= obs3x_next;
        obs4x_reg <= obs4x_next;
        count <= (count == 420) ? 0 : count + 1;
        
      end
      
end

// Update next state code
always @* begin
    y_boxx_next = y_boxx_reg;
    x_boxx_next = x_boxx_reg;
    obs1x_next = obs1x_reg;
    obs2x_next = obs2x_reg;
    obs3x_next = obs3x_reg;
    obs4x_next = obs4x_reg;

    if (refresh_tick) begin
        if(up && (y_boxx_t > BOXX_VELOCITY) && (y_boxx_t > (Y_TOP + BOXX_VELOCITY)))
            y_boxx_next = y_boxx_reg - BOXX_VELOCITY; // move up
        else if(down && (y_boxx_b < (Y_MAX - BOXX_VELOCITY)) && (y_boxx_b < (Y_BOTTOM - BOXX_VELOCITY)))
            y_boxx_next = y_boxx_reg + BOXX_VELOCITY; // move down

        obs1x_next = obs1x_reg - OBS_VELOCITY;
        obs2x_next = obs2x_reg - OBS_VELOCITY-1;
        obs3x_next = obs3x_reg - OBS_VELOCITY-0;
        obs4x_next = obs4x_reg - OBS_VELOCITY-1;
        
    
if (obs1x_next < 10) begin
obs1x_next = X_MAX - 50;
obs1y = $random % (Y_MAX - 20); 
end
if (obs2x_next < 10) begin
    obs2x_next = X_MAX - 100;
    obs2y = $random % (Y_MAX - 20);
end
if (obs3x_next < 10) begin
    obs3x_next = X_MAX - 150;
    obs3y = $random % (Y_MAX - 20);
end
if (obs4x_next < 10) begin
    obs4x_next = X_MAX - 200;
    obs4y = $random % (Y_MAX - 20);
end
end
end

// Box boundaries
assign x_boxx_l = X_START+30;
assign y_boxx_t = y_boxx_reg+30;
assign x_boxx_r = x_boxx_l + BOXX_SIZE+30;
assign y_boxx_b = y_boxx_t + BOXX_SIZE+30;

// Color assignment
always @* begin
    if(boxx_on)
        rgb = GREEN;
    else if(obs1_on)
        rgb = RED;
    else if(obs2_on)  
        rgb = BLUE;
    else if(obs3_on)
        rgb = VIOLET;  
    else if(obs4_on)
        rgb = YELLOW;  
    else 
        rgb = BLACK;
end

//initial begin 
//score = 4'b0001;
//end 
  
// for counting the score of player
always@*begin
  if (obs1x_next < 20)                         
    point = point + 1'b1;
  else
    point =1'b0;
  
  if (obs2x_next < 20)
    point =1'b1; 
  else
    point = 1'b0;
  
  if (obs3x_next < 20)
    point =1'b1; 
  else
    point =1'b0;
  
  if (obs4x_next < 20)
    point = 1'b1; 
  else
    point =1'b0;
  
  end

  
// Obstacle character box design
assign obs1_on = ((x >= obs1x_next)  && (x < (obs1x_next + 100))  && (y >= 100) && (y < 100 + 20));
assign obs2_on = ((x >= obs2x_next)  && (x < (obs2x_next + 100))  && (y >= 200) && (y < 200 + 20));
assign obs3_on = ((x >= obs3x_next)  && (x < (obs3x_next + 100))  && (y >= 300) && (y < 300 + 20));
assign obs4_on = ((x >= obs4x_next)  && (x < (obs4x_next + 100))  && (y >= 400) && (y < 400 + 20));

  
// Main character box design
assign boxx_on = (x_boxx_l+20<= x) && (x_boxx_r+20     >= x) && (y_boxx_t+20 <= y) && (y_boxx_b+10   >= y);

// for collision of main character box to obstacles 
always@*begin
if(boxx_on && (obs1_on || obs2_on || obs3_on || obs4_on))
            hit = 1'b1;
        else
            hit = 1'b0;
 
end     
endmodule
