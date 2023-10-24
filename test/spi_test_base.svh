class spi_test_base extends uvm_test;
  `uvm_component_utils (spi_test_base)

function new (string name, uvm_component parent = null);
  super.new(name, parent);
endfunction

  spi_environment m_top_env;
  spi_env_config m_env_cfg;
  spi_agent_config m_cfge;

function void build_phase (uvm_phase phase);
  super.build_phase (phase);
  m_env_cfg = spi_env_config::type_id::create("m_env_cfg");
  m_cfge = spi_agent_config::type_id::create("m_cfge");
  m_top_env = spi_environment::type_id::create ("m_top_env", this);
  `uvm_info(get_type_name(), "build_phase", UVM_LOW)
  configuration(m_cfge);

  if(!uvm_config_db #(virtual spi_driver_BFM)::get(this, "", "SPI_drv_bfm", m_cfge.cfg_drv_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface drv_bfm from uvm_config_db. Have you set() it?")
  if(!uvm_config_db #(virtual spi_monitor_BFM)::get(this, "", "SPI_mon_bfm",m_cfge.cfg_mon_bfm))
	`uvm_fatal("VIF CONFIG", "Cannot get() BFM interface mon_bfm from uvm_config_db. Have you set() it?")

  m_env_cfg.m_cfge = m_cfge;
  uvm_config_db #(spi_env_config)::set(this, "*", "spi_env_config", m_env_cfg);
endfunction

function void configuration (spi_agent_config cfg);

    cfg.DATA_BYTE_WIDTH = 1;
    cfg.sCLK_Period = 20ns;
    cfg.CPOL = 1;
    cfg.CPHA = 1;

endfunction

endclass
