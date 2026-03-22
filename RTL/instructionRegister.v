module instructionRegister(
    input clk, rst, load,
    input [7:0] data_in,
    output reg [7:0] instr
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            instr <= 8'h00; 
        else if (load) 
            instr <= data_in;
    end
endmodule