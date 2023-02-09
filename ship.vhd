----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:37:29 08/26/2017 
-- Design Name: 
-- Module Name:    ship - Behavioral 
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
use IEEE. STD_LOGIC_ARITH. ALL;
use IEEE. STD_LOGIC_UNSIGNED. ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ship is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           on_i : in  STD_LOGIC;
			  readyK_i : in  STD_LOGIC;
           dataK_i : in  STD_LOGIC_VECTOR (7 downto 0);
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  shipX_o : out STD_LOGIC_VECTOR (9 downto 0);
           shipY_o : out STD_LOGIC_VECTOR (9 downto 0);
           shipPixel_o : out  STD_LOGIC);
end ship;

architecture Behavioral of ship is

component ramShip is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 54));
end component;

component speedPrescaler is
	Generic( data_width:integer := 19;
			data_value:integer := 500000
		 );
	Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           onOff_i : in  STD_LOGIC;
           speedEnable_o : out  STD_LOGIC);
end component;


--signali
signal xShip : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(319, 10);
constant yShip : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(429, 10);
constant shipH : integer := 21;
constant shipW : integer := 54;

signal speedEnable : STD_LOGIC;

signal addrOUTRam : STD_LOGIC_VECTOR (4 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 54);
signal dataOUTRam : STD_LOGIC_VECTOR (5 downto 0);

signal shipPixel: STD_LOGIC := '0';
signal leftKey: STD_LOGIC;
signal rightKey: STD_LOGIC;

begin
-- porti
ladjaRam : ramShip
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

hitrostPrescaler : speedPrescaler
generic map ( data_width => 19,
			data_value => 500000
)
port map (
	clk_i => clk_i,
	rst_i => rst_i,
	onOff_i => on_i,
	speedEnable_o => speedEnable
);

--logika

leftKey <= '1' when (dataK_i = 28 and readyK_i = '1') else '0';
rightKey <= '1' when (dataK_i = 35 and readyK_i = '1') else '0';

shipX_o <= xShip;
shipY_o <= yShip;
shipPixel_o <= shipPixel;

	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			shipPixel <= '0';
			addrOUTRam <= "00000";
		
			if(x_i >= xShip AND x_i <= (xShip + shipW) AND y_i >= yShip AND y_i <= (yShip + shipH)) then
				addrOUTRam <= y_i(4 downto 0) - yShip(4 downto 0);
				dataOUTRam <= x_i(5 downto 0) - xShip(5 downto 0);
				
				if(returnRam(conv_integer(dataOUTRam)) = '1') then
					shipPixel <= '1';
				end if;
			end if;
		end if;
	end process;
	
	process(clk_i) --Premikanje
	begin
		if clk_i'event and clk_i = '1' then
			if(rst_i = '0') then
				xShip <= conv_std_logic_vector(320, 10);
			end if;
			if(on_i = '1' AND speedEnable = '1') then
				if(leftKey = '1') then
					if(xShip > 31) then
							xShip <= xShip - 1;
					end if;
				elsif(rightKey = '1') then
					if((xShip + shipW) < 607) then
							xShip <= xShip + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

