# Matrix ALU

Design and Implementation of a Verilog-based Matrix Arithmetic Logic Unit(Matrix ALU) capable of performing matrix addition, substraction, multiplication and Kronecher product.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)


## Overview
The ALU takes as input a clock(clk), a reset(resetn) which control the output register, an operation code(op) which is used to specify the operation to be performed, 2 matrices of the same dimensions(matrixrow X matrixcolumn) and 1 output matrix.
The result of Matrix addition, substraction, multiplication has the same dimensions of the input matrices.
Although, the result of  Kronecher product has its dimensions to be the cartesian product of the input matrics dimensions, which means that the output matrix size is given by (matrixrow X matrixcolumn) X (matrixcolumn X matrixrow).
## Prerequisites

Modelsim or anly simulator
- [Prerequisite 1](https://eda.sw.siemens.com/en-US/ic/modelsim/)
NOTE: Liscence is required

## Installation

Provide step-by-step instructions on how to install and set up your project. Include any necessary commands or configuration files. You can also include installation for different platforms if applicable.

```bash
# Example installation steps
# git clone https://github.com/yourusername/yourproject.git
# cd yourproject
# npm install
