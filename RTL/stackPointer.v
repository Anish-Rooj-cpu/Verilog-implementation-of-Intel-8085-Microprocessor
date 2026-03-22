module stackPointer(
    input clk,
    input rst,
    input load,
    input inc,
    input dec,
    input [15:0] data_in,
    output reg [15:0] sp
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        sp <= 16'hFFFF;

    else begin
        case({load,inc,dec})

        3'b100: sp <= data_in;      
        3'b010: sp <= sp + 1;       
        3'b001: sp <= sp - 1;       
        3'b011: sp <= sp;           
        3'b110: sp <= data_in;
        3'b101: sp <= data_in;

        default: sp <= sp;

        endcase
    end
end

endmodule