// Module Description:                                                            //
// The Matrix ALU (Arithmetic Logic Unit) performs various matrix operations      //
// based on the specified op code and produces the result in the signal C.        //
// Note: Both Amatrixrownum and Bmatrixrownum and Amatrixcolnum and Bmatrixcolnum //
// must be equal respectively, for valid operations.                              //

module matrix_alu #(parameter word_size = 8, // Word size for matrix elements //
                    parameter Amatrixrownum = 2, // Number of rows in matrix A //
                    parameter Amatrixcolnum = 2, // Number of columns in matrix A //
                    parameter Bmatrixrownum = 2, // Number of rows in matrix B //
                    parameter Bmatrixcolnum = 2)( // Number of columns in matrix B //
input   wire        clk, // Clock input //
input   wire        resetn, // Reset signal (active low) //                   
input   wire        [(Amatrixcolnum * Amatrixrownum) * word_size - 1 : 0]A, // Input matrix A //
input   wire        [(Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0]B, // Input matrix B //
input   wire        [1:0] op,  // Operation code //
output  wire        [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0] C // Output matrix result //
);
// Intermediate wire signals for different matrix operations //
wire    [(Amatrixrownum * Bmatrixcolnum) * word_size - 1 : 0] m_add, m_sub, m_mul;
wire    [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0] m_kro;

// Register for storing the final output //
reg     [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0] C_reg;

// Always block to handle output register assignment and reset //
always@(posedge clk or negedge resetn)begin
    if(!resetn)begin
        C_reg = 'd0;
    end else begin
        if(op==2'b00) begin
            C_reg = {{(((Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) - 1)* word_size - 1){1'bz}},m_add};
        end else if (op==2'b01) begin
            C_reg = {{(((Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) - 1)* word_size - 1){1'bz}},m_sub};
        end else if (op==2'b10) begin
            C_reg = {{(((Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) - 1)* word_size - 1){1'bz}},m_mul};
        end else if (op==2'b11) begin
            C_reg = m_kro;
        end
    end
end

// Assign the final output //
assign C = C_reg;

// Module instantiations for matrix operations (addition, subtraction, multiplication, and Kronecker product) //
// Instantiate these modules as needed to perform specific operations.                                        //

matrix_add_sub #(.word_size(word_size),
                 .Amatrixrownum(Amatrixrownum),
                 .Amatrixcolnum(Amatrixcolnum),
                 .Bmatrixrownum(Bmatrixrownum),
                 .Bmatrixcolnum(Bmatrixcolnum))mat_add(
.op(1'b0),                            
.A(A),
.B(B),
.ASP(m_add)
);
matrix_add_sub #(.word_size(word_size),
                 .Amatrixrownum(Amatrixrownum),
                 .Amatrixcolnum(Amatrixcolnum),
                 .Bmatrixrownum(Bmatrixrownum),
                 .Bmatrixcolnum(Bmatrixcolnum))mat_sub(
.op(1'b1),                            
.A(A),
.B(B),
.ASP(m_sub)
);
matrix_mul #(.word_size(word_size),
                 .Amatrixrownum(Amatrixrownum),
                 .Amatrixcolnum(Amatrixcolnum),
                 .Bmatrixrownum(Bmatrixrownum),
                 .Bmatrixcolnum(Bmatrixcolnum))mat_mul(
.A(A),
.B(B),
.MP(m_mul)
);
matrix_kronecker #(.word_size(word_size),
                 .Amatrixrownum(Amatrixrownum),
                 .Amatrixcolnum(Amatrixcolnum),
                 .Bmatrixrownum(Bmatrixrownum),
                 .Bmatrixcolnum(Bmatrixcolnum))mat_kron(
.A(A),
.B(B),
.TP(m_kro)
);                    
endmodule                 