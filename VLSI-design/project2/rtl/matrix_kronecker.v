//  Module Description:                                                                           //
// The matrix_kronecker module performs the Kronecker product between two input matrices A and B  //
// and stores the result in the signal TP.                                                        //
// TP formula                                                                                     //
// A = | a00 a01 | B = | b00 b01 | TP = | a00 * b00 a00 * b01 a01 * b00 a01 * b01 |               //
//     | a10 a11 |     | b10 b11 |      | a00 * b10 a00 * b11 a01 * b10 a01 * b11 |               //
//                                      | a10 * b00 a10 * b01 a11 * b00 a11 * b01 |               //
//                                      | a10 * b10 a10 * b11 a11 * b10 a11 * b11 |               //

module matrix_kronecker #(parameter word_size = 32, // Word size for matrix elements //
                        parameter Amatrixrownum = 2, // Number of rows in matrix A //
                        parameter Amatrixcolnum = 2, // Number of columns in matrix A //
                        parameter Bmatrixrownum = 2,  // Number of rows in matrix B //
                        parameter Bmatrixcolnum = 2)( // Number of columns in matrix B //
    input   wire [(Amatrixcolnum * Amatrixrownum) * word_size - 1 : 0]A, // Input matrix A //
    input   wire [(Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0]B, // Input matrix B //
    output  wire [(Amatrixcolnum * Amatrixrownum) * (Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0]TP // Output matrix result //
);

// Declare wire signals to represent matrices A, B, and intermediate results //
    wire    [(word_size-1):0] Amatrix [0:Amatrixrownum - 1][0:Amatrixcolnum - 1];
    wire    [(word_size-1):0] Bmatrix [0:Bmatrixrownum - 1][0:Bmatrixcolnum - 1];
    wire    [(word_size-1):0] tensorproduct[Amatrixrownum * Bmatrixrownum - 1:0][ Bmatrixcolnum * Amatrixcolnum - 1:0];
    
genvar x, y, z, w;
genvar i, j;
genvar Amatrixrowindex, Amatrixcolindex;
genvar Bmatrixrowindex, Bmatrixcolindex;
generate
    // Convert input vectors A and B to matrices Amatrix and Bmatrix //
    for (Amatrixrowindex = 0; Amatrixrowindex < Amatrixrownum; Amatrixrowindex = Amatrixrowindex + 1) begin
        for (Amatrixcolindex = 0; Amatrixcolindex < Amatrixcolnum; Amatrixcolindex = Amatrixcolindex + 1) begin
                assign Amatrix[Amatrixrowindex][Amatrixcolindex] = A[(Amatrixcolnum * Amatrixrownum) * word_size - 1 - (Amatrixcolnum * Amatrixrowindex + Amatrixcolindex) * word_size : (Amatrixcolnum * Amatrixrownum) * word_size -1 - (Amatrixcolnum * Amatrixrowindex + Amatrixcolindex) * word_size  - (word_size-1)]; 
        end
    end
    for (Bmatrixrowindex = 0; Bmatrixrowindex < Bmatrixrownum; Bmatrixrowindex = Bmatrixrowindex + 1) begin
        for (Bmatrixcolindex = 0; Bmatrixcolindex < Bmatrixcolnum; Bmatrixcolindex = Bmatrixcolindex + 1) begin
                assign Bmatrix[Bmatrixrowindex][Bmatrixcolindex] = B[(Bmatrixcolnum * Bmatrixrownum) * word_size - 1 - (Bmatrixcolnum * Bmatrixrowindex + Bmatrixcolindex) * word_size : (Bmatrixcolnum * Bmatrixrownum) * word_size -1 - (Bmatrixcolnum * Bmatrixrowindex + Bmatrixcolindex) * word_size  - (word_size-1)];   
        end
    end
    // Calculate the Kronecker product //
    for(x=0; x<Amatrixrownum; x=x+1) begin
        for(y=0; y<Amatrixcolnum; y=y+1) begin
            for(z=0; z<Bmatrixrownum; z=z+1) begin
                    for(w=0; w<Bmatrixcolnum; w=w+1)begin
                    // A is an m x n matrix                              //
                    // B is a p x q matrix                               //
                    // A ? B is an (m * p) x (n * q) matrix              //
                    // (A ? B)(i * p + k, j * q + l) = A(i, j) * B(k, l) //
                    assign tensorproduct[x*Bmatrixrownum+z][y*Bmatrixcolnum+w] = Amatrix[x][y] * Bmatrix[z][w]; 
                end
            end
        end
    end
    // Convert tensorproduct from a matrix to a vector //
    for(i=0; i<Amatrixrownum*Amatrixcolnum; i=i+1)begin
        for(j=0; j<Bmatrixrownum*Bmatrixcolnum; j=j+1)begin
            assign TP[(Amatrixcolnum * Bmatrixcolnum * Amatrixcolnum * Bmatrixcolnum * word_size - 1) - (((Amatrixcolnum * Bmatrixcolnum) * i) + j) * word_size : (Amatrixcolnum * Bmatrixcolnum * Amatrixcolnum * Bmatrixcolnum * word_size - 1) - (((Amatrixcolnum * Bmatrixcolnum) * i) + j) * word_size  - (word_size-1)] = tensorproduct[i][j];
        end
    end
endgenerate
endmodule