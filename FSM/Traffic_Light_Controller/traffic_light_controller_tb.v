// Module    : Traffic Light Controller Testbench
// Type      : Simulation Testbench
// Function  : Verifies timer-based state transitions
//             for the Traffic Light Controller.
module traffic_light_tb;

    // Testbench signals
    reg clk, rstn;
    reg [1:0] in;
    wire [1:0] out;

    // Instantiate Device Under Test (DUT)
    traffic_light dut(.clk(clk), .rstn(rstn), .in(in), .out(out));
    
    integer i;

    // Generate 100 MHz clock (10 time-unit period)
    always #5 clk = ~clk;

    initial begin
        
        // Create VCD dumpfile for GTKWave
        $dumpfile("traffic_light_control.vcd");
        $dumpvars(0, traffic_light_tb);

        // Initialize inputs
        clk = 0;
        rstn = 0;
        in = 2'b00;

        // Apply reset
        repeat (2) @(posedge clk);
        rstn = 1;
        
        // Test 1 : Main road vehicle only
        $display("\nTest 1: Main road vehicle only");
        @(negedge clk);
            in = 2'b10;

        repeat(5) @(posedge clk);

        // Test 2 : Side street vehicle only
        $display("\nTest 2: Side street vehicle only");
        @(negedge clk)
            in = 2'b01;

        repeat(5) @(posedge clk);

        // Test 3 : Applying random trafic requests
        $display("\nTest 3: Random traffic requests");

        for(i = 0; i < 10; i = i + 1) begin
            @(negedge clk);
            in = $random;
        end

        // Wait before ending simulation
        repeat(10) @(posedge clk);

        $finish;
    end

    // Monitor internal DUT signals during simulation
    initial begin
        $monitor("Time = %0t | in = %b | out = %b | state = %0d | count = %0d | timer_elapsed = %b", $time, in, out, dut.curr_state, dut.count, dut.timer_elapsed);
    end

endmodule