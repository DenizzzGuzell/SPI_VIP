//write sequence
class spi_w_seq extends uvm_sequence #(spi_seq_item);
`uvm_object_utils(spi_w_seq)

spi_seq_item req;

function new(string name = "spi_w_seq");
  super.new(name);
endfunction

task body();
  `uvm_info(get_type_name(), "task:body", UVM_LOW)
  repeat(100) begin
    req = spi_seq_item#(1)::type_id::create("req");
    start_item(req);
    req.randomize() with {req.slave_tx_data == 0;};;
    `uvm_info(get_type_name(), $sformatf("New item generation : %s", req.convert2string()), UVM_HIGH)
    finish_item(req);
  end
endtask:body

endclass:spi_w_seq
