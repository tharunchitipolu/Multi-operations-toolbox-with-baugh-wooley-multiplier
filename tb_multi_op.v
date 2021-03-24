// TestBench for Multi_op


module tb_multi_op();

parameter M = 64; 
parameter N = 64;

reg [N-1:0]a;
reg [M-1:0]b;
reg [N+M+1:0]c;
reg sw0,sw1;
wire [N+M+1:0]Out;


multi_op #(64,64) UUT(.A(a),.B(b),.C(c),.S0(sw0),.S1(sw1),.Y(Out));


initial 
repeat(20)
begin

#100

a = $random; b = $random; c[N-1:0] = $random;  c[N+M+1:N] = {M+2{c[N-1]}};sw0 = $random; sw1 = $random;

#100
//-----VERIFICATION OF THE OBTAINED RESULT WITH EXISTING RESULT------

if(sw0 == 1'b0 & sw1 == 1'b0)
begin
$display(" A=%d, B=%d, C=%d, S0=%d, S1=%d, Output=%d",$signed(a),$signed(b),$signed(c),$unsigned(sw0),$unsigned(sw1),$signed(Out));
if( $signed(a)+$signed(b) != $signed(Out)) // logic verification.
$display(" *ERROR* ");
end

else if(sw0 == 1'b1 & sw1 == 1'b0)
begin
$display(" A=%d, B=%d, C=%d, S0=%d, S1=%d, Output=%d",$signed(a),$signed(b),$signed(c),$unsigned(sw0),$unsigned(sw1),$signed(Out));
if( $signed(a)-$signed(b) != $signed(Out)) // logic verification.
$display(" *ERROR* ");
end

else if(sw0 == 1'b0 & sw1 == 1'b1)
begin
$display(" A=%d, B=%d, C=%d, S0=%d, S1=%d, Output=%d",$signed(a),$signed(b),$signed(c),$unsigned(sw0),$unsigned(sw1),$signed(Out));
if( $signed(a)*$signed(b) != $signed(Out)) // logic verification.
$display(" *ERROR* ");
end

else if(sw0 == 1'b1 & sw1 == 1'b1)
begin
$display(" A=%d, B=%d, C=%d, S0=%d, S1=%d, Output=%d",$signed(a),$signed(b),$signed(c),$unsigned(sw0),$unsigned(sw1),$signed(Out));
if( ($signed(a)*$signed(b))+$signed(c) != $signed(Out)) // logic verification.
$display(" *ERROR* ");
end

end


endmodule
