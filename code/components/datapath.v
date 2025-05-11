
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    output        Zero,
    output [31:0] PC,
    input  [31:0] Instr,
	 output [31:0] A,B,//////
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCPlus4, PCTarget,Auipc,Result_temp;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult,lauipcResult;

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext);

// register file logic
reg_file       rf (clk, RegWrite, /*Instr[31:21],*/Instr[14:12], Instr[6:4], Instr[19:15], Instr[24:20], Instr[11:7], Result_temp, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
adder #(32)	 	auipcadder({Instr[31:12],12'b0},PC,Auipc);
mux2 #(32) 		lauipcmux(Auipc,{Instr[31:12],12'b0},Instr[5],lauipcResult);

//branch


//result
mux4 #(32)     resultmux(ALUResult, ReadData, PCPlus4,lauipcResult, ResultSrc, Result_temp);

assign Result = (Instr[6:4] == 3'b000) ? 
                (Instr[14:12] == 3'b000) ? {{24{Result_temp[7]}}, Result_temp[7:0]} :  // LB (Sign-Extend Byte)
                (Instr[14:12] == 3'b001) ? {{16{Result_temp[15]}}, Result_temp[15:0]} : // LH (Sign-Extend Halfword)
                (Instr[14:12] == 3'b010) ? Result_temp :                                // LW (Full Word)
                (Instr[14:12] == 3'b100) ? {24'b0, Result_temp[7:0]} :                 // LBU (Zero-Extend Byte)
                (Instr[14:12] == 3'b101) ? {16'b0, Result_temp[15:0]} :                // LHU (Zero-Extend Halfword)
                Result_temp 
                : Result_temp;

assign A=SrcA;
assign B=SrcB;
assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule

