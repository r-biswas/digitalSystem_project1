`timescale 1ns / 1ps

module pixel_gen(
    input clk,              // 100MHz
    input reset,            // btnC
    input up,               // btnU
    input down,             // btnD
    
    input [9:0] x,          // from vga controller
    input [9:0] y,          // from vga controller
    input video_on,         // from vga controller
    input p_tick,           // 25MHz from vga controller
    output reg [11:0] rgb   // to DAC, to vga connector
    );
    
    // RGB Color Values
    parameter RED    = 12'h00F;
    parameter GREEN  = 12'h0F0;
    parameter BLUE   = 12'hF00;
    parameter YELLOW = 12'h0FF;     // RED and GREEN
    parameter AQUA   = 12'hFF0;     // GREEN and BLUE
    parameter VIOLET = 12'hF0F;     // RED and BLUE
    parameter WHITE  = 12'hFFF;     // all ON
    parameter BLACK  = 12'h000;     // all OFF
    parameter GRAY   = 12'hAAA;     // some of each color
    
    // Pixel Location Status Signals
        // 60Hz refresh tick
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0; // start of vsync(vertical retrace)
    
    // ********************************************************************************
    // maximum x, y values in display area
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
    
    // Box
    // square rom boundaries
    parameter BOXX_SIZE = 28;
    parameter X_START = 60;                // starting x position - left rom edge centered horizontally
    parameter Y_START = 210;                // starting y position - centered in lower yellow area vertically
    
    
    parameter Y_TOP = 30;                   // against top home/wall areas 
    parameter Y_BOTTOM = 451;               // against bottom green wall
    
    wire [9:0] y_boxx_t, y_boxx_b;          // boxx vertical boundary signals  

    reg [9:0] y_boxx_reg = Y_START;         // boxx starting position X
    reg [9:0] x_boxx_reg = X_START;         // boxx starting position Y
    
    reg [9:0] y_boxx_next, x_boxx_next;     // signals for register buffer 
    parameter BOXX_VELOCITY = 4;            // boxx velocity  
    
    
    // Register Control
    always @(posedge clk or posedge reset)
        if(reset) begin
            x_boxx_reg <= X_START;
            y_boxx_reg <= Y_START;
        end
        else begin
            x_boxx_reg <= x_boxx_next;
            y_boxx_reg <= y_boxx_next;
        end
   
    always @* begin
        y_boxx_next = y_boxx_reg;       // no move
        x_boxx_next = x_boxx_reg;       // no move
        if(refresh_tick)                
            if(up & (y_boxx_t > BOXX_VELOCITY) & (y_boxx_t > (Y_TOP + BOXX_VELOCITY)))
                y_boxx_next = y_boxx_reg - BOXX_VELOCITY;  // move up
            else if(down & (y_boxx_b < (Y_MAX - BOXX_VELOCITY)) & (y_boxx_b < (Y_BOTTOM - BOXX_VELOCITY)))
                y_boxx_next = y_boxx_reg + BOXX_VELOCITY;  // move down
    end  
    
    // boxx rom data square boundaries
    assign x_boxx_l = x_boxx_reg;
    assign y_boxx_t = y_boxx_reg;
    assign x_boxx_r = x_boxx_l + BOXX_SIZE - 1;
    assign y_boxx_b = y_boxx_t + BOXX_SIZE - 1;
    
    // rom object status signal
    wire boxx_on;
                    
    // pixel within rom square boundaries
    assign boxx_on = (x_boxx_l <= x) && (x <= x_boxx_r) &&
                     (y_boxx_t <= y) && (y <= y_boxx_b);   
    
    
    wire box1_on, obs1_on, obs2_on,obs3_on,obs4_on;
    // Main character box design
//    assign box1_on = ((x >= 40)   && (x < 91)   &&  (y >= 200) && (y < 250));
    // Obstacle character box design
    assign obs1_on = ((x >= 455)   && (x < 600)   &&  (y >= 100) && (y < 130));
    assign obs2_on = ((x >= 400)   && (x < 550)   &&  (y >= 200) && (y < 230));
    assign obs3_on = ((x >= 250)   && (x < 400)   &&  (y >= 150) && (y < 180));
    assign obs4_on = ((x >= 285)   && (x < 430)   &&  (y >= 350) && (y < 380));
    

    
    // Set RGB output value based on status signals
    always @*
        if(~video_on)
            rgb = BLACK;
        else
            if(boxx_on)
                rgb = GREEN;
            else if(obs1_on)
                rgb = RED;
            else if(obs2_on)
                rgb = RED;
            else if(obs3_on)
                rgb = RED;
            else if(obs4_on)
                rgb = RED;
            else
                rgb = BLACK;
endmodule
