// Module      : Sequence Detector
// Type        : Moore FSM
// Function    : Detects non-overlapping sequences
//               0100 and 0010
module sequence_det(input clk, rstn, in, output out);
  
  // State encoding
  localparam IDLE	= 0,
  			 S0		= 1,
  			 S01 	= 2,
  			 S00 	= 3,
  			 S010 	= 4,
  			 S001 	= 5,
  			 S0100 	= 6,
  			 S0010 	= 7;
  
  reg [2:0] curr_state, next_state;
  
  // Moore output logic
  // Assert output when either sequence is detected
  assign out = (curr_state == S0100) || (curr_state == S0010);
  
  // State register
  // Updates current state on every rising edge of the clock
  always @(posedge clk or negedge rstn) begin
    if(!rstn)
      curr_state <= IDLE;
    else
      curr_state <= next_state;
  end
  
  // Next-state combinational logic
  always @(*) begin
    next_state = curr_state;
    
    case(curr_state)
      
      IDLE: begin
        if(in) next_state = IDLE;
        else next_state = S0;
      end
      
      S0: begin
        if(in) next_state = S01;
        else next_state = S00;
      end
      
      S01: begin
        if(in) next_state = IDLE;
        else next_state = S010;
      end
      
      S00: begin
        if(in) next_state = S001;
        else next_state = S00;
      end
      
      S010: begin
        if(in) next_state = S01;
        else next_state = S0100;
      end
      
      S001: begin
        if(in) next_state = IDLE;
        else next_state = S0010;
      end
      
      S0100: begin
        next_state = IDLE;
      end
      
      S0010: begin
        next_state = IDLE;
      end
      
      default : next_state = IDLE;
    endcase
  end
endmodule