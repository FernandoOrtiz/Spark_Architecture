
`include "PF1_Ortiz_Alicea_Fernando_ram.v"

module RAM_Access;
	integer fi,fo,code,i; 
	reg mfa, rw; 
	reg [31:0] DataIn; 
	reg [7:0] Address;
	reg [1:0] ByteMode;
	wire [31:0] DataOut; 
	wire mfc;
	reg [31:0] InputData [63:0];

	ram ram1 (DataOut, mfc, Address, DataIn, rw, mfa, ByteMode);

	initial begin
		mfa = 1'b0; 
		rw = 1'b1;

		// Write words from text file
		// Reading from text file
		Address = 0;
		ByteMode = 2'b00;
		fi = $fopen("PF1_Ortiz_Alicea_Fernando_ramdata.txt","r");
		while (!$feof(fi)) begin
			code = $fscanf(fi, "%b", DataIn);
			// $display("address %b data %b ram.mem %b", Address, data, ram1.mem[Address]);
			#5 mfa = 1'b1;
			#5 mfa = 1'b0;
			Address = Address + 4;

		end


//*************************************************
		// Write byte mode
		ByteMode = 2'b01;
		Address = 60;
		DataIn = 8'b11001100;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// Write half-word mode
		ByteMode = 2'b10;
		Address = Address + 4;
		DataIn = 16'b1010101011110000;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// Write Word
		ByteMode = 2'b00;
		Address = Address + 4;
		DataIn = 32'b11100101110000010101000000000011;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// Write double-word mode
		ByteMode = 2'b11;
		Address = Address + 4;
		DataIn = 32'b11100101110000010101000000000011;
		#5 mfa = 1'b1;
		#5
		DataIn = 32'b00001011000001010000011100000100;
		#5
		#5 mfa = 1'b0;


//***********************************************************

		// Write byte mode
		ByteMode = 2'b01;
		Address = 240;
		DataIn = 8'b11001100;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// Write half-word mode
		ByteMode = 2'b10;
		Address = Address + 4;
		DataIn = 16'b1010101011110000;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// Write double-word mode
		ByteMode = 2'b11;
		Address = Address + 4;
		DataIn = 32'b11100101110000010101000000000011;
		#5 mfa = 1'b1;
		#5
		DataIn = 32'b00001011000001010000011100000100;
		#5
		#5 mfa = 1'b0;


		$fclose(fi);
		$display("Done writing to memory");
	end

	initial begin
		repeat (64) begin
		end
	end

	initial begin
		#2000
		fo=$fopen("output_file.txt","w");
		$display("Address: \tDataOut:");
		mfa = 1'b0; 
		rw = 1'b0;
		Address = 8'b00000000;
		ByteMode = 2'b00;
		repeat (60) begin
			#5 mfa = 1'b1;
			#5 mfa = 1'b0;
			Address = Address + 4;
		end

//*********************************************************
		// READ byte mode
		ByteMode = 2'b01;
		Address = 60;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ half-word mode
		ByteMode = 2'b10;
		Address = Address + 4;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ word mode
		ByteMode = 2'b00;
		Address = Address + 4;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ double-word mode
		ByteMode = 2'b11;
		Address = Address + 4;
		#5 mfa = 1'b1;
		#11
		$fdisplay(fo,"data en %d = %b %d", Address, DataOut, $time);
		$display("\t\t\t%b", DataOut);
		#5 mfa = 1'b0;


//****************************************************************



		// READ byte mode
		ByteMode = 2'b01;
		Address = 240;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ half-word mode
		ByteMode = 2'b10;
		Address = Address + 4;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ double-word mode
		ByteMode = 2'b11;
		Address = Address + 4;
		#5 mfa = 1'b1;
		#11
		$fdisplay(fo,"data en %d = %b %d", Address, DataOut, $time);
		$display("\t\t\t%b", DataOut);
		#5 mfa = 1'b0;


		Address = Address + 4;
		// READ byte mode
		ByteMode = 2'b01;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		// READ half-word mode
		ByteMode = 2'b10;
		#5 mfa = 1'b1;
		#5 mfa = 1'b0;

		#200
		$fclose(fo);
		$finish;
	end

	always @ (posedge mfa) begin
		#1;
		if(!rw) begin
			$fdisplay(fo,"data en %d = %b %d", Address, DataOut, $time);
			$display("\t%d \t%b", Address, DataOut);
		end
	end

endmodule