`timescale 1ns/1ps

module tb_cpu_8085;

reg clk;
reg rst;

wire [15:0] address;
wire [7:0] data_out;
wire [7:0] data_in;
wire mem_rd;
wire mem_wr;

/* CPU */

cpu_8085 DUT(
.clk(clk),
.rst(rst),
.data_in(data_in),
.data_out(data_out),
.address(address),
.mem_rd(mem_rd),
.mem_wr(mem_wr)
);

/* memory */

reg [7:0] memory [0:65535];

initial begin
    $readmemh("test_program.hex", memory);
end

assign data_in = (mem_rd) ? memory[address] : 8'hZZ;

always @(posedge clk)
if(mem_wr)
memory[address] <= data_out;

/* clock */

initial begin
clk=0;
forever #5 clk=~clk;
end

/* reset */

initial begin
rst=1;
#20;
rst=0;
end

/* monitor */

initial begin
$display("Time PC Opcode A B C D");
$monitor("%0t %h %h %h %h %h %h",
$time,
DUT.PC,
DUT.opcode,
DUT.A,
DUT.B,
DUT.C,
DUT.D
);
end

/* stop */

initial begin
#2000;
$finish;
end

endmodule