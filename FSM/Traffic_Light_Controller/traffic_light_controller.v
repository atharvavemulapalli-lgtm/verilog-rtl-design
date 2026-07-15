// Module    : Traffic Light Controller
// Type      : Moore FSM
// Function  : Controls a four-way traffic junction using
//             timer-based state transitions and side-street
//             traffic detection.
module traffic_light(
    input clk, rstn, 
    input [1:0] in, 
    output [1:0] out);

    // State encoding
    /* GR : Main Road Green, Street Red
       YR : Main Road Yellow, Street Red
       RG : Main Road Red, Street Green
       RY : Main Road Red, Street Yellow */
    localparam GR = 2'd0,
               YR = 2'd1,
               RG = 2'd2,
               RY = 2'd3;

    // Timer values (clock cycles)
    localparam MAIN_GREEN_TIME = 5,
               STREET_GREEN_TIME = 3,
               YELLOW_TIME = 2;

    // Current and next state regsisters
    reg [1:0] curr_state, next_state;

    // Timer signals
    reg timer_elapsed = 0;
    reg [2:0] count;

    // Output reflects current FSM state
    assign out = curr_state;

    // State register
    // Updates the current state on every rising clock edge
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            curr_state <= GR;
        else
            curr_state <= next_state;
    end

    // Timer Logic
    // Counts clock cycles and asserts timer_elapsed
    // once the required duration for the current state expires
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            count <= 0;
            timer_elapsed <= 0;
        end
        else begin
            
            // Reset timer whenever FSM changes state
            if(next_state != curr_state) begin
                curr_state <= next_state;
                count <= 0;
                timer_elapsed <= 0;
            end

            // Continue counting until timer expires
            else if(!timer_elapsed) begin

                count <= count + 1;

                case(curr_state)

                    GR: if(count >= MAIN_GREEN_TIME)
                            timer_elapsed <= 1;

                    RG: if(count >= STREET_GREEN_TIME)
                            timer_elapsed <= 1;

                    RY, YR: if(count >= YELLOW_TIME)
                                timer_elapsed <= 1;

                 endcase
            end
        end
    end

    // Next state logic
    // Determines next state based on
    // current state, timer status and traffic request
    always @(*) begin

        next_state = curr_state;

        case(curr_state)

            // Main road green
            // Switch only if timer expires and
            // vehicle is waiting on the street 
            GR:
                if(in[0] && timer_elapsed)
                    next_state = YR;

            // Main road yellow
            YR: 
                if(timer_elapsed)
                    next_state = RG;

            // Street green
            RG:
                if(timer_elapsed)
                    next_state = RY;

            // Street yellow
            RY: 
                if(timer_elapsed)
                    next_state = GR;

            default: next_state = GR;
        endcase
    end
endmodule