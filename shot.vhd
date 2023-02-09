----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:52:39 08/30/2017 
-- Design Name: 
-- Module Name:    shot - Behavioral 
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

entity shot is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           on_i : in  STD_LOGIC;
           dataK_i : in  STD_LOGIC_VECTOR (7 downto 0);
           readyK_i : in  STD_LOGIC;
           shipX_i : in  STD_LOGIC_VECTOR (9 downto 0);
           shipY_i : in  STD_LOGIC_VECTOR (9 downto 0);
           x_i : in  STD_LOGIC_VECTOR (9 downto 0);
           y_i : in  STD_LOGIC_VECTOR (9 downto 0);
			  hitShot_i : in  STD_LOGIC;
           shotPixel_o : out  STD_LOGIC);
end shot;

architecture Behavioral of shot is

component shotRam is
    Port ( --clk_i : in  STD_LOGIC;
           addrOUT_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_o : out  STD_LOGIC_VECTOR (0 to 2));
end component;

component speedPrescaler is
	Generic( data_width:integer := 18;
			data_value:integer := 200000
		 );
	Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           onOff_i : in  STD_LOGIC;
           speedEnable_o : out  STD_LOGIC);
end component;

--signali
signal shotX : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(1000, 10);
signal shotY : STD_LOGIC_VECTOR (9 downto 0) := conv_std_logic_vector(1000, 10);
constant shotH : integer := 10;
constant shotW : integer := 3;

signal speedEnable : STD_LOGIC;

signal addrOUTRam : STD_LOGIC_VECTOR (3 downto 0);
signal returnRam : STD_LOGIC_VECTOR (0 to 2);
signal dataOUTRam : STD_LOGIC_VECTOR (1 downto 0);

signal shotPixel: STD_LOGIC := '0';
signal shootKey: STD_LOGIC;
signal shootEnable: STD_LOGIC;

begin

-- porti
izstrelekRam : shotRam
port map (
	--clk_i => clk_i,
	addrOUT_i => addrOUTRam,
	data_o => returnRam
);

hitrostPrescaler : speedPrescaler
generic map ( data_width => 18,
			data_value => 200000
)
port map (
	clk_i => clk_i,
	rst_i => rst_i,
	onOff_i => on_i,
	speedEnable_o => speedEnable
);

--logika

shootKey <= '1' when (dataK_i = 29 and readyK_i = '1') else '0';

shotPixel_o <= shotPixel;

	process(clk_i) --RISANJE
	begin
		if clk_i'event and clk_i = '1' then
			shotPixel <= '0';
			addrOUTRam <= "0000";
		
			if(shootEnable = '1') then
				if(x_i >= shotX AND x_i <= (shotX + shotW) AND y_i >= shotY AND y_i <= (shotY + shotH)) then
					addrOUTRam <= y_i(3 downto 0) - shotY(3 downto 0);
					dataOUTRam <= x_i(1 downto 0) - shotX(1 downto 0);
					
					if(returnRam(conv_integer(dataOUTRam)) = '1') then
						shotPixel <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(clk_i) --Premikanje
	begin
		if clk_i'event and clk_i = '1' then
			if(rst_i = '0') then
				shootEnable <= '0';
				shotX <= conv_std_logic_vector(1000, 10);
				shotY <= conv_std_logic_vector(1000, 10);	
			else
			
				if(hitShot_i = '1') then
					shootEnable <= '0';
					shotX <= conv_std_logic_vector(1000, 10);
					shotY <= conv_std_logic_vector(1000, 10);	
				end if;
			
				if(shootKey = '1' and shootEnable = '0') then
					shootEnable <= '1';
					shotX <= shipX_i + 27;
					shotY <= shipY_i;
				end if;
				
				if(shootEnable = '1') then
					if(speedEnable = '1') then
						if(shotY > 48) then
							shotY <= shotY - 1;
						else
							shootEnable <= '0';
							shotX <= conv_std_logic_vector(1000, 10);
							shotY <= conv_std_logic_vector(1000, 10);	
						end if;
					end if;
				end if;
				
			end if;
		end if;
	end process;
	
end Behavioral;

