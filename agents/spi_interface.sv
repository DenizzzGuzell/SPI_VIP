interface spi_interface #(int DATA_BYTE_WIDTH=1)(
input logic i_clk,
input logic i_rst
);

  // Only connect the ones that are needed
  logic sCLK;
  logic CS;
  logic MOSI;
  logic MISO;
  logic [DATA_BYTE_WIDTH*8-1:0]slave_tx_data;//slavenin misoya yazması için verdiğimiz data
  logic [DATA_BYTE_WIDTH*8-1:0]slave_rx_data;//slavenin mosiden topladığı data
  logic [DATA_BYTE_WIDTH*8+8-1:0]master_tx_data;//slavenin misoya yazması için verdiğimiz data
  logic [DATA_BYTE_WIDTH*8-1:0]master_rx_data;//slavenin mosiden topladığı data

  logic load_en;
  logic rx_reg;

	/*
	sequence s_CS_check_fell_data(signal);
		$fell(CS) ##0 $isunknown(signal)[*5];
	endsequence

	sequence s_CS_check_fell_en(en)
		$fell(CS) ##0 $fell(en);
	endsequence
	*/

	property p_CS_check_fell_data(cs, signal);
		@(posedge i_clk) disable iff(!i_rst)
		$fell(cs) |-> $isunknown(signal)[*5];
	endproperty

	property p_CS_check_fell_en(cs,en);
		@(posedge i_clk) disable iff(!i_rst)
 		$fell(cs) |-> $fell(en);
	endproperty

	property p_MOSI_sCLK_check(clk, signal);
		@(posedge i_clk) disable iff(!i_rst)
		$fell(clk) |-> not $isunknown(signal);
	endproperty

	property p_rx_reg_check_tx(en, signal_1, signal_2, sclk);
		@(posedge i_clk) disable iff(!i_rst)
 		$fell(en) |-> if(sclk) $changed(signal_1) intersect $changed(signal_2);
	endproperty

	property p_rx_reg_check_rx(en, signal_1, signal_2);
		@(posedge i_clk) disable iff(!i_rst)
 		$rose(en) |-> $changed(signal_1) intersect $changed(signal_2);
	endproperty

	property p_cs_high_check(cs, signal_1, signal_2);
		@(posedge i_clk) disable iff(!i_rst)
		cs |-> $isunknown(signal_1) intersect $isunknown(signal_2);
	endproperty

	property p_frame_sequence_check(clk, cs, signal_1, signal_2);
		@(posedge i_clk) disable iff(!i_rst)
		$fell(clk) && !cs |=> if(signal_1 == 0 && $isunknown(signal_2)) $isunknown(signal_2)[*9];
	endproperty

	//Glitch Detection property for signals
	property p_glitch_detection(signal_to_check, period);
		int time_var;
		int period_of_clk = period;
		@(signal_to_check)
		(1,time_var = $realtime) |=> ($realtime - time_var >= period_of_clk);
	endproperty

	a_CS_check_fell_mosi   	  : assert property(p_CS_check_fell_data(CS, MOSI))	  										   else $error("a_CS_check_fell_mosi at time %0t", $time);
	a_CS_check_fell_miso   	  : assert property(p_CS_check_fell_data(CS, MISO))	  										   else $error("a_CS_check_fell_miso at time %0t", $time);
	a_CS_check_fell_load_en   : assert property(p_CS_check_fell_en(CS, load_en))	  										   else $error("a_CS_check_fell_load_en at time %0t", $time);
	a_MOSI_sCLK_check   	 	  : assert property(p_MOSI_sCLK_check(sCLK, MOSI))	  											   else $error("a_MOSI_sCLK_check at time %0t", $time);
	a_rx_reg_check		   	  : assert property(p_rx_reg_check_tx(rx_reg, slave_tx_data, master_tx_data, sCLK))	  	else $error("a_rx_reg_check at time %0t", $time);
	a_tx_reg_check		   	  : assert property(p_rx_reg_check_rx(rx_reg, slave_rx_data, master_rx_data))				else $error("a_tx_reg_check at time %0t", $time);
	a_cs_high_check		     : assert property(p_cs_high_check(CS, MOSI, MISO))	  											else $error("a_cs_high_check at time %0t", $time);
	a_frame_sequence_check	  : assert property(p_frame_sequence_check(sCLK, CS, MOSI, MISO))	  							else $error("a_frame_sequence_check at time %0t", $time);

	//Glitch Properties assert statements
	a_CS_glitch_check			  : assert property(p_glitch_detection(CS, 2ns))														else $error("a_cs_glitch_check at time %0t",$time);
	a_mosi_glitch_check		  : assert property(p_glitch_detection(MOSI, 2ns))													else $error("a_cs_glitch_check at time %0t",$time);
	a_miso_glitch_check		  : assert property(p_glitch_detection(MISO, 2ns))													else $error("a_cs_glitch_check at time %0t",$time);
	a_sCLK_glitch_check		  : assert property(p_glitch_detection(sCLK, 2ns))													else $error("a_cs_glitch_check at time %0t",$time);
	a_load_en_glitch_check	  : assert property(p_glitch_detection(load_en, 2ns))												else $error("a_cs_glitch_check at time %0t",$time);
	a_rx_reg_glitch_check     : assert property(p_glitch_detection(rx_reg, 2ns))													else $error("a_cs_glitch_check at time %0t",$time);

endinterface : spi_interface
