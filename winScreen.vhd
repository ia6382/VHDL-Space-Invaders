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

entity winScreen is
	 Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  enableShow_i : in  STD_LOGIC;
           winPixel_o : out  STD_LOGIC);
end winScreen;

architecture Behavioral of winScreen is

component ramWin is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (4 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 62));
end component;

--signali
constant winH : integer := 22;
constant winW : integer := 63;

constant xWin : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(250, 10);
constant yWin : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(200, 10);

signal addrOUTRam : STD_LOGIC_VECTOR (4 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 62);
signal dataOUTRam : STD_LOGIC_VECTOR (5 downto 0);

signal winPixel: STD_LOGIC := '0';

begin

-- porti
winRam : ramWin
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

winPixel_o <= winPixel;

	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			if(rst_i = '0') then
				winPixel <= '0';
				addrOUTRam <= "00000";
			else
				winPixel <= '0';
				addrOUTRam <= "00000";
			
				if(x_i >= xWin AND x_i <= (xWin + winW) AND y_i >= yWin AND y_i <= (yWin + winH)) then
					addrOUTRam <= y_i(4 downto 0) - yWin(4 downto 0);
					dataOUTRam <= x_i(5 downto 0) - xWin(5 downto 0);
					
					if(returnRam(conv_integer(dataOUTRam)) = '1') then
						if(enableShow_i = '1') then
							winPixel <= '1';
						else
							winPixel <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	
end Behavioral;

