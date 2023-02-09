----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:12:19 10/27/2015 
-- Design Name: 
-- Module Name:    SedemSeg - Behavioral 
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

entity SedemSeg is
    Port (num : in  STD_LOGIC_VECTOR(7 downto 0);
			reset: in  STD_LOGIC;
			clk: in  STD_LOGIC;
			--rdy : in STD_LOGIC;
			seg : out  STD_LOGIC_VECTOR(6 downto 0);
			an : out  STD_LOGIC_VECTOR(7 downto 0)
			);
end SedemSeg;

architecture Behavioral of SedemSeg is

component prescaler is
	Generic(data_width:integer := 27;
				data_value:integer := 99999999
	);
	Port (clk : in  STD_LOGIC;
			reset: in STD_LOGIC;
         enable : out  STD_LOGIC
	);
end component;

signal count: std_logic_vector(3 downto 0);
signal en: std_logic;
signal selec: std_logic;

begin

	pr2 : prescaler
	generic map (
		data_width => 17,
		data_value => 99999
	)
	port map (
		clk => clk,
		reset => reset,
		enable => selec
	);

	process(clk)
		begin	
			if clk'event and clk = '1' then
				if(reset= '0') then
					an <= "11111111";
				else
					--if (rdy = '1') then
						if(selec = '1') then
							if(en = '0')then
								en <= '1';
								an <= "11111110";
								count <= num(3 downto 0);
							else
								en <= '0';
								an <= "11111101";
								count <= num(7 downto 4);
							end if;
						end if;
					--end if;
				end if ;
			end if;
		end process ;
		
	process(count)
		begin
		case count is 
			when "0000" => seg <= "1000000";
			when "0001" => seg <= "1111001";
			when "0010" => seg <= "0100100";
			when "0011" => seg <= "0110000";
			when "0100" => seg <= "0011001";
			when "0101" => seg <= "0010010";
			when "0110" => seg <= "0000010";
			when "0111" => seg <= "1111000";
			when "1000" => seg <= "0000000";
			when "1001" => seg <= "0010000";
			when "1010" => seg <= "0001000";
			when "1011" => seg <= "0000011";
			when "1100" => seg <= "1000110";
			when "1101" => seg <= "0100001";
			when "1110" => seg <= "0000110";
			when "1111" => seg <= "0001110";
			when others=> seg <= "1111111";
		end case;
	end process;

end Behavioral;

