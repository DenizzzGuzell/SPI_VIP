class spi_env_config extends uvm_object;

	localparam string s_my_config_id = "spi_env_config";

	`uvm_object_utils(spi_env_config)

	spi_agent_config m_cfge;

	extern function new(string name = "spi_env_config");

	extern static function spi_env_config get_config(uvm_component c);

endclass: spi_env_config

function spi_env_config::new(string name = "spi_env_config");
	super.new(name);
endfunction: new

function spi_env_config spi_env_config::get_config(uvm_component c);
	spi_env_config t;

	if(!uvm_config_db #(spi_env_config)::get(c, "", s_my_config_id, t))
		`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

	return t;
endfunction: get_config
