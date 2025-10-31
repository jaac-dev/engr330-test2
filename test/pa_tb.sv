interface pa_bus #(parameter int N = 8) ();
  logic [N - 1:0] a, b, y;
  logic c_in, c_out;

  // Input for the testbench.
  modport test (output a, b, c_in, input y, c_out);
endinterface

module pa_tb #(parameter int N = 8) (pa_bus.test bus);
  // Task to run a test.
  task automatic run(logic [N - 1:0] a, logic [N - 1:0] b, logic c_in);
    // Calculate the expected value.
    logic [N:0] expected;
    expected = a + b + c_in;

    // Setup the test bench.
    bus.a = a;
    bus.b = b;
    bus.c_in = c_in; 

    #1; // Wait for logic.
    $display("PA Test (%0d bits): a = %0d, b = %0d, c_in = %0d, expected = %0d, result = %0d", N, bus.a, bus.b, bus.c_in, expected, {bus.c_out, bus.y});

    // Check the result.
    assert ({bus.c_out, bus.y} === expected)
    else $error(
      "PA Test Failed (%0d bits): a = %0d, b = %0d, c_in = %0d, expected = %0d, result = %0d",
      N,
      a, b, c_in,
      expected, bus.y
    );
                  
  endtask

  initial begin
    // Overflow cases.
    run('1, '1, '1);
    run('1, '0, '1);
    run('0, '1, '1);

    
  end
endmodule

module tb_pa ();
  localparam int N_WIDTHS = 4;
  localparam int WIDTHS[N_WIDTHS] = '{8, 16, 32, 64};

  genvar i;
  for (i = 0; i < N_WIDTHS; i++) begin : generated
    localparam int WIDTH = WIDTHS[i];

    pa_bus #(.N(WIDTH)) bus();
    
    pa #(.N(WIDTH)) pa_impl(
      .a(bus.a),
      .b(bus.b),
      .c_in(bus.c_in),
      .y(bus.y),
      .c_out(bus.c_out)
    );

    pa_tb #(.N(WIDTH)) pa_tb_impl(bus);
  end

  initial begin
    $display("Running tests...");
    #1000; // Run tests.
    $finish;
  end
endmodule