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

entity loseScreen is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  enableShow_i : in  STD_LOGIC;
           losePixel_o : out  STD_LOGIC);
end loseScreen;

architecture Behavioral of loseScreen is

component ramLose is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 139));
end component;

--signali
constant loseH : integer := 22;
constant loseW : integer := 140;

constant xLose : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(319, 10);
constant yLose : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(200, 10);

signal addrOUTRam : STD_LOGIC_VECTOR (4 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 139);
signal dataOUTRam : STD_LOGIC_VECTOR (7 downto 0);

signal losePixel: STD_LOGIC := '0';

begin

-- porti
loseRam : ramLose
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

losePixel_o <= losePixel;

	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			if(rst_i = '0') then
				losePixel <= '0';
				addrOUTRam <= "00000";
			else
				losePixel <= '0';
				addrOUTRam <= "00000";
			
				if(x_i >= xLose AND x_i <= (xLose + loseW) AND y_i >= yLose AND y_i <= (yLose + loseH)) then
					addrOUTRam <= y_i(4 downto 0) - yLose(4 downto 0);
					dataOUTRam <= x_i(7 downto 0) - xLose(7 downto 0);
					
					if(returnRam(conv_integer(dataOUTRam)) = '1') then
						if(enableShow_i = '1') then
							losePixel <= '1';
						else
							losePixel <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	
end Behavioral;

