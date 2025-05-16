//final data path result selector

module Result_Selector(
input [2:0] op654,funct3,
input [31:0] Result_Final,
output [31:0] Result
);


assign Result = (op654 == 3'b000) ? 
                (funct3 == 3'b000) ? {{24{Result_Final[7]}}, Result_Final[7:0]} :  // LB (Sign-Extend Byte)
                (funct3 == 3'b001) ? {{16{Result_Final[15]}}, Result_Final[15:0]} : // LH (Sign-Extend Halfword)
                (funct3 == 3'b010) ? Result_Final :                                // LW (Full Word)
                (funct3 == 3'b100) ? {24'b0, Result_Final[7:0]} :                 // LBU (Zero-Extend Byte)
                (funct3 == 3'b101) ? {16'b0, Result_Final[15:0]} :                // LHU (Zero-Extend Halfword)
                Result_Final 
                : Result_Final;
					 
endmodule