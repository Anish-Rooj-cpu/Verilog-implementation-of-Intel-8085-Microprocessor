module regReadMux(

input [7:0] A,
input [7:0] B,
input [7:0] C,
input [7:0] D,
input [7:0] E,
input [7:0] H,
input [7:0] L,

input [7:0] mem_data,     // M

input [2:0] sel,

output reg [7:0] data_out

);

always @(*) begin

case(sel)

3'b000: data_out = B;
3'b001: data_out = C;
3'b010: data_out = D;
3'b011: data_out = E;
3'b100: data_out = H;
3'b101: data_out = L;
3'b110: data_out = mem_data; // M
3'b111: data_out = A;

default: data_out = 8'h00;

endcase

end

endmodule