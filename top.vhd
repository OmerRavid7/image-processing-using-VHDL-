library ieee;
library work ;
use work.median_filter.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity top is
port (
      clk    : in    std_logic; 
      rst    : in    std_logic;  
      start  : in    std_logic;   
      done   : out   std_logic);
     attribute altera_chip_pin_lc : string;
     attribute altera_chip_pin_lc of clk  : signal is "Y2";
     attribute altera_chip_pin_lc of rst  : signal is "AB28";
	 attribute altera_chip_pin_lc of start: signal is "AC28";
     attribute altera_chip_pin_lc of done : signal is "E21";
end entity top;


architecture arc_top of top is 


component pipline is

	generic(
		rom_pipe : string;
		ram_pipe : string 
		);
		
	port(

		read_address_rom : in std_logic_vector(7 downto 0);
		write_address_ram : in std_logic_vector (7 downto 0);
		write_en_ram : in std_logic;
--		done 	: in std_logic; -- maybe
		clk : in std_logic;
		rst : in std_logic
		
);
end component pipline;

component SM is 
	port(

		clk 	: in std_logic;
		rst 	: in std_logic;
		start	: in std_logic;
		
		read_address : out std_logic_vector (7 downto 0);--send out to read from ROM
		write_address : out std_logic_vector (7 downto 0);--send out to write to RAM
		write_en : out std_logic;
		done 	: out std_logic
		);

end component SM;


signal read_address_rom , write_address_ram : std_logic_vector(7 downto 0);
signal write_en_ram : std_logic;


begin

gen_loop : for i in 0 to 2 generate
		gen_pipe : pipline 
			generic map(
			rom_pipe => rom_arr(i),
			ram_pipe => ram_arr(i)
			)
			
			port map (
				read_address_rom =>read_address_rom ,
				write_address_ram => write_address_ram,
				write_en_ram => write_en_ram,
				clk => clk,
				rst => rst
			);
			
end generate;
	
FSM : SM 

	port map (
	clk => clk,
	rst => rst,
	start => start, 
	
	read_address => read_address_rom ,
	write_address => write_address_ram ,
	write_en => write_en_ram ,
	done => done
	);



end architecture arc_top;