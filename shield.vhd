----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:03 08/30/2017 
-- Design Name: 
-- Module Name:    shield - Behavioral 
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

entity shield is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  shieldX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           shieldY_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  hit_i : in  STD_LOGIC;
           shieldPixel_o : out  STD_LOGIC);
end shield;

architecture Behavioral of shield is

component ramShield is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (5 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 74));
end component;

--signali
constant shieldH : integer := 47;
constant shieldW : integer := 74;

signal addrOUTRam : STD_LOGIC_VECTOR (5 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 74);
signal dataOUTRam : STD_LOGIC_VECTOR (6 downto 0);

signal shieldPixel: STD_LOGIC := '0';

signal health : STD_LOGIC_VECTOR (3 downto 0) := conv_std_logic_vector(15, 4);

begin

-- porti
branikRam : ramShield
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

shieldPixel_o <= shieldPixel;

	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			if(rst_i = '0') then
				shieldPixel <= '0';
				addrOUTRam <= "000000";
				health <= "1111";
			else
				shieldPixel <= '0';
				addrOUTRam <= "000000";
				if(hit_i = '1') then
					health <= health - 1;
				end if;
			
				if(x_i >= shieldX_i AND x_i <= (shieldX_i + shieldW) AND y_i >= shieldY_i AND y_i <= (shieldY_i + shieldH)) then
					addrOUTRam <= y_i(5 downto 0) - shieldY_i(5 downto 0);
					dataOUTRam <= x_i(6 downto 0) - shieldX_i(6 downto 0);
					
					if(returnRam(conv_integer(dataOUTRam)) = '1') then
						if(health = 0) then
							shieldPixel <= '0';
						else
							shieldPixel <= '1';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	
end Behavioral;

