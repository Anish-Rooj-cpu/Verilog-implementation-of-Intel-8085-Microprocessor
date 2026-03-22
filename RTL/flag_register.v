module flag_register(

input clk,
input rst,
input load,

input S_in,
input Z_in,
input AC_in,
input P_in,
input CY_in,

output reg S,
output reg Z,
output reg AC,
output reg P,
output reg CY

);

always @(posedge clk or posedge rst)
begin
if(rst)
begin
S<=0;
Z<=0;
AC<=0;
P<=0;
CY<=0;
end
else if(load)
begin
S  <= S_in;
Z  <= Z_in;
AC <= AC_in;
P  <= P_in;
CY <= CY_in;
end
end

endmodule