
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
	 
    output [31:0] Result
);

wire        ALUSrc, RegWrite, Jump, Zero;
wire  [31:0] A,B;
wire [1:0]  ResultSrc, ImmSrc;
wire [3:0]  ALUControl;

controller  c   (Instr[6:0], Instr[14:12], Instr[30], Zero,Mem_WrAddr[31],A,B,//
                ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump,
                ImmSrc, ALUControl);

datapath    dp  (clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl,Jump,
                Zero, PC, Instr,A,B, Mem_WrAddr, Mem_WrData, ReadData, Result);

endmodule

