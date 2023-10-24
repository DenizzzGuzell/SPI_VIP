interface spi_driver_BFM#(int DATA_BYTE_WIDTH=1)(
  input  bit MISO,

  output bit sCLK,
  output logic MOSI,
  output bit CS,
  output logic [DATA_BYTE_WIDTH*8-1:0]master_rx_data,
  output logic [DATA_BYTE_WIDTH*8-1:0]slave_tx_data,
  output logic [DATA_BYTE_WIDTH*8+8-1:0]master_tx_data,

  output bit load_en,
  output bit rx_reg
);
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_agent_pkg::*;

  logic [DATA_BYTE_WIDTH*8+8-1:0] temp_tx = 16'h0000;
  logic [DATA_BYTE_WIDTH*8-1:0] temp_rx = 8'h00;

  spi_agent_config spi_drv_cfg;

  task clear_signals(spi_seq_item spi_drv_req);
    CS = 1'b1;
    MOSI = 1'bz;
    sCLK = 1'b0;
	 load_en = 1'b0;
	 rx_reg = 1'b0;
  endtask


  task drive(spi_seq_item spi_drv_req);
    `uvm_info("spi_driver_BFM", "driver_BFM_drive", UVM_LOW)
  	fork begin
    master_tx_data = spi_drv_req.master_tx_data;//expected given mosi
    slave_tx_data  = spi_drv_req.slave_tx_data;//expected given miso
    `uvm_info("spi_driver_BFM", "driver_BFM_t_sCLK", UVM_LOW)
    CS = 1'b1;
    if      (spi_drv_cfg.CPOL == 0) sCLK = 1'b0;
    else if (spi_drv_cfg.CPOL == 1) sCLK = 1'b1;
    #(spi_drv_cfg.sCLK_Period*5/2);
    #(spi_drv_cfg.sCLK_Period*5/2);
	 load_en <= 1'b1;
    #(spi_drv_cfg.sCLK_Period/2); CS <= ~CS; load_en <= ~load_en;
    for(int i=0; i<spi_drv_cfg.DATA_BYTE_WIDTH*8+8; i++) begin
      #(spi_drv_cfg.sCLK_Period/2); sCLK <= ~sCLK;
      #(spi_drv_cfg.sCLK_Period/2); sCLK <= ~sCLK;
    end
    #(spi_drv_cfg.sCLK_Period/2); CS <= ~CS;
    #(spi_drv_cfg.sCLK_Period*7/2); rx_reg <= ~rx_reg;
    end
    begin
    	`uvm_info("spi_driver_BFM", "driver_BFM_t_data", UVM_LOW)
    MOSI = 1'bz;
    temp_tx = spi_drv_req.master_tx_data;
    if (spi_drv_cfg.CPHA == 1) begin
    @(negedge CS) begin
       MOSI = 1'bx;
    end
  end
    if(spi_drv_cfg.CPOL == 0 && spi_drv_cfg.CPHA == 0)begin
          @(negedge CS) begin
              MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
          end
          @(posedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
          end
      repeat(spi_drv_cfg.DATA_BYTE_WIDTH*8-1+8) begin
            @(negedge sCLK) begin
                MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
            end
            @(posedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
            end
          end
    end else if(spi_drv_cfg.CPOL == 0 && spi_drv_cfg.CPHA == 1)begin
      repeat(spi_drv_cfg.DATA_BYTE_WIDTH*8+8) begin
            @(posedge sCLK) begin
                MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
            end
            @(negedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
            end
          end
    end else if(spi_drv_cfg.CPOL == 1 && spi_drv_cfg.CPHA == 0)begin
          @(negedge CS) begin
                MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
          end
          @(negedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
          end
      repeat(spi_drv_cfg.DATA_BYTE_WIDTH*8-1+8) begin
            @(posedge sCLK) begin
                MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
            end
            @(negedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
            end
          end
    end else if(spi_drv_cfg.CPOL == 1 && spi_drv_cfg.CPHA == 1)begin
      repeat(DATA_BYTE_WIDTH*8+8) begin
            @(negedge sCLK) begin
                MOSI <= temp_tx[DATA_BYTE_WIDTH*8+8-1];
                temp_tx = temp_tx << 1;
            end
            @(posedge sCLK) begin
                temp_rx = temp_rx << 1;
                temp_rx[0] <= MISO;
            end
          end
  end
    if (spi_drv_cfg.CPHA == 1) begin
      @(posedge CS) begin
        MOSI = 1'bz;
      end
    end else if (spi_drv_cfg.CPHA == 0) begin
      if (spi_drv_cfg.CPOL == 0) begin
        @(negedge sCLK) begin
            MOSI = 1'bz;
        end
      end else if (spi_drv_cfg.CPOL == 1) begin
        @(posedge sCLK) begin
            MOSI = 1'bz;
        end
      end
    #(spi_drv_cfg.sCLK_Period/2); MOSI <= 1'bz;
    end
  end
  	join
    master_rx_data = temp_rx;//actual taken miso
endtask: drive

endinterface: spi_driver_BFM


