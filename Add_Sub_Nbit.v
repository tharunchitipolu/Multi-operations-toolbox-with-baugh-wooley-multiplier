// Add Subtract N bit RCA
// Y = A + S XOR B + s

module Add_Sub_Nbit #(parameter N = 4)(A,B,s,Y);

input [N-1:0]A,B;
input s;
output [N:0]Y;

wire [N+1:0]C;

wire [N:0] A1,B1;
wire [N:0] xB;

assign A1 = {A[N-1],A};
assign B1 = {B[N-1],B};

assign xB = s?~B1:B1; 

assign C[0] = s;

genvar i;

generate

for(i = 0;i<N+1;i = i+1) begin: FA_loop

full_adder FA_ (.A(A1[i]), .B(xB[i]), .Cin(C[i]), .Sum(Y[i]), .Cout(C[i+1]));
end

endgenerate


endmodule
