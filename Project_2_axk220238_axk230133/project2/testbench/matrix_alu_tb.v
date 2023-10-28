// testbench (matrix_alu_tb) for testing a matrix arithmetic logic unit (Matrix ALU) //
// Initialize parameters, clock and reset signals, input matrices A and B, and the   //
// operation code (op), and then connects these signals to the Matrix ALU module.    //
// It toggles the clock signal, simulates a reset sequence, and then performs a      //
// sequence of operations on matrices A and B. The output result is captured in the  //
// signal C                                                                          //

module matrix_alu_tb();

// Parameter Definitions //
parameter word_size = 32; // Word size for matrix elements //
parameter Amatrixrownum = 2;
parameter Amatrixcolnum = 2;
parameter Bmatrixrownum = 2;
parameter Bmatrixcolnum = 2;

// Signal Declarations //
reg     clk, resetn;
reg     [(Amatrixcolnum * Amatrixrownum) * word_size - 1 : 0] A, B;
reg     [1:0] op;
wire    [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0] C;
wire    [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0] C_net;

// Clock Generation //
always #10 clk = ~clk;
initial begin
clk = 1'b0;
resetn = 1'b1;
#20
resetn = 1'b0;
#20
resetn = 1'b1;
end

//Initial Block for Matrix and Operation Initialization //
initial begin
A={8'h01,8'h02,8'h03,8'h00};
B={8'h05,8'h06,8'h07,8'h08};

op = 2'b00;
#100
op = 2'b01;
#100
op = 2'b10;
#100
op = 2'b11;
end

// Module Instantiation //
matrix_alu #(.word_size(word_size),
             .Amatrixrownum(Amatrixrownum),
             .Amatrixcolnum(Amatrixcolnum),
             .Bmatrixrownum(Bmatrixrownum),
             .Bmatrixcolnum(Bmatrixcolnum)) alu (
.clk(clk),
.resetn(resetn),                    
.A(A),
.B(B),
.op(op),
.C(C) 
);
matrix_alu_mapped alu_netlist (
.clk(clk),
.resetn(resetn),
.A(A),
.B(B),
.op(op),
.C(C_net)
);
endmodule