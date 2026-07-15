module sequence_det_tb;

    reg clk;
    reg rstn;
    reg in;
    wire out;

    integer i;
    reg [3:0] seq1 = 4'b0100;
    reg [3:0] seq2 = 4'b0010;

    // DUT
    sequence_det dut(
        .clk(clk),
        .rstn(rstn),
        .in(in),
        .out(out)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin

        // Waveform dump
      $dumpfile("sequence_det.vcd");
      $dumpvars(0, sequence_det_tb);

        clk  = 0;
        rstn = 0;
        in   = 0;

        // Apply Reset
        repeat(2) @(posedge clk);
        rstn = 1;

        // Test Case 1 : 0100
        $display("\nTesting Sequence : 0100");

        for(i = 3; i >= 0; i = i - 1) begin
            @(negedge clk);
            in = seq1[i];
        end

        repeat(2) @(posedge clk);

        // Test Case 2 : 0010
        $display("\nTesting Sequence : 0010");

        for(i = 3; i >= 0; i = i - 1) begin
            @(negedge clk);
            in = seq2[i];
        end

        repeat(2) @(posedge clk);

        // Invalid Sequence
        $display("\nTesting Invalid Sequence : 1110");

        in = 1;
        repeat(3) @(negedge clk) begin
            in = 1;
        end

        @(negedge clk);
        in = 0;

        repeat(2) @(posedge clk);

        // Random Stimulus
        $display("\nApplying Random Inputs");

        for(i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
            in = $random;
        end

        repeat(5) @(posedge clk);

        $finish;
    end

    initial begin
        $monitor("Time=%0t | in=%b | out=%b | state=%0d",
                  $time, in, out, dut.curr_state);
    end

endmodule