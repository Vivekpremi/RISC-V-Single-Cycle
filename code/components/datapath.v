
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
	 input Jump,
    output        Zero,
    output [31:0] PC,
    input  [31:0] Instr,
	 output [31:0] A,B,//////
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

wire [31:0] PCNext, PCPlus4, PCTarget,PCNext_if_not_jump,Auipc,Result_Final;
wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult,lauipcResult;
wire [31:0] Reg_WrData,Reg_WrData_final,Result_if_not_jump;
// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNext_if_not_jump);
mux2 #(32)     pcmux_for_jalr(PCNext_if_not_jump,ALUResult, Jump, PCNext);
mux2 #(32)     mux_for_jalr(Reg_WrData,PCPlus4, Jump, Reg_WrData_final);

// register file logic

RegWrSrc  reg_wrsrc(RegWrite,Instr[6:4],Instr[14:12],Result_Final,Reg_WrData);//reg file write src selection logic

reg_file       rf (clk, RegWrite,Instr[14:12], Instr[6:4], Instr[19:15], Instr[24:20], Instr[11:7], /*Result_FinalReg_WrData*/Reg_WrData_final, SrcA, WriteData);
imm_extend     ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)     srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu            alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
adder #(32)	 	auipcadder({Instr[31:12],12'b0},PC,Auipc);
mux2 #(32) 		lauipcmux(Auipc,{Instr[31:12],12'b0},Instr[5],lauipcResult);

//branch


//result
mux4 #(32)     resultmux(ALUResult, ReadData, PCPlus4,lauipcResult, ResultSrc, Result_Final);

Result_Selector res_sel(Instr[6:4],Instr[14:12],Result_Final,Result_if_not_jump);
mux2 #(32) 		final_res_mux(Result_if_not_jump,PCPlus4,Jump,Result);
assign A=SrcA;
assign B=SrcB;
assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule

