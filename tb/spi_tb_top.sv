`timescale 1ps/1fs
//////////////////////////////////////////////
// Engineer: Deniz Güzel
// Create Date: 01/03/2023 09:00:00 AM
// Description: UVM verification of spi_slave
//////////////////////////////////////////////
 import uvm_pkg::*;
`include "uvm_macros.svh"

 import spi_test_lib_pkg::*;

module spi_tb_top;

  //Instantiation
  logic       i_clk;
  logic       i_rst;

  spi_interface #(1) SPI(.i_clk(i_clk),.i_rst(i_rst));  // SPI Interface

  spi_driver_BFM SPI_drv_bfm(
   .MISO(SPI.MISO),
   .sCLK(SPI.sCLK),
   .MOSI (SPI.MOSI),
   .CS(SPI.CS),
   .master_rx_data(SPI.master_rx_data),
   .slave_tx_data(SPI.slave_tx_data),
   .master_tx_data(SPI.master_tx_data),
	.load_en(SPI.load_en),
	.rx_reg(SPI.rx_reg)
 );

  spi_monitor_BFM SPI_mon_bfm(
   .CS   (SPI.CS),
   .slave_rx_data(SPI.slave_rx_data),
   .slave_tx_data(SPI.slave_tx_data),
   .master_tx_data(SPI.master_tx_data),
   .master_rx_data(SPI.master_rx_data)
 );

  spi_slave #(1'b1,1'b1,8) dut_spi(
    .sclk(SPI.sCLK),
    .reset_n(SPI.i_rst),
    .ss_n(SPI.CS),
    .mosi(SPI.MOSI),
    .rx_req(SPI.rx_reg),
    .tx_load_en(SPI.load_en),
    .tx_load_data(SPI.slave_tx_data),
    .rx_data(SPI.slave_rx_data),
    .miso(SPI.MISO)
  );

  initial begin
    import uvm_pkg::uvm_config_db;
    uvm_config_db #(virtual spi_driver_BFM) ::set(null, "uvm_test_top", "SPI_drv_bfm", SPI_drv_bfm);
    uvm_config_db #(virtual spi_monitor_BFM)::set(null, "uvm_test_top", "SPI_mon_bfm", SPI_mon_bfm);
  end

  initial begin
    i_rst = 1'b0;
	 #62ns;
	 i_rst = ~i_rst;
  end

	//Clock Generation
  initial begin
    i_clk = 0;
    forever begin
      i_clk = ~i_clk;
      #1ns;
    end
  end

  initial begin
    run_test();
    #100ns;
  end

  initial begin
     $dumpfile("top.vcd");
     $dumpvars(0,spi_tb_top);
     #73700ns;
     $finish;
  end 

endmodule:spi_tb_top
