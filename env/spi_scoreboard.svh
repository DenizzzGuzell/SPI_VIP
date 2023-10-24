class spi_scoreboard#(int DATA_BYTE_WIDTH=1) extends uvm_scoreboard;
  `uvm_component_utils(spi_scoreboard)

  uvm_analysis_imp#(spi_seq_item, spi_scoreboard) spi_mon;
  spi_agent_config scr_cfg;

  spi_seq_item transactions[$];

    //actual variables
    logic [DATA_BYTE_WIDTH*8-1:0] actual_slave_rx_data;//needs to equal master tx data
    logic [DATA_BYTE_WIDTH*8-1:0] actual_master_rx_data;//needs to equal master rx data

    //expected variables
    logic [DATA_BYTE_WIDTH*8+8-1:0] expected_master_tx_data;//vip seq_item tx_data
    logic [DATA_BYTE_WIDTH*8-1:0] expected_slave_tx_data;//vip seq_item slave_tx_data

    //communication configurations
    logic [1:0] mode;
	  int sclk_period;
    int data_width;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "build_phase", UVM_LOW)
    super.build_phase(phase);
    if (! uvm_config_db #(spi_agent_config) :: get(this, "", "spi_agent_config", scr_cfg)) begin
       `uvm_fatal (get_type_name(), "Didn't get CFG object at Scoreboard!")
    end
    spi_mon = new("spi_mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "connect_phase", UVM_LOW)
    super.connect_phase(phase);
  endfunction: connect_phase

  function void write(spi_seq_item req);
    transactions.push_back(req);
  endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
      spi_seq_item trans;
      wait((transactions.size() != 0));
      `uvm_info(get_type_name(), "compare_task", UVM_LOW)
      trans = transactions.pop_front();
      //assignment of variables
      actual_slave_rx_data        = trans.slave_rx_data;
      actual_master_rx_data       = trans.master_rx_data;

      expected_master_tx_data     = trans.master_tx_data[DATA_BYTE_WIDTH*8-1:0];
      expected_slave_tx_data      = trans.slave_tx_data;

      mode                = {scr_cfg.CPOL, scr_cfg.CPHA};
      sclk_period         =  scr_cfg.sCLK_Period;
      data_width          =  DATA_BYTE_WIDTH*8;
       //printing all
      `uvm_info(get_type_name(),$sformatf("Configuration variables:: Data Size:%d, Mode:%d, Spi Clock Period:%d",data_width,mode,sclk_period),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("(Expected) master(VIP) sended data:%0h    Actual Slave(DUT) received  data:%0h (MOSI)",expected_master_tx_data,actual_slave_rx_data),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("(Expected) master(VIP) received data:%0h  Actual Slave(DUT) sended  data:%0h (MISO)",expected_slave_tx_data,actual_master_rx_data),UVM_LOW)
		//compare logic
      if(expected_master_tx_data == actual_slave_rx_data) begin
        if(expected_slave_tx_data == actual_master_rx_data) begin
          `uvm_info(get_type_name(),$sformatf("Transaction Passed!"),UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),$sformatf("Transaction Failed! Slave did not send expected data"))
        end
      end else if(expected_slave_tx_data == actual_master_rx_data) begin
        `uvm_error(get_type_name(),$sformatf("Transaction Failed! Slave did not receive expected data"))
      end else begin
        `uvm_error(get_type_name(),$sformatf("Transaction Failed! Slave did not receive and send expected data"))
      end
    end
  endtask: run_phase

    virtual function void check_phase (uvm_phase phase);

	 endfunction : check_phase

endclass
