// Module    : Vending Machine Controller
// Type      : Moore FSM
// Function  : Controls product selection, payment validation,
//             change calculation, and product dispensing while
//             handling insufficient balance conditions.
module vending_machine(
    input clk, rstn,                
    input [2:0] five, ten,          // Number of $5 and $10 inserted
    input [1:0] select,             // 01: Chocolate, 10: Biscuit, 11: Both 
    output dispense,                // Goes high when product is dispensed
    output reg insufficient_balance,// Indicates insufficient money
    output reg [6:0] change);       // Remaining change after purchase

    // FSM States
    localparam  IDLE        = 0,
                CHOCOLATE   = 1,
                BISCUIT     = 2,
                CHOCO_AND_BISCUIT = 3,
                ACCEPT      = 4;

    // State and combinational variables
    reg [2:0] curr_state, next_state;
    reg [6:0] next_change;
    reg [6:0] amount;

    // Dispense output is asserted only in ACCEPT state
    assign dispense = (curr_state == ACCEPT);

    // State Register
    // Updates the current state on every clock edge
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            curr_state <= IDLE;
        else
            curr_state <= next_state;
    end

    // Output Register
    // Stores change when transaction is accepted and clears it after dispensing
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            change <= 0;
        end
        else if(next_state == ACCEPT) begin
            change <= next_change;
        end
        else if(curr_state == ACCEPT) begin
            change <= 0;
        end
    end

    // Next-State & Output Logic
    // Determines state transitions, change calculation and insufficient balance indication
    always @(*) begin
        next_state = curr_state;
        next_change = change;
        insufficient_balance = 0;

        // Calculate total inserted amount
        amount = five*5 + ten*10;

        case(curr_state)

            // Wait for product selection
            IDLE: begin
                next_change = 0;
                case(select)
                    2'b01: next_state = CHOCOLATE;
                    2'b10: next_state = BISCUIT;
                    2'b11: next_state = CHOCO_AND_BISCUIT;
                    default: next_state = IDLE;
                endcase
            end

            // Chocolate : $20
            CHOCOLATE: begin
                if(amount >= 20) begin
                    next_state = ACCEPT;
                    next_change = amount - 20;
                end
                else begin
                    insufficient_balance = 1'b1;
                    next_state = CHOCOLATE;
                end
            end

            // Biscuit : $15
            BISCUIT: begin
                if(amount >= 15) begin
                    next_state = ACCEPT;
                    next_change = amount - 15;
                end
                else begin
                    next_state = BISCUIT;
                    insufficient_balance = 1'b1;
                end
            end

            // Chocolate + Biscuit : $35
            CHOCO_AND_BISCUIT: begin
                if(amount >= 35) begin
                    next_state = ACCEPT;
                    next_change = amount - 35;
                end
                else begin
                    next_state = CHOCO_AND_BISCUIT;
                    insufficient_balance = 1'b1;
                end
            end

            // Dispense product and return to IDLE
            ACCEPT: begin
                next_state = IDLE;
                insufficient_balance = 1'b0;
            end

            // Recover from invalid state
            default: begin
                next_state = IDLE;
                insufficient_balance = 1'b0;
            end

        endcase
    end
endmodule