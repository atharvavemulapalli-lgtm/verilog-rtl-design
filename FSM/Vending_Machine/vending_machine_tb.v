// Module    : Vending Machine Testbench
// Type      : Verification Testbench
// Function  : Verifies product selection, payment validation,
//             change calculation, insufficient balance handling,
//             and dispensing functionality of the vending machine FSM.
module vending_machine_tb;

    // Testbench Signals
    reg clk, rstn;
    reg [2:0] five, ten;
    reg [1:0] select;
    wire dispense, insufficient_balance;
    wire [6:0] change;

    // Instantiate Design Under Test (DUT)
    vending_machine dut(.clk(clk), .rstn(rstn), .five(five), .ten(ten), .select(select), .dispense(dispense), .insufficient_balance(insufficient_balance), .change(change));

    // Generate a clock with 10-time-unit period
    always #5 clk = ~clk;

    initial begin

        // Generate waveform dump for GTKWave
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, vending_machine_tb);

        // Initialize all inputs
        clk = 0;
        rstn = 0;
        five = 3'b000;
        ten = 3'b000;
        select = 2'b00;

        repeat(1) @(posedge clk)
        rstn = 1;

        // Test Case 1: Chocolate with Exact Payment
        $display("\nChocolate - Exact amount");
        @(negedge clk) begin
            five = 0;
            ten = 2;
            select = 2'b01;
        end

        repeat(3) @(posedge clk);

        // Test Case 2: Chocolate with Extra Payment
        $display("\nChocolate - Extra amount");
        @(negedge clk) begin
            five = 1;
            ten = 2;
            select = 2'b01;
        end

        repeat(3) @(posedge clk);

        // Test Case 3: Biscuit with Exact Payment
        $display("\nBiscuit - Exact amount");
        @(negedge clk) begin
            five = 1;
            ten = 1;
            select = 2'b10;
        end

        repeat(3) @(posedge clk);

        // Test Case 4: Biscuit with Excess Payment
        $display("\nBiscuit - Extra amount");
        @(negedge clk) begin
            five = 1;
            ten = 2;
            select = 2'b10;
        end

        repeat(3) @(posedge clk);

        // Test Case 5: Chocolate and Biscuit
        $display("\nChocolate + Biscuit");
        @(negedge clk) begin
            five = 1;
            ten = 3;
            select = 2'b11;
        end

        repeat(3) @(posedge clk);

        // Test Case 6: Insufficient Balance followed by Exact Payment
        $display("\nInsufficient Balance -> Add More Money");
        @(negedge clk) begin
            five = 1;
            ten = 1;
            select = 2'b01;
        end

        repeat(3) @(posedge clk);

        @(negedge clk) begin
            five = 2;
            ten = 1;
            select = 2'b01;
        end

        repeat(2) @(posedge clk);

        // Test Case 7: Insufficient Balance followed by Excess Payment
        $display("\nInsufficient Balance -> Add More Money(with change)");
        @(negedge clk) begin
            five = 1;
            ten = 1;
            select = 2'b01;
        end

        repeat(3) @(posedge clk);

        @(negedge clk) begin
            five = 2;
            ten = 2;
            select = 2'b01;
        end

        repeat(2) @(posedge clk);

        // Test Case 8: Invalid Product Selection
        $display("\nInvalid Selection");
        @(negedge clk) begin
            five = 0;
            ten = 0;
            select = 2'b00;
        end

        repeat(2) @(posedge clk);

        // End Simulation
        $finish;
    end

    // Monitor input and output signals during simulation
    initial begin
        $monitor("time = %0t | five = %0d | ten = %0d | select = %b | dispense = %b | insufficient = %b | change = %0d", $time, five, ten, select, dispense, insufficient_balance, change);
    end
endmodule