module BlackBoxMulUInt8(
	               input wire [7:0] I0,
	               input wire [7:0] I1,
	               output wire [15:0] O,
	               input wire       clock
	               );
`ifdef VERILATOR
   reg [15:0] reg0;
   reg [15:0] reg1;
   reg [15:0] reg2;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
   end
   assign O = reg2;
`endif
`ifndef VERILATOR
   mul_uint8 mul_uint8 (
                   .A(I0),
                   .B(I1),
                   .P(O),
                   .CLK(clock)
                   );
`endif
endmodule

module BlackBoxMulInt8(
	                      input wire signed [7:0] I0,
	                      input wire signed [7:0] I1,
	                      output wire signed [15:0] O,
	                      input wire       clock
	                      );
`ifdef VERILATOR
   reg signed [15:0] reg0;
   reg signed [15:0] reg1;
   reg signed [15:0] reg2;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
   end
   assign O = reg2;
`endif
`ifndef VERILATOR
   mul_int8 mul_int8 (
                     .A(I0),
                     .B(I1),
                     .P(O),
                     .CLK(clock)
                     );
`endif
endmodule

module BlackBoxMulUInt16(
	               input wire [15:0] I0,
	               input wire [15:0] I1,
	               output wire [31:0] O,
	               input wire       clock
	               );
`ifdef VERILATOR
   reg [31:0] reg0;
   reg [31:0] reg1;
   reg [31:0] reg2;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
   end
   assign O = reg2;
`endif
`ifndef VERILATOR
   mul_uint16 mul_uint16 (
                   .A(I0),
                   .B(I1),
                   .P(O),
                   .CLK(clock)
                   );
`endif
endmodule

module BlackBoxMulInt16(
	                      input wire signed [15:0] I0,
	                      input wire signed [15:0] I1,
	                      output wire signed [31:0] O,
	                      input wire       clock
	                      );
`ifdef VERILATOR
   reg signed [31:0] reg0;
   reg signed [31:0] reg1;
   reg signed [31:0] reg2;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
   end
   assign O = reg2;
`endif
`ifndef VERILATOR
   mul_int16 mul_int16 (
                     .A(I0),
                     .B(I1),
                     .P(O),
                     .CLK(clock)
                     );
`endif
endmodule

module BlackBoxMulUInt32(
	               input wire [31:0] I0,
	               input wire [31:0] I1,
	               output wire [63:0] O,
	               input wire       clock
	               );
`ifdef VERILATOR
   reg [63:0] reg0;
   reg [63:0] reg1;
   reg [63:0] reg2;
   reg [63:0] reg3;
   reg [63:0] reg4;
   reg [63:0] reg5;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
      reg3 <= reg2;
      reg4 <= reg3;
      reg5 <= reg4;
   end
   assign O = reg5;
`endif
`ifndef VERILATOR
   mul_uint32 mul_uint32 (
                   .A(I0),
                   .B(I1),
                   .P(O),
                   .CLK(clock)
                   );
`endif
endmodule

module BlackBoxMulInt32(
	                      input wire signed [31:0] I0,
	                      input wire signed [31:0] I1,
	                      output wire signed [63:0] O,
	                      input wire       clock
	                      );
`ifdef VERILATOR
   reg signed [63:0] reg0;
   reg signed [63:0] reg1;
   reg signed [63:0] reg2;
   reg signed [63:0] reg3;
   reg signed [63:0] reg4;
   reg signed [63:0] reg5;
   always @( posedge clock ) begin
      reg0 <= I0 * I1;
      reg1 <= reg0;
      reg2 <= reg1;
      reg3 <= reg2;
      reg4 <= reg3;
      reg5 <= reg4;
   end
   assign O = reg5;
`endif
`ifndef VERILATOR
   mul_int32 mul_int32 (
                     .A(I0),
                     .B(I1),
                     .P(O),
                     .CLK(clock)
                     );
`endif
endmodule
