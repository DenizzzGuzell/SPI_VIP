import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_agent_config extends uvm_object;
 `uvm_object_utils(spi_agent_config)

//Configuration variables
  virtual spi_driver_BFM    cfg_drv_bfm;  // virtual driver BFM
  virtual spi_monitor_BFM   cfg_mon_bfm;  // virtual monitor BFM
  
   int DATA_BYTE_WIDTH;  
   int MAX_SLAVE_NUMBER;
   time sCLK_Period;
   bit CPOL;
   bit CPHA;
  
function new(string name="spi_agent_config");
  super.new(name);
endfunction

function spi_agent_config get_config( uvm_component c );
  spi_agent_config t;

  if (!uvm_config_db #(spi_agent_config)::get(c, "", "spi_agent_config", t) )
     `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration t from uvm_config_db. Have you set() it?"))
  return t;
endfunction
  
endclass: spi_agent_config