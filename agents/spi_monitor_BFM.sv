interface spi_monitor_BFM #(int DATA_BYTE_WIDTH=1)(
  input bit CS,
  input logic [DATA_BYTE_WIDTH*8-1:0]slave_rx_data,
  input logic [DATA_BYTE_WIDTH*8+8-1:0]slave_tx_data,
  input logic [DATA_BYTE_WIDTH*8-1:0]master_tx_data,
  input logic [DATA_BYTE_WIDTH*8+8-1:0]master_rx_data
);
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_agent_pkg::*;

  spi_agent_config m_cfge;
  spi_monitor proxy;

task run();
  spi_seq_item cloned_item;
  spi_seq_item spi_mon_req;
  spi_mon_req = spi_seq_item#(1)::type_id::create("spi_mon_req");

  `uvm_info("spi_monitor_BFM", "monitor_BFM_run", UVM_LOW)
      forever begin
        @(posedge CS)
          #125ns;
          spi_mon_req.master_rx_data = master_rx_data;
          spi_mon_req.master_tx_data = master_tx_data;
          spi_mon_req.slave_rx_data = slave_rx_data;
          spi_mon_req.slave_tx_data = slave_tx_data;
          `uvm_info("spi_monitor_BFM", "monitor_BFM_send_sCLK", UVM_LOW)
          $cast(cloned_item, spi_mon_req.clone());
          proxy.notify_transaction(cloned_item);
      end
endtask: run
endinterface

