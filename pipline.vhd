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

entity pipline is

	generic(
		rom_pipe : string;
		ram_pipe : string 
		);
		
	port(

	read_address_rom : in std_logic_vector(7 downto 0);
	write_address_ram : in std_logic_vector (7 downto 0);
	write_en_ram : in std_logic;
--	done 	: in std_logic; -- maybe
	clk : in std_logic;
	rst : in std_logic
	
);
end entity pipline;

architecture arc_pipline of pipline is

component ROM is 
	generic(init_file_name : string);
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (1279 DOWNTO 0)
	);
end component;



component RAM IS
	generic (instname : string);
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (1279 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (1279 DOWNTO 0)
	);
END component;

signal q_rom : STD_LOGIC_VECTOR (1279 DOWNTO 0);
signal q_ram : STD_LOGIC_VECTOR (1279 DOWNTO 0);
signal data_to_ram : STD_LOGIC_VECTOR (1279 DOWNTO 0);
signal row_3_x 	: three_rows;			-- load 3 lines of pixels !Buffer!	

begin

	  rom_mem : ROM
	
				generic map( init_file_name => rom_pipe)
				
				port map(
					aclr => rst,
					address => read_address_rom ,
					clock => clk ,
					q => q_rom
				);

	  ram_mem : RAM
	
				generic map(instname => ram_pipe)
				
				port map(
				aclr => rst,
				address => write_address_ram,
				clock => clk,
				data => data_to_ram,
				wren => write_en_ram,
				q =>  q_ram
				);
			
data_to_ram <= pix_to_row_of_bit(median3d(row_3_x));

process(clk, rst)
	variable s 			: row_of_pix (0 to (row-1)); -- check row

	begin
	
			if rst = '1' then 
				row_3_x <=(others=> (others=> (others=>'0')));
			elsif (rising_edge(clk)) then
			
				if write_en_ram = '1' then
					s := bit_to_row_of_pix(q_rom);
					row_3_x(2) <= s(0) & s & s(row-1);
					row_3_x(1) <= row_3_x(2);
					row_3_x(0) <= row_3_x(1);
				end if;
			end if;
				
end process;
end architecture arc_pipline;

