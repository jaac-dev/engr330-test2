module cla #(
  parameter N_BLOCKS = 4
) (
  input logic [(N_BLOCKS * 4) - 1:0] a,
  input logic [(N_BLOCKS * 4) - 1:0] b,
  input logic c_in,
  output logic [(N_BLOCKS * 4) - 1:0] y,
  output logic c_out
);
  logic [N_BLOCKS:0] c; 
  assign c[0] = c_in;
  assign c_out = c[N_BLOCKS];
  
  // Generate the RCA blocks.
  genvar i;
  for (i = 0; i < N_BLOCKS; i++) begin : blocks
    // The base index for the inputs/outputs (a, b, y).
   	localparam int B = i * 4;  
    
  	// Generate the propagate and generate signals.
    logic [3:0] g;
    logic [3:0] p;
    
    assign p[3:0] = a[B +: 4] ^ b[B +: 4];
    assign g[3:0] = a[B +: 4] & b[B +: 4];
    
    // Generate the group propagate and carry signals.
    logic pg;
    logic gg;
    
    assign pg = p[0] & p[1] & p[2] & p[3];
    assign gg = g[3] | g[2] & p[3] | g[1] & p[3] & p[2] | g[0] & p[3] & p[2] & p[1];
    
    // Generate the next carry signal.
    assign c[i + 1] = gg | pg & c[i];
    
    // Instantiate an RCA instance.
    logic c_temp; // We don't care about the RCA's carry out.
    rca #(.N(4)) RCA(
      a[B +: 4], 
      b[B +: 4],
      c[i],
      y[B +: 4],
      c_temp
    );
  end
endmodule