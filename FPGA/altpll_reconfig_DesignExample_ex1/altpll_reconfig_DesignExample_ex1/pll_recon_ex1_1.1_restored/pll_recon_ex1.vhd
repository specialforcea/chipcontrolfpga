library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity pll_recon_ex1 is

	PORT
	(
		areset				: IN STD_LOGIC  := '0';
		clock				: IN STD_LOGIC ;
		inclk0				: IN STD_LOGIC  := '0';
		
		counter_type		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		counter_param		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		data_in				: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		
		reset				: IN STD_LOGIC ;
		reconfig			: IN STD_LOGIC ;
		read_param			: IN STD_LOGIC ;
		write_param			: IN STD_LOGIC ;
		
		c0					: OUT STD_LOGIC ;
		locked				: OUT STD_LOGIC; 
				
		pll_scandataout_sig	: out STD_LOGIC ;
		
		busy				: OUT STD_LOGIC ;
		data_out			: OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
		
		pll_scanclk_sig		: OUT STD_LOGIC ;
		pll_scanaclr_sig	: OUT STD_LOGIC ;
		pll_scandata_sig	: OUT STD_LOGIC 
	);

end entity;



architecture behav of pll_recon_ex1 is

signal  scanclk_sig			: STD_LOGIC ;
signal  scandata_sig		: STD_LOGIC ;
signal  scanaclr_sig		: STD_LOGIC;
signal  scandataout_sig		: STD_LOGIC ;


component pll_reconfig
	PORT
	(
		reconfig			: IN STD_LOGIC ;
		counter_type		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		pll_scandataout		: IN STD_LOGIC ;
		read_param			: IN STD_LOGIC ;
		reset				: IN STD_LOGIC ;
		data_in				: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock				: IN STD_LOGIC ;
		counter_param		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		write_param			: IN STD_LOGIC ;
		pll_scanclk			: OUT STD_LOGIC ;
		pll_scanaclr		: OUT STD_LOGIC ;
		busy				: OUT STD_LOGIC ;
		data_out			: OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
		pll_scandata		: OUT STD_LOGIC 
	);
end component;


component reconfig_pll
	PORT
	(
		inclk0			: IN STD_LOGIC  := '0';
		scanaclr		: IN STD_LOGIC  := '0';
		scandata		: IN STD_LOGIC  := '1';
		areset			: IN STD_LOGIC  := '0';
		scanclk			: IN STD_LOGIC  := '1';
		c0				: OUT STD_LOGIC ;
		scandataout		: OUT STD_LOGIC ;
		locked			: OUT STD_LOGIC 
	);
end component;




begin

pll_reconfig_inst : pll_reconfig 

	PORT MAP (
		reconfig	 	=> reconfig,
		counter_type	=> counter_type,
		pll_scandataout	=> scandataout_sig,
		read_param	 	=> read_param,
		reset	 		=> reset,
		data_in	 		=> data_in,
		clock	 		=> clock,
		counter_param	=> counter_param,
		write_param		=> write_param,
		pll_scanclk	 	=> scanclk_sig,
		pll_scanaclr	=> scanaclr_sig,
		busy	 		=> busy,
		data_out	 	=> data_out,
		pll_scandata	=> scandata_sig
	);


reconfig_pll_inst : reconfig_pll 

	PORT MAP (
		inclk0	 	 => inclk0,
		scanaclr	 => scanaclr_sig,
		scandata	 => scandata_sig,
		areset	 	 => areset,
		scanclk	 	 => scanclk_sig,
		c0			 => c0,
		scandataout	 => scandataout_sig,
		locked	 	 => locked
	);
	
pll_scanclk_sig			<= scanclk_sig ;
pll_scandata_sig		<= scandata_sig ;
pll_scanaclr_sig		<= scanaclr_sig;
pll_scandataout_sig		<= scandataout_sig;	

end behav;

