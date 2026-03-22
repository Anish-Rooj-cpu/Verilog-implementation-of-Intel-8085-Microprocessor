module regWriteMux(

input clk,
input rst,
input write_enable,

input [2:0] dst,
input [7:0] data_in,

output reg load_A,
output reg load_B,
output reg load_C,
output reg load_D,
output reg load_E,
output reg load_H,
output reg load_L

);

always @(*) begin

load_A=0;
load_B=0;
load_C=0;
load_D=0;
load_E=0;
load_H=0;
load_L=0;

if(write_enable) begin

case(dst)

3'b000: load_B = 1;
3'b001: load_C = 1;
3'b010: load_D = 1;
3'b011: load_E = 1;
3'b100: load_H = 1;
3'b101: load_L = 1;

3'b110: begin

end

3'b111: load_A = 1;

endcase

end

end

endmodule