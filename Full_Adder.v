// Designing Full Adder
// Sum = A xor B xor Cin;   Cout = (A and B) or (B and Cin) or (Cin and A)

module full_adder(A, B, Cin, Sum, Cout) ;

input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = (A & B)|(B & Cin)|(Cin & A);

endmodule
