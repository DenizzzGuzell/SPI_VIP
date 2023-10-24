class spi_environment extends uvm_env;
  
  spi_agent agt;
  spi_scoreboard scb;
  spi_env_config m_cfg;
  `uvm_component_utils(spi_environment)

  function new(string name="spi_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    if(!uvm_config_db #(spi_env_config)::get(this, "", "spi_env_config", m_cfg))
		`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration spi_env_config from uvm_config_db. Have you set() it?")
    uvm_config_db #(spi_agent_config)::set(this, "agt","spi_agent_config", m_cfg.m_cfge);
    uvm_config_db #(spi_agent_config)::set(this, "scb","spi_agent_config", m_cfg.m_cfge);
    agt=spi_agent::type_id::create("agt", this);
    scb=spi_scoreboard#(1)::type_id::create("scb", this);

  endfunction
    
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect_phase", UVM_LOW)
    agt.a_monitor.mon_data.connect(scb.spi_mon);
    `uvm_info(get_type_name(),"connect_phase, Connected monitor to scoreboard",UVM_LOW);
  endfunction
    
endclass
