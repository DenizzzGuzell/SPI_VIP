class spi_driver extends uvm_driver #(spi_seq_item, spi_seq_item);
  `uvm_component_utils(spi_driver)

virtual spi_driver_BFM drv_bfm;

spi_agent_config drv_cfg;

extern function new(string name = "spi_driver", uvm_component parent = null);
extern task run_phase(uvm_phase phase);
extern function void build_phase(uvm_phase phase);

endclass: spi_driver

  function spi_driver::new(string name = "spi_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `get_config(spi_agent_config, drv_cfg, "spi_agent_config")
   drv_bfm = drv_cfg.cfg_drv_bfm;
  `uvm_info(get_type_name(), "driver_build_phase", UVM_LOW)
endfunction: build_phase

task spi_driver::run_phase(uvm_phase phase);
  forever begin
     spi_seq_item drv_req;
     drv_bfm.spi_drv_cfg = drv_cfg;
    `uvm_info(get_type_name(), "driver_run_phase", UVM_LOW)
     drv_bfm.clear_signals(drv_req);
     seq_item_port.get_next_item(drv_req);
     drv_bfm.drive(drv_req);
	  #100ns;
     seq_item_port.item_done();
   end

endtask: run_phase
