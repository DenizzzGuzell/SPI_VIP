class spi_seq_item#(int DATA_BYTE_WIDTH=1) extends uvm_sequence_item;
  `uvm_object_param_utils(spi_seq_item)

  //Chip select signals
  bit sCLK;
  bit CS;

  //MOSI MISO Signals
  logic MOSI;
  logic MISO;

  // Transaction Data's
  randc logic [DATA_BYTE_WIDTH*8+8-1:0]master_tx_data;//mosi hattının yazıldığı data
  logic [DATA_BYTE_WIDTH*8-1:0]master_rx_data;//masterda toplanan miso datası

  randc logic [DATA_BYTE_WIDTH*8-1:0]slave_tx_data;//miso hattını yazması için DUT a verdiğimiz data
  logic [DATA_BYTE_WIDTH*8-1:0]slave_rx_data;//mosinin slavede toplanmış datası

  //Constructor block
  function new (string name = "spi_seq_item");
    super.new(name);
  endfunction

  //Method block given in meeting
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();

  constraint c {master_tx_data[DATA_BYTE_WIDTH*8+8-1 : DATA_BYTE_WIDTH*8] == 0;};
endclass  : spi_seq_item

//Externed methods assignment block
function void spi_seq_item::do_copy(uvm_object rhs);
	spi_seq_item dc;
  `uvm_info(get_type_name(), "spi_seq_item_do_copy", UVM_LOW)
    if(!$cast(dc, rhs)) begin
        uvm_report_error("spi_seq_item -> do_copy:", "Cast failed");
      return;
 	end
    super.do_copy(rhs);
    slave_rx_data = dc.slave_rx_data;
    slave_tx_data = dc.slave_tx_data;
    master_tx_data  = dc.master_tx_data;
    master_rx_data  = dc.master_rx_data;
    MOSI     = dc.MOSI;
    MISO     = dc.MISO;
	  CS       = dc.CS ;
endfunction : do_copy

function string spi_seq_item::convert2string();
  string contents;
  contents = super.convert2string();
  `uvm_info(get_type_name(), "spi_seq_item_convert2string", UVM_LOW)
  $sformat(contents, "%s slave_rx_data  = 0x%0h", contents, slave_rx_data);
  $sformat(contents, "%s slave_tx_data  = 0x%0h", contents, slave_tx_data);
  $sformat(contents, "%s master_tx_data  = 0x%0h", contents, master_tx_data);
  $sformat(contents, "%s master_rx_data  = 0x%0h", contents, master_rx_data);
  $sformat(contents, "%s MOSI = %b", contents, MOSI);
  $sformat(contents, "%s MISO = %b", contents, MISO);
  $sformat(contents, "%s CS   = %b", contents, CS);
  return contents;
endfunction : convert2string

function bit spi_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  spi_seq_item t;
  `uvm_info(get_type_name(), "spi_seq_item_do_compare", UVM_LOW)
  if(!$cast(t, rhs)) begin
   return 0;
  end
  return ((super.do_compare(t, comparer))   &&
          (slave_rx_data = t.slave_rx_data) &&
          (slave_tx_data = t.slave_tx_data) &&
          (master_rx_data  == t.master_rx_data)  		    &&
          (master_tx_data == t.master_tx_data)  	        &&
          (MOSI == t.MOSI)    			    &&
          (MISO == t.MISO)    			    &&
          (CS   == t.CS));
endfunction : do_compare
