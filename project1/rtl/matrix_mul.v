// Module Description:                                                                      //
// The matrix_mul module performs matrix multiplication between two input matrices A and B  //
// and stores the result in the signal MP.                                                  //
// Note: Both Amatrixrownum and Bmatrixcolnum must be equal, for valid operations.          //                                     // 

module matrix_mul #(parameter word_size = 32, // Word size for matrix elements //
                        parameter Amatrixrownum = 2, // Number of rows in matrix A //
                        parameter Amatrixcolnum = 2, // Number of columns in matrix A //
                        parameter Bmatrixrownum = 2, // Number of rows in matrix B //
                        parameter Bmatrixcolnum = 1)( // Number of columns in matrix B //
    input   wire        [(Amatrixcolnum * Amatrixrownum) * word_size - 1 : 0]A, // Input matrix A //
    input   wire        [(Bmatrixcolnum * Bmatrixrownum) * word_size - 1 : 0]B, // Input matrix B //
    output  wire        [(Amatrixrownum * Bmatrixcolnum) * word_size - 1 : 0]MP // Output matrix result //
);

// Declare wire signals to represent matrices A, B, and intermediate results //
    wire    [(word_size-1):0] Amatrix [0:Amatrixrownum - 1][0:Amatrixcolnum - 1];
    wire    [(word_size-1):0] Bmatrix [0:Bmatrixrownum - 1][0:Bmatrixcolnum - 1];
    wire    [(word_size-1):0] matrixproduct_wire[0:Amatrixrownum - 1][0:Bmatrixcolnum - 1];   
genvar i, j;
genvar Amatrixrowindex, Amatrixcolindex;
genvar Bmatrixrowindex, Bmatrixcolindex;
genvar x, y, z, w; 
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
     // Perform matrix multiplication //
    reg     [word_size-1 : 0] temp_res0 [Amatrixcolnum-1:0][Amatrixrownum*Bmatrixcolnum-1:0];
    wire    [word_size-1 : 0] temp_res1 [Amatrixcolnum-1:0][Amatrixrownum*Bmatrixcolnum-1:0];
    for(x=0; x<Amatrixrownum; x=x+1) begin
        for(w=0; w<Bmatrixcolnum; w=w+1)begin
            for(y=0; y<Amatrixcolnum; y=y+1) begin
                wire    [word_size-1 : 0] temp_res0_w;
                assign temp_res0_w = Amatrix[x][y] * Bmatrix[y][w];
                always@(temp_res0_w) begin
                    temp_res0[y][Bmatrixcolnum*x+w] = temp_res0_w;
                end
            end
            for(z=0; z<Amatrixcolnum-1; z=z+1)begin
                if (z == 0) begin
                    assign temp_res1[0][Bmatrixcolnum*x+w] = temp_res0[0][Bmatrixcolnum*x+w] + temp_res0[1][Bmatrixcolnum*x+w];
                end else begin
                    assign temp_res1[z][Bmatrixcolnum*x+w] = temp_res1[z-1][Bmatrixcolnum*x+w] + temp_res0[z+1][Bmatrixcolnum*x+w];
                end
            end
            assign matrixproduct_wire[x][w] = temp_res1[Amatrixcolnum-2][Bmatrixcolnum*x+w];
        end
    end    
    // conversion of matrixproduct to output vector MP //
    for(i=0; i<Amatrixrownum; i=i+1)begin
        for(j=0; j<Bmatrixcolnum; j=j+1)begin
                assign MP[(Amatrixrownum*Bmatrixcolnum*word_size-1)-(Bmatrixcolnum*i+j)*word_size:(Amatrixrownum*Bmatrixcolnum*word_size-1)-(Bmatrixcolnum*i+j)*word_size - (word_size-1)] = matrixproduct_wire[i][j];
        end
    end
endgenerate
endmodule