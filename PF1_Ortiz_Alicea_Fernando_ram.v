// RAM 512 bytes
module ram
	#(

	parameter DATA_SIZE = 32,
	parameter ADDRESS_SIZE = 8,
	parameter RAM_SIZE = 512,
	parameter RAM_DELAY = 0

	)

	(output reg [31:0] data_out,
	 output reg mfc,
	 input [ADDRESS_SIZE-1:0] address,
	 input [DATA_SIZE-1:0] data_in,
	 input rw, mfa,
	 input [1:0] byte_mode
	 );

	reg [ADDRESS_SIZE-1:0] mem [RAM_SIZE-1:0];
 
	always @(negedge mfa) mfc <= 1'b0;

	always @(posedge mfa) 
		begin : MEM_WRITE
		if(mfa && rw) begin  								// Mem is enabled
			if(byte_mode [1:0] == 2'b01) begin 				// Byte mode
				mem[address] <= data_in[7:0];
			end
			else if(byte_mode [1:0] == 2'b00) begin  		// word mode
				mem[address] <= data_in[31:24];
				mem[address + 1] <= data_in[23:16];
				mem[address + 2] <= data_in[15:8];
				mem[address + 3] <= data_in[7:0];
			end
			else if(byte_mode [1:0] == 2'b10) begin  		// Half word
				mem[address] <= data_in[15:8];
				mem[address + 1] <= data_in[7:0];
			end
			else if(byte_mode [1:0] == 2'b11) begin  		// Double word
				mem[address + 0] <= data_in[31:24];			// Second part (big-endian)
				mem[address + 1] <= data_in[23:16];
				mem[address + 2] <= data_in[15:8];
				mem[address + 3] <= data_in[7:0];
				#10#RAM_DELAY;
				mem[address + 4] <= data_in[31:24];				// First part
				mem[address + 5] <= data_in[23:16];
				mem[address + 6] <= data_in[15:8];
				mem[address + 7] <= data_in[7:0];
			end
			#RAM_DELAY;
			mfc<=1'b1;
		end
	end

	always @(posedge mfa) 
		begin : MEM_READ
		if(mfa && !rw) begin  								// Read mode
			if(byte_mode [1:0] == 2'b01) begin				// Byte mode
				data_out <= mem[address];
			end
			if(byte_mode [1:0] == 2'b00) begin  			// Word mode
				data_out <= {mem[address], mem[address+1], mem[address+2], mem[address+3]};
			end
			if(byte_mode [1:0] == 2'b10) begin				// Halfword mode
				data_out <= {mem[address], mem[address+1]};
			end
			if(byte_mode [1:0] == 2'b11) begin  			// Double word mode
				data_out[31:24] <= mem[address]; 
				data_out[23:16] <= mem[address+1];
				data_out[15:8] <= mem[address+2];
				data_out[7:0] <= mem[address+3];
				#10#RAM_DELAY;
				data_out[31:24] <= mem[address+4]; 
				data_out[23:16] <= mem[address+5];
				data_out[15:8] <= mem[address+6];
				data_out[7:0] <= mem[address+7];
			end
			#RAM_DELAY;
			mfc<=1'b1;
		end
	end

endmodule