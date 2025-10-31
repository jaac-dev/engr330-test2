module pa #(
  parameter N = 4
) (
  input logic [N - 1:0] a,
  input logic [N - 1:0] b,
  input logic c_in,
  output logic [N - 1:0] y,
  output logic c_out
);
  // We'll need log2(N) stages. 
  localparam int N_STAGES = $clog2(N);
  
  // Each stage has N + 1 bits. The -1 position is 0.
  logic [N:0] p [0:N_STAGES];
  logic [N:0] g [0:N_STAGES];
  
  // The -1 p and g signals.
  assign p[0][0] = 1'd1;
  assign g[0][0] = c_in; 
  
  // Generate P and G for inputs for stage 1.
  generate
    genvar i;
    for (i = 0; i < N; i++) begin : init
      assign p[0][i + 1] = a[i] ^ b[i];
      assign g[0][i + 1] = a[i] & b[i];
    end
  endgenerate
  
  // Truthfully, I couldn't figure out how to do this from the diagram in the presentation.
  // I referenced this: https://elnndccpro.wordpress.com/2017/01/25/a-design-of-kogge-stone-adder-8-bit/
  // That made much more sense to me.
  generate
    genvar s;
    for (s = 1; s <= N_STAGES; s++) begin : prefix
      localparam int D = 1 << (s - 1);

      for (i = 0; i <= N; i++) begin : inner
        if (i >= D) begin // Handle combining with previous stages D away.
          assign g[s][i] = g[s - 1][i] | (p[s - 1][i] & g[s - 1][i - D]);
          assign p[s][i] = p[s - 1][i] & p[s - 1][i - D];
        end else begin // Passthrough.
          assign g[s][i] = g[s - 1][i]; 
          assign p[s][i] = p[s - 1][i]; 
        end
      end
    end
  endgenerate
  
  // Calculate the carries.
  logic [N:0] c;
  assign c[0] = c_in;
  
  generate
    for (i = 0; i < N; i++) begin : carries
      assign c[i + 1] = g[N_STAGES][i + 1] | (p[N_STAGES][i + 1] & c_in);
    end
  endgenerate
  
  // Calculate the sums.
  generate
    for (i = 0; i < N; i++) begin : sums
      assign y[i] = p[0][i + 1] ^ c[i];
    end
  endgenerate
  
  assign c_out = c[N];
endmodule