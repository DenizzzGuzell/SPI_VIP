class spi_monitor extends uvm_monitor;

// UVM Factory Registration Macro
`uvm_component_utils(spi_monitor);

// Virtual Interface
virtual spi_monitor_BFM mon_bfm;

// Data Members
spi_agent_config m_cfge;
  
// Component Members
uvm_analysis_port #(spi_seq_item) mon_data;

// Standard UVM Methods:
extern function new(string name = "spi_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

// Proxy Methods:
extern function void notify_transaction(spi_seq_item item);
  
endclass: spi_monitor

function spi_monitor::new(string name = "spi_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void spi_monitor::build_phase(uvm_phase phase);
  `get_config(spi_agent_config, m_cfge, "spi_agent_config")
  mon_bfm = m_cfge.cfg_mon_bfm;
  mon_bfm.proxy = this;
  mon_data = new("mon_data", this);
  `uvm_info(get_type_name(), "build_phase", UVM_LOW)
endfunction: build_phase

task spi_monitor::run_phase(uvm_phase phase);
   mon_bfm.run();
  `uvm_info(get_type_name(), "run_phase", UVM_LOW)
endtask: run_phase

function void spi_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "report_phase", UVM_LOW)
endfunction: report_phase

function void spi_monitor::notify_transaction(spi_seq_item item);
  mon_data.write(item);
  //write makes items to writing analysis port.Only method for uvm_analysis_port which is TLM based void class is write. 
  `uvm_info(get_type_name(), "notify_transaction", UVM_LOW)
endfunction : notify_transaction
  
