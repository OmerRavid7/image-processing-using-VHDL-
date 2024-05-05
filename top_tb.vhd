library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
  port (
        clk    : in    std_logic; 
        rst    : in    std_logic;  
        start  : in    std_logic;   
        done   : out   std_logic);
  end component;

  signal clk: std_logic := '0';
  signal rst: std_logic := '0';
  signal start: std_logic:= '0';
  signal done: std_logic;

begin

  uut: top port map ( clk   => clk,
                      rst   => rst,
                      start => start,
                      done  => done );
 -- full clk = 10 ns

process
 begin
	wait for 10 ns / 2;
	clk	<= (NOT clk);
end process;

process
  begin
    wait for 20 ns;
    rst <= '1' ;
    wait for 20 ns;
    rst <= '0' ;
    wait for 20 ns;

  
    start <= '1' ;
    wait for 40 ns;
    start <= '0' ;
    wait;

 end process;
end architecture bench;