module assertion_SPI #(int DATA_BYTE_WIDTH=1) (
	input logic i_clk,
	input logic i_rst,
	input logic sCLK,
	input logic CS,
	input logic MOSI,
	input logic MISO,
	input logic [DATA_BYTE_WIDTH*8-1:0]slave_tx_data,
	input logic [DATA_BYTE_WIDTH*8-1:0]slave_rx_data,
	input logic [DATA_BYTE_WIDTH*8+8-1:0]master_tx_data,
	input logic [DATA_BYTE_WIDTH*8-1:0]master_rx_data,
	input logic load_en,
	input logic rx_reg
);
	/*
	sequence s_CS_check_fell_data(signal);
		$fell(CS) ##0 $isunknown(signal)[*5];
	endsequence

	sequence s_CS_check_fell_en(en)
		$fell(CS) ##0 $fell(en);
	endsequence
	*/

	property p_CS_check_fell_data(signal);
		@(posedge i_clk) disable iff(!i_rst)
		$fell(CS) |-> $isunknown(signal)[*5];
	endproperty

	property p_CS_check_fell_en(en);
		@(posedge i_clk) disable iff(!i_rst)
 		$fell(CS) |-> $fell(en);
	endproperty

	a_CS_check_fell_mosi   	  : assert property(p_CS_check_fell_data(MOSI))	  		else $error("a_CS_check_fell_mosi at time %0t", $time);
	a_CS_check_fell_miso   	  : assert property(p_CS_check_fell_data(MISO))	  		else $error("a_CS_check_fell_miso at time %0t", $time);
	a_CS_check_fell_load_en   : assert property(p_CS_check_fell_en(load_en))	  	else $error("a_CS_check_fell_load_en at time %0t", $time);

endmodule : assertion_SPI
