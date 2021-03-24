//circuit with two selection lines s1 and s0 to perform the A+B,A-B,A*B,C+A*B operations inputs and outputs are A, B, C and Y respectively. 
//The selection lines s1 and s0 are single bit lines and whereas the inputs are 64 bit format.



module multi_op #(parameter N = 64 , M = 64)(A,B,C,S0,S1,Y);
input [N-1:0]A;
input [M-1:0]B;
input [N+M+1:0]C;
input S0,S1;
output signed[M+N+1:0]Y;






// Add Sub N bit, when S0 = 0, S1 = 0 the output is A+B
// when S0 = 1, S1 = 0 output is A-B


wire [N:0]Add_Sub_Out; 
wire [N+1:0]Car;

// extension of a msb for signed bit as its a 2's complement
wire [N:0] A1,B1;
wire [N:0] xB;


assign A1 = {A[N-1],A};
assign B1 = {B[N-1],B};

//xor operation of B and S0
assign xB = S0?~B1:B1; 

assign Car[0] = S0;

genvar i;

generate

for(i = 0;i<N+1;i = i+1) begin: FA_loop

full_adder FA_ (.A(A1[i]), .B(xB[i]), .Cin(Car[i]), .Sum(Add_Sub_Out[i]), .Cout(Car[i+1]));
end


endgenerate



// Signed Multiplication (baugh wooley) of A and B, if S0= 0, S1 = 1 the output is A*B

wire [M+N-1:0]Mul_Out; 

// Declare partial products terms, Total partial products are M
wire [N-1:0]P[0:M-1]; // Bits-size of each partial product is N-bits
wire [N-1:0]S[0:M-1]; // 

// Generate partial products 

genvar j;
generate

    for(j=0;j<M-1;j=j+1)
    begin:partial_products_gen
    	assign P[j] = B[j] ? {~A[N-1],A[N-2:0]}:{1'b1,{(N-1){1'b0}}};
    end
endgenerate
assign P[M-1] = B[M-1]?{A[N-1],~(A[N-2:0])}:{1'b0,{(N-1){1'b1}}};

// Add partial products 
    assign {S[0], Mul_Out[0]} = {1'b1, P[0]}; 



generate 
genvar k; 
	for(k = 0; k < M-1; k = k + 1)
	begin: Add_partial_products
		assign {S[k+1], Mul_Out[k+1]} = P[k+1] + S[k]; 
	end
endgenerate



wire t; //used store the MSB bit of the result

wire [N+M-1:M]Q; //To store the intermediate result

assign Q[N+M-1:M] = S[M-1];
assign t = ~Q[N+M-1]; // xor operation of MSB and sign selection bit
assign Mul_Out[N+M-1:M] = {t,Q[N+M-2:M]};





// Y =  ~S1 (A +(-1)^S0*B) +  S1 ( C S0 + (A*B))
//further simplifying the above equation we csn implement the code as below.

wire [N+M+1:0]zeros = 0;
wire [N+M+1:0]temp_sum;
wire [N+M+1:0]extend_mul_out = {{2{Mul_Out[N+M-1]}},Mul_Out};
wire [N+M+1:0]final_add_sub =  S1?zeros:{{M+1{Add_Sub_Out[N]}},Add_Sub_Out};
wire [N+M+1:0]final_C = (S0&S1)?C:zeros;
wire [N+M+1:0]final_mul = S1?extend_mul_out:zeros;

Add_Sub_Nbit  #(.N(N+M+2)) AS1(.A(final_add_sub),.B(final_C),.s(0),.Y(temp_sum));
Add_Sub_Nbit  #(.N(N+M+2)) AS2(.A(temp_sum),.B(final_mul),.s(0),.Y(Y));


endmodule
