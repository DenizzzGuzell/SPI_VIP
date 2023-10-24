//Read and Write test
class spi_wr_test extends spi_test_base;
`uvm_component_utils (spi_wr_test)
function new(string name = "spi_wr_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "build_phase", UVM_LOW)
  configuration(m_cfge);
endfunction: build_phase

function void configuration(spi_agent_config cfg);
    cfg.DATA_BYTE_WIDTH = 1;
    cfg.sCLK_Period = 20ns;
    cfg.CPOL = 1;
    cfg.CPHA = 1;
endfunction: configuration

task run_phase (uvm_phase phase);
  spi_wr_seq wr_seq = spi_wr_seq::type_id::create("wr_seq");
  super.run_phase (phase);
  phase.raise_objection(this, "spi_wr_test");
    wr_seq.start(m_top_env.agt.a_sequencer);
    #1000ns;
  phase.drop_objection(this, "spi_wr_test");
endtask
endclass
