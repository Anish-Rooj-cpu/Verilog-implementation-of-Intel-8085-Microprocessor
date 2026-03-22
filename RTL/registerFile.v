`timescale 1ns/1ps
module registerFile(
    input clk,
    input rst,

    input load_A,
    input load_B,
    input load_C,
    input load_D,
    input load_E,
    input load_H,
    input load_L,

    input [7:0] data_in,

    output [7:0] A,
    output [7:0] B,
    output [7:0] C,
    output [7:0] D,
    output [7:0] E,
    output [7:0] H,
    output [7:0] L,

    output [15:0] BC,
    output [15:0] DE,
    output [15:0] HL
);

/* ================= */
/* registers */
/* ================= */

register8 regA(clk,rst,load_A,data_in,A);
register8 regB(clk,rst,load_B,data_in,B);
register8 regC(clk,rst,load_C,data_in,C);
register8 regD(clk,rst,load_D,data_in,D);
register8 regE(clk,rst,load_E,data_in,E);
register8 regH(clk,rst,load_H,data_in,H);
register8 regL(clk,rst,load_L,data_in,L);

/* ================= */
/* register pairs */
/* ================= */

assign BC = {B,C};
assign DE = {D,E};
assign HL = {H,L};

endmodule