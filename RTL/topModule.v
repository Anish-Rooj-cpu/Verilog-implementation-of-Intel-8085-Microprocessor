`timescale 1ns/1ps

`include "register8.v"
`include "flag_register.v"
`include "programCounter.v"
`include "stackPointer.v"
`include "instructionRegister.v"
`include "alu.v"
`include "registerFile.v"
`include "decoder.v"
`include "CU.v"
`include "regReadMux.v"
`include "regWriteMux.v"
`include "aluControl.v"
`include "flagGen.v"

module cpu_8085(

input clk,
input rst,

input  [7:0] data_in,
output [7:0] data_out,
output [15:0] address,

output mem_rd,
output mem_wr
);


wire [7:0] opcode;
wire [7:0] alu_result;
wire [7:0] reg_read_data;
wire [7:0] writeback_data;

wire [7:0] A,B,C,D,E,H,L;
wire [15:0] BC,DE,HL;

wire [15:0] PC;
wire [15:0] SP;

wire [3:0] alu_op;

wire S,Z,P,AC,CY;
wire S_in,Z_in,P_in,AC_in,CY_in;


wire MOV,MVI,LXI;
wire ADD,ADC,SUB,SBB,ANA,XRA,ORA,CMP;
wire INR,DCR;
wire JMP,CALL,RET;
wire PUSH,POP;
wire NOP,HLT;

wire RLC,RRC,RAL,RAR,CMA;
wire STC,CMC,DAA;


wire [2:0] dst;
wire [2:0] src;

wire pc_inc;
wire pc_load;
wire ir_load;

wire reg_write;
wire alu_enable;
wire flag_write;

wire sp_inc;
wire sp_dec;

wire mem_read;
wire mem_write;

wire [2:0] state;

wire load_A,load_B,load_C,load_D,load_E,load_H,load_L;

assign writeback_data =
       (MOV) ? reg_read_data :
       (MVI) ? data_in :
       alu_result;


programCounter PC_REG(
.clk(clk),
.rst(rst),
.load(pc_load),
.inc(pc_inc),
.data_in(HL),
.pc(PC)
);


stackPointer SP_REG(
.clk(clk),
.rst(rst),
.load(1'b0),
.inc(sp_inc),
.dec(sp_dec),
.data_in(16'h0000),
.sp(SP)
);


instructionRegister IR(
.clk(clk),
.rst(rst),
.load(ir_load),
.data_in(data_in),
.instr(opcode)
);


decoder DEC(
.opcode(opcode),

.MOV(MOV),
.MVI(MVI),
.LXI(LXI),

.ADD(ADD),
.ADC(ADC),
.SUB(SUB),
.SBB(SBB),
.ANA(ANA),
.XRA(XRA),
.ORA(ORA),
.CMP(CMP),

.INR(INR),
.DCR(DCR),

.JMP(JMP),
.CALL(CALL),
.RET(RET),

.PUSH(PUSH),
.POP(POP),

.NOP(NOP),
.HLT(HLT),

.dst(dst),
.src(src),
.rp()
);


CU CONTROL(

.clk(clk),
.rst(rst),

.MOV(MOV),
.MVI(MVI),
.LXI(LXI),

.ADD(ADD),
.ADC(ADC),
.SUB(SUB),
.SBB(SBB),
.ANA(ANA),
.XRA(XRA),
.ORA(ORA),
.CMP(CMP),

.INR(INR),
.DCR(DCR),

.JMP(JMP),
.CALL(CALL),
.RET(RET),

.PUSH(PUSH),
.POP(POP),

.NOP(NOP),
.HLT(HLT),

.pc_inc(pc_inc),
.pc_load(pc_load),

.mem_read(mem_read),
.mem_write(mem_write),

.ir_load(ir_load),

.reg_write(reg_write),

.alu_enable(alu_enable),
.flag_write(flag_write),

.sp_inc(sp_inc),
.sp_dec(sp_dec),

.state(state)
);

assign mem_rd = mem_read;
assign mem_wr = mem_write;

registerFile REGFILE(

.clk(clk),
.rst(rst),

.load_A(load_A),
.load_B(load_B),
.load_C(load_C),
.load_D(load_D),
.load_E(load_E),
.load_H(load_H),
.load_L(load_L),

.data_in(writeback_data),

.A(A),
.B(B),
.C(C),
.D(D),
.E(E),
.H(H),
.L(L),

.BC(BC),
.DE(DE),
.HL(HL)
);

wire [2:0] alu_src = (INR | DCR) ? dst : src;
regReadMux READMUX(

.A(A),
.B(B),
.C(C),
.D(D),
.E(E),
.H(H),
.L(L),

.mem_data(data_in),
.sel(alu_src),
.data_out(reg_read_data)
);

wire ALU_A = ADD|ADC|SUB|SBB|ANA|XRA|ORA|CMP;
regWriteMux WRITEMUX(

.clk(clk),
.rst(rst),
.write_enable(reg_write & ~CMP),

  .dst( ALU_A ? 3'b111 : dst ),

.data_in(writeback_data),

.load_A(load_A),
.load_B(load_B),
.load_C(load_C),
.load_D(load_D),
.load_E(load_E),
.load_H(load_H),
.load_L(load_L)
);

aluControl ALUCTRL(

.ADD(ADD),
.ADC(ADC),
.SUB(SUB),
.SBB(SBB),
.ANA(ANA),
.XRA(XRA),
.ORA(ORA),
.CMP(CMP),

.INR(INR),
.DCR(DCR),

.RLC(RLC),
.RRC(RRC),
.RAL(RAL),
.RAR(RAR),

.CMA(CMA),
.STC(1'b0),
.CMC(1'b0),
.DAA(1'b0),

.alu_op(alu_op)
);

alu ALU(

.A(A),
.B(reg_read_data),
.CY(CY),

.alu_op(alu_op),

.result(alu_result),
.carry(CY_in)
);


flagGen FLAGGEN(

.A(A),
.B(reg_read_data),
.result(alu_result),

.carry_in(CY),
.carry_out(CY_in),

.alu_op(alu_op),

.S(S_in),
.Z(Z_in),
.P(P_in),
.AC(AC_in),
.CY(CY_in)
);


flag_register FLAGS(

.clk(clk),
.rst(rst),
.load(flag_write),

.S_in(S_in),
.Z_in(Z_in),
.AC_in(AC_in),
.P_in(P_in),
.CY_in(CY_in),

.S(S),
.Z(Z),
.AC(AC),
.P(P),
.CY(CY)
);

assign address = PC;
assign data_out = (mem_write) ? writeback_data : 8'hZZ;

endmodule