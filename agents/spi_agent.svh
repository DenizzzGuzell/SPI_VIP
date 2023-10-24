class spi_agent extends uvm_component;
  `uvm_component_utils(spi_agent)

uvm_analysis_port#(spi_seq_item) mon_data;
spi_monitor   a_monitor;
spi_sequencer a_sequencer;
spi_driver    a_driver;

extern function new(string name = "spi_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: spi_agent


function spi_agent::new(string name = "spi_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_agent::build_phase(uvm_phase phase);
  spi_agent_config m_cfge;
  `uvm_info(get_type_name(), "build_phase", UVM_LOW)
  `get_config(spi_agent_config, m_cfge, "spi_agent_config")
  a_monitor = spi_monitor::type_id::create("a_monitor", this);
  a_monitor.m_cfge = m_cfge;
  a_driver = spi_driver::type_id::create("a_driver", this);
  a_driver.drv_cfg = m_cfge;
  a_sequencer = spi_sequencer::type_id::create("a_sequencer", this);
endfunction: build_phase

function void spi_agent::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "connect_phase", UVM_LOW)
  mon_data = a_monitor.mon_data;
  a_driver.seq_item_port.connect(a_sequencer.seq_item_export);
endfunction: connect_phase
