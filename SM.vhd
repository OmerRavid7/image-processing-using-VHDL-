library ieee;
library work ;
use work.median_filter.all;
--use work.RAM.all;
--use work.ROM.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity SM is

port(

	clk 	: in std_logic;
	rst 	: in std_logic;
	start	: in std_logic;
	
	read_address : out std_logic_vector (7 downto 0);--send out to read from ROM
	write_address : out std_logic_vector (7 downto 0);--send out to write to RAM
	write_en : out std_logic;
	done 	: out std_logic
	);
end entity SM;

architecture arc_SM of SM is 

type state is (reset , first_line , all_line , last_line , stop);
signal CS , NS : state;
signal counter : std_logic_vector (7 downto 0);
signal counter_en : std_logic;

begin

process (clk,rst) is
begin

	if (rst = '1') then
		CS <= reset;
		counter <= (others => '0');
	elsif rising_edge (clk) then
		CS <= NS;
		if counter_en = '1' then
			counter <= counter + '1';
		else 
			counter <= (others => '0'); -- delete
		end if;
	end if;
end process;


process (CS , start , counter) is
begin

		read_address <= (others => '0');
		write_address <= (others => '0');
		write_en <= '0';
		done <= '0' ;
		counter_en <= '0';
		NS <= CS;
		
case CS is

	when reset => 
		if start = '1' then
			NS <= first_line ;
			end if;
		
	when first_line => 
		read_address <= (others => '0');
		NS <= all_line ;
	
	when all_line => 
		counter_en <= '1';
		read_address <= counter;
		
		if counter >= "00000010" then
			write_en <= '1';
		end if;
		write_address <= counter -"00000010";
		
		if counter = "11111111" then 
			NS <= last_line;
		end if;
		
		
	when last_line => 
		read_address	 <= "11111111" ;
		write_address 	<= "11111111" ;
		write_en <= '1';
		NS <= stop;		
	
	
	when stop => 
		counter_en <= '1';
		if counter = "00000011" then
			done <= '1';
			Ns <= reset;			
		end if;
		
	end case;
end process;

end architecture arc_SM ;
