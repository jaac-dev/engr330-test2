module rca #(
  parameter N = 4
) (
  input logic [N - 1:0] a,
  input logic [N - 1:0] b,
  input logic c_in,
  output logic [N - 1:0] y,
  output logic c_out
);
endmodule