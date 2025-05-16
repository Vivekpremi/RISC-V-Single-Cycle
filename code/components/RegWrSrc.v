// reg file source

module RegWrSrc #(parameter DATA_WIDTH=32) (
input wr_en,
input [2:0] op654,funct3,
input       [DATA_WIDTH-1:0] wr_data,
output reg [DATA_WIDTH-1:0] Reg_WrData

);


always @(*) begin
    if (wr_en)begin 
	if((op654==3'b000))begin
	
		case(funct3)
				3'b000:    	 Reg_WrData <= {{24{wr_data[7]}},wr_data[7:0]}; //lb         
				3'b001:   	 Reg_WrData <= {{16{wr_data[15]}},wr_data[15:0]};//lh
            3'b010:    	 Reg_WrData <= wr_data;//lw
				3'b100:   	 Reg_WrData <= {24'b0,wr_data[7:0]};//lbu
				3'b101:		 begin Reg_WrData <= {16'b0,wr_data[15:0]};//lhu
									
				end
				default: Reg_WrData <= wr_data;
				endcase
	  
	  end
	  else Reg_WrData <= wr_data;
	 end 
	 end
	 
endmodule