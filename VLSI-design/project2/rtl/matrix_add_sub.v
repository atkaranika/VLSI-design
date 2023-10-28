// Module Description:                                                                  //
// The matrix_add_sub module performs matrix addition or subtraction operations         //
// based on the input control signal 'op' and produces the result in the signal 'ASP'.  //
// Note: Both Amatrixrownum and Bmatrixrownum and Amatrixcolnum and Bmatrixcolnum       //
// must be equal respectively, for valid operations.                                    //

module matrix_add_sub #(parameter word_size = 32, // Word size for matrix elements //
                            parameter Amatrixrownum = 2, // Number of rows in matrix A //
                            parameter Amatrixcolnum = 2, // Number of columns in matrix A //
                            parameter Bmatrixrownum = 2, // Number of rows in matrix B //
                            parameter Bmatrixcolnum = 2)( // Number of columns in matrix B //
    input   wire        op,  // Control signal: 0 for addition, 1 for subtraction //                           
    input   wire        [(Amatrixcolnum * Amatrixrownum) * word_size - 1 : 0]A, // Input matrix A //
    input   wire        [(Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0]B, // Input matrix B //
    output  wire        [(Amatrixrownum *Bmatrixcolnum) * word_size - 1 : 0]ASP // Output matrix result //
);

// Declare wire signals to represent matrices A, B, and intermediate results //
    wire    [(word_size-1):0] Amatrix [0:Amatrixrownum - 1][0:Amatrixcolnum - 1];
    wire     [(word_size-1):0] Bmatrix [0:Bmatrixrownum - 1][0:Bmatrixcolnum - 1];
    wire    [(word_size-1):0] add_sub_wire[0:Amatrixrownum - 1][0:Bmatrixcolnum - 1];
genvar x, y;
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
    // Perform matrix addition or subtraction on Amatrix and Bmatrix //
    for(x=0; x<Amatrixrownum; x=x+1) begin
        for(y=0; y<Amatrixcolnum; y=y+1) begin
            assign add_sub_wire[x][y] = (op == 1'b0) ? Amatrix[x][y] + Bmatrix[x][y] : Amatrix[x][y] - Bmatrix[x][y];
        end
    end
     // Convert the addition or subtraction result to the output vector ASP //
    for(i=0; i<Amatrixrownum; i=i+1)begin
        for(j=0; j<Bmatrixcolnum; j=j+1)begin
                assign ASP[(Amatrixrownum*Bmatrixcolnum*word_size-1)-(Bmatrixcolnum*i+j)*word_size:(Amatrixrownum*Bmatrixcolnum*word_size-1)-(Bmatrixcolnum*i+j) * word_size - (word_size-1)] = add_sub_wire[i][j];
        end
    end
endgenerate
endmodule