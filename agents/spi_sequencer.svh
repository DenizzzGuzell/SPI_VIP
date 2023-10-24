class spi_sequencer extends uvm_sequencer#(spi_seq_item);

  `uvm_sequencer_utils(spi_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "sequencer_constructor", UVM_LOW)
  endfunction : new

endclass 