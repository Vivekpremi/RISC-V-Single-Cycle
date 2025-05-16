
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero,
	 input		alusign,
	 input [31:0] A,B,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump,
    output [1:0] ImmSrc,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;
wire       Branch;

main_decoder    md (op, funct3,ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

alu_decoder     ad (op[6:4], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch

PCsrcGen			pcsgen(funct3,Branch,Zero,alusign,Jump,A,B,PCSrc);
//assign PCSrc =(funct3 == 3'b000) ? ((Branch & Zero) | Jump) : //((Branch & ~Zero) | Jump):// beq
//               (funct3 == 3'b001) ? ((Branch & ~Zero) | Jump) : // bne
//               (funct3 == 3'b100) ? ((Branch & alusign) | Jump) : // blt
//               (funct3 == 3'b101) ? ((Branch & (~alusign | Zero)) | Jump): // bge
//               (funct3 == 3'b110) ? ((Branch & ({1'b0,A[30:0]} < {1'b0,B[30:0]})) | Jump) : // bltu
//               (funct3 == 3'b111) ? ((Branch & ({1'b0,A[30:0]} >= {1'b0,B[30:0]})) | Jump):1'b0 // bgeu
//               ; // Default case 0
endmodule

