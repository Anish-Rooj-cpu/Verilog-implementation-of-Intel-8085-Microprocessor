module register8(
    input clk,
    input rst,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge rst)
begin
    if(rst)
        q <= 8'h00;
    else if(load)
        q <= d;
end

endmodule