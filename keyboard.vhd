----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:30:12 08/14/2017 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           kbdclk_i : in  STD_LOGIC;
           kbddata_i : in  STD_LOGIC;
           dataK_o : out  STD_LOGIC_VECTOR (7 downto 0); ---
           readyK_o : out  STD_LOGIC);
end keyboard;

architecture Behavioral of keyboard is

component neg
    Port ( clk_i : in  STD_LOGIC;
           rst_i  : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end component;

component kontrolnaEnota is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           pulse_i : in  STD_LOGIC;
           data_i : in  STD_LOGIC;
           shren_o : out  STD_LOGIC;
			  ready_o : out  STD_LOGIC);
end component;

component pomikalniRegister
    Port ( clk_i : in  STD_LOGIC;
           rst_i  : in  STD_LOGIC;
           shren_i : in  STD_LOGIC;
           data_i : in  STD_LOGIC;
           data_o : out  STD_LOGIC_VECTOR (8 downto 0));
end component;

component Dcelica is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           desync_i : in  STD_LOGIC;
           sync_o : out  STD_LOGIC);
end component;

signal SYNCKBDDATA: STD_LOGIC;
signal SYNCKBDCLK: STD_LOGIC;
signal pulse: STD_LOGIC;
signal ready: STD_LOGIC;
signal shift_signal: STD_LOGIC;
signal data: STD_LOGIC_VECTOR(8 downto 0);

--type state_type is (st_IDLE, st_START, st_B0, st_B1, st_B2, st_B3,
--							st_B4, st_B5, st_B6, st_B7, st_PAR);
--signal state, next_state : state_type;

begin

	Negedge : neg
	port map 
	(
		clk_i => clk_i,
		rst_i  => rst_i ,
		input => SYNCKBDCLK,
		output => pulse
	);
	
	ShiftReg : pomikalniRegister
	port map 
	(
		clk_i => clk_i,
		rst_i  => rst_i ,
		shren_i => shift_signal,
		data_i => SYNCKBDDATA,
		data_o => data
	);
	
	DClk : Dcelica
	port map	(
		clk_i => clk_i,
		rst_i  => rst_i ,
		desync_i => kbdclk_i,
		sync_o => SYNCKBDCLK
	);
	
	DData : Dcelica
	port map	(
		clk_i => clk_i,
		rst_i  => rst_i ,
		desync_i => kbddata_i,
		sync_o => SYNCKBDDATA
	);
	
	kontrolnaEnota1 : kontrolnaEnota
	port map 
	(
		clk_i => clk_i,
		rst_i  => rst_i ,
		pulse_i => pulse,
		data_i => SYNCKBDDATA,
		shren_o => shift_signal,
		ready_o => ready
	);

	dataK_o <= data(7 downto 0);
	-- parity check
	readyK_o <= ready AND (data(8) xor data(7) xor data(6) xor data(5) xor data(4) xor data(3) xor data(2) xor data(1) xor data(0));
	
end Behavioral;

