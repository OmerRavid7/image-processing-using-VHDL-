library ieee;
library work ;
use work.median_filter.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity median_TB is
end;


architecture arc_median_TB of median_TB is

-- Declare a type for a 3x3 matrix
signal  myMatrix : matrix;
signal resultPixel : pixel;

begin
-- Assign values to elements of the matrix
--myMatrix <= ((others => (others => (others => '0'))));

myMatrix <= (	(0 => (0 => "00001" , 1 => "00010" , 2  => "00011") ,
		 1 => (0 => "00100" , 1 => "00101" , 2  => "00110") ,
		 2 => (0 => "00111" , 1 => "01000" , 2  => "01001")));

resultPixel <= median_of_median(myMatrix);

--report "Result pixel: " & integer'image(to_integer(resultPixel))
--severity note; 

end architecture arc_median_TB;