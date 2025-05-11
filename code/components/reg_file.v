
// reg_file.v - register file for single-cycle RISC-V CPU
//              (with 32 registers, each of 32 bits)
//              having two read ports, one write port
//              write port is synchronous, read ports are combinational
//              register 0 is hardwired to 0

module reg_file #(parameter DATA_WIDTH = 32) (
    input       clk,
    input       wr_en,
		//input [11:0]    imm,
	 input [2:0] funct3,op654,
    input       [4:0] rd_addr1, rd_addr2, wr_addr,
    input       [DATA_WIDTH-1:0] wr_data,
    output      [DATA_WIDTH-1:0] rd_data1, rd_data2
);

reg [DATA_WIDTH-1:0] reg_file_arr [0:31];

//wire [4:0]rd_addr2_temp;
//wire[31:0] w;
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        reg_file_arr[i] = 0;
    end
end

// register file write logic (synchronous)
always @(posedge clk) begin
    if (wr_en)begin 
	if((op654==3'b000))begin
	
		case(funct3)
				3'b000:    	 reg_file_arr[wr_addr] <= {{24{wr_data[7]}},wr_data[7:0]};          
				3'b001:   	 reg_file_arr[wr_addr] <= {{16{wr_data[15]}},wr_data[15:0]};
            3'b010:    	 reg_file_arr[wr_addr] <= wr_data;
				3'b100:   	 reg_file_arr[wr_addr] <= {24'b0,wr_data[7:0]};
				3'b101:		 begin reg_file_arr[wr_addr] <= {16'b0,wr_data[15:0]};
									
				end
				default: reg_file_arr[wr_addr] <= wr_data;
				endcase
	  
	  end
	  else reg_file_arr[wr_addr] <= wr_data;
	 end 
end


  // assign w = {16'b0,wr_data[15:0]};
//assign w=rd_addr2+imm;
//assign rd_addr2_temp = (op645==3'b000) ?  (w[4:0]) : rd_addr2 ;//lb



// register file read logic (combinational)
assign rd_data1 = (rd_addr1 != 0) ? reg_file_arr[rd_addr1] : 0; // LHU
assign rd_data2 =  (op654==3'b000) ? (rd_addr2) : ((rd_addr2 != 0) ? reg_file_arr[rd_addr2]:0); // LHU

endmodule

