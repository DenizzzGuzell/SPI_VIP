//Read test
class spi_r_test extends spi_test_base;
`uvm_component_utils (spi_r_test)
function new(string name = "spi_r_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  configuration(m_cfge);
endfunction: build_phase

function void configuration(spi_agent_config cfg);
    cfg.DATA_BYTE_WIDTH = 1;
    cfg.sCLK_Period = 20ns;
    cfg.CPOL = 1;
    cfg.CPHA = 1;
endfunction: configuration

task run_phase (uvm_phase phase);
  spi_r_seq r_seq = spi_r_seq::type_id::create("r_seq");
  super.run_phase (phase);
  phase.raise_objection(this, "spi_r_test");
    r_seq.start(m_top_env.agt.a_sequencer);
    #1000ns;
  phase.drop_objection(this, "spi_r_test");
endtask
endclass
