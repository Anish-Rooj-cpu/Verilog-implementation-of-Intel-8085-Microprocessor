module programCounter(
    input clk,
    input rst,
    input load,
    input inc,
    input [15:0] data_in,
    output reg [15:0] pc
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        pc <= 16'h0000;

    else begin
        case({load,inc})

        2'b10: pc <= data_in;     
        2'b01: pc <= pc + 1;      
        2'b11: pc <= data_in;     
        default: pc <= pc;

        endcase
    end
end

endmodule