module decoder(
    input [7:0] opcode,
    output reg MOV,
    output reg MVI,
    output reg LXI,
    output reg ADD,
    output reg ADC,
    output reg SUB,
    output reg SBB,
    output reg ANA,
    output reg XRA,
    output reg ORA,
    output reg CMP,
    output reg INR,
    output reg DCR,
    output reg JMP,
    output reg CALL,
    output reg RET,
    output reg PUSH,
    output reg POP,
    output reg NOP,
    output reg HLT,
    output reg [2:0] dst,
    output reg [2:0] src,
    output reg [1:0] rp
);

always @(*) begin
    MOV=0; MVI=0; LXI=0;
    ADD=0; ADC=0; SUB=0; SBB=0;
    ANA=0; XRA=0; ORA=0; CMP=0;
    INR=0; DCR=0;
    JMP=0; CALL=0; RET=0;
    PUSH=0; POP=0;
    NOP=0; HLT=0;
    dst = opcode[5:3]; 
    src = opcode[2:0]; 
    rp  = opcode[5:4]; 
    if (opcode == 8'h00) NOP = 1;
    else if (opcode == 8'h76) HLT = 1;
    else if (opcode[7:6] == 2'b01) begin
        MOV = 1;
    end
    else if (opcode[7:6] == 2'b00) begin
        // MVI : 00 DDD 110
        if (opcode[2:0] == 3'b110)
            MVI = 1;
        // LXI : 00 RP 0001
        else if (opcode[3:0] == 4'b0001)
            LXI = 1;
        // INR : 00 DDD 100
        else if (opcode[2:0] == 3'b100)
            INR = 1;
        // DCR : 00 DDD 101
        else if (opcode[2:0] == 3'b101)
            DCR = 1;
    end
    else if (opcode[7:6] == 2'b10) begin
        case(opcode[5:3])
            3'b000: ADD = 1;
            3'b001: ADC = 1;
            3'b010: SUB = 1;
            3'b011: SBB = 1;
            3'b100: ANA = 1;
            3'b101: XRA = 1;
            3'b110: ORA = 1;
            3'b111: CMP = 1;
        endcase
    end
    else if (opcode[7:6] == 2'b11) begin
        // JMP : C3h (11 000 011)
        if (opcode == 8'hC3) JMP = 1;
        // CALL : CDh (11 001 101)
        else if (opcode == 8'hCD) CALL = 1;
        // RET : C9h (11 001 001)
        else if (opcode == 8'hC9) RET = 1;
        
        // PUSH : 11 RP 0101
        else if (opcode[3:0] == 4'b0101) PUSH = 1;
        // POP  : 11 RP 0001
        else if (opcode[3:0] == 4'b0001) POP = 1;
    end
end

endmodule