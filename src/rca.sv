module rca #(
  parameter N = 4
) (
  input logic [N - 1:0] a,
  input logic [N - 1:0] b,
  input logic c_in,
  output logic [N - 1:0] y,
  output logic c_out
);
  logic [N:0] c; // Stores the N different carry signals. 
  assign c[0] = c_in; // Set the first carry signal as our carry in.
  assign c_out = c[N]; // Set the carry out as the last carry signal.
  
  // Generate the different units.
  genvar i;
  for (i = 0; i < N; i++) begin : blocks
    logic p;
    assign p = a[i] ^ b[i]; // The "propogate" signal.
    assign y[i] = p ^ c[i]; // The output bit.
    assign c[i + 1] = (p & c[i]) | (a[i] & b[i]); // The carry bit.
  end
endmodule