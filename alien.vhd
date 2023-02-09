----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:29 08/31/2017 
-- Design Name: 
-- Module Name:    alien - Behavioral 
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

entity alien is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
			  on_i : in  STD_LOGIC;
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
           alienX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           alienY_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  start_i : in  STD_LOGIC;
           hit_i : in  STD_LOGIC;
			  speedEnable_i : in  STD_LOGIC;
           rEdge_i : in  STD_LOGIC;
           lEdge_i : in  STD_LOGIC;
           alienPixel_o : out  STD_LOGIC);
end alien;

architecture Behavioral of alien is

component alienRam is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (5 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 38));
end component;

--signali
signal alienX : STD_LOGIC_VECTOR (9 downto 0) := alienX_i;
signal alienY : STD_LOGIC_VECTOR (9 downto 0) := alienY_i;
constant alienH : integer := 16;
constant alienW : integer := 39;

signal speedEnable : STD_LOGIC;

signal addrOUTRam : STD_LOGIC_VECTOR (5 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 38);
signal dataOUTRam : STD_LOGIC_VECTOR (5 downto 0);
signal shape: STD_LOGIC := '0';

signal alienPixel: STD_LOGIC := '0';

signal left: STD_LOGIC := '0';
signal right: STD_LOGIC := '0';
signal down: STD_LOGIC := '0';

begin
-- porti
ramAlien : alienRam
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

-------------------------------------------------

alienPixel_o <= alienPixel;


	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			alienPixel <= '0';
			addrOUTRam <= "000000";
		
			if(x_i >= alienX AND x_i <= (alienX + alienW) AND y_i >= alienY AND y_i <= (alienY + alienH)) then
				if(shape = '0') then
					addrOUTRam <= y_i(5 downto 0) - alienY(5 downto 0);
				else
					addrOUTRam <= y_i(5 downto 0) - alienY(5 downto 0) + 17;
				end if;
				
				dataOUTRam <= x_i(5 downto 0) - alienX(5 downto 0);
				
				if(returnRam(conv_integer(dataOUTRam)) = '1') then
					if(hit_i = '0') then
						alienPixel <= '1';
					else
						alienPixel <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(clk_i) --Premikanje
	begin
		if clk_i'event and clk_i = '1' then
			--down <= '0';
			if(rst_i = '0') then
				alienX <= alienX_i;
				alienY <= alienY_i;
				right <= '0';
				left <= '0';
				down <= '0';
				shape <= '0';
			else
				if(start_i = '0') then
					right <= '1';
					left <= '0';
					down <= '0';
				elsif(rEdge_i = '1') then
					right <= '0';
					left <= '1';
					down <= '1';
				elsif(lEdge_i = '1') then
					right <= '1';
					left <= '0';
					down <= '1';
				end if;
				
				if(speedEnable_i = '1') then
					if(shape = '0') then
						shape <= '1';
					else
						shape <= '0';
					end if;
					if(right = '1') then
						alienX <= alienX + 4;
					elsif(left = '1') then
						alienX <= alienX - 4;
					end if;
					if(down = '1') then
						alienY <= alienY + 8;
						down <= '0';
					end if;
				end if;
				
			end if;
		end if;
	end process;

end Behavioral;

