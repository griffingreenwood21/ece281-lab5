--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : sevenSegDecoder.vhd
--| AUTHOR(S)     : C3C Griffin Greenwood
--| CREATED       : 02/17/2024 Last Modified 02/21/2024
--| DESCRIPTION   :  This file implements the sevenSegDecoder lab.  Using a 4
--| switch input, after a button is pressed, the display will show the hex digit
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES : 
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : LIST ANY DEPENDENCIES
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity sevenSegDecoder is
    Port ( 
           i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0)
    );
end sevenSegDecoder;

architecture Behavioral of sevenSegDecoder is
    signal c_Sa : std_logic := '1';
    signal c_Sb : std_logic := '1';
    signal c_Sc : std_logic := '1';
    signal c_Sd : std_logic := '1';
    signal c_Se : std_logic := '1';
    signal c_Sf : std_logic := '1';
    signal c_Sg : std_logic := '1';
    
begin
--alter equations to display a negative or not a negative when i_D = 15 and 16
    c_Sa <= ( not i_D(3) and not i_D(2) and not i_D(1) and i_D(0) )
        or (i_D(3) and not i_D(2) and i_D(1) and i_D(0) )
        or (i_D(2) and not i_D(1) and not i_D(0) )
        or (i_D(3) and i_D(2) and not i_D(1) )
        or (i_D(3) and i_D(2) and i_D(1) and not i_D(0) )
        or (i_D(3) and i_D(2) and i_D(1) and i_D(0));
        
    c_Sb <= ( not i_D(3) and i_D(2) and not i_D(1) and i_D(0) )
        or (i_D(2) and i_D(1) and not i_D(0) )
        or (i_D(3) and i_D(1) and i_D(0) )
        or (i_D(3) and i_D(2) and not i_D(0) );
        
    c_Sc <= '1' when ( (i_D = x"2") or
                       (i_D = x"C") or
                       (i_D = x"E") or
                       (i_D = x"F") ) else '0';
                       
    c_Sd <= '1' when ( (i_D = x"1") or
                       (i_D = x"4") or
                       (i_D = x"7") or
                       (i_D = x"9") or
                       (i_D = x"A") or
                       (i_D = x"E") or
                       (i_D = x"F") ) else '0';

    c_Se <= '1' when ( (i_D = x"1") or
                       (i_D = x"3") or
                       (i_D = x"4") or
                       (i_D = x"5") or
                       (i_D = x"7") or
                       (i_D = x"9") or
                       (i_D = x"E") or
                       (i_D = x"F") ) else '0';
                       
    c_Sf <= '1' when ( (i_D = x"1") or
                       (i_D = x"2") or
                       (i_D = x"3") or
                       (i_D = x"7") or
                       (i_D = x"C") or
                       (i_D = x"D") or
                       (i_D = x"E") or
                       (i_D = x"F") ) else '0';
                   
                       
    c_Sg <= '1' when ( (i_D = x"0") or
                       (i_D = x"1") or
                       (i_D = x"7") or
                       (i_D = x"E") ) else '0';

    o_S(0) <= c_Sa;
    o_S(1) <= c_Sb;
    o_S(2) <= c_Sc;
    o_S(3) <= c_Sd;
    o_S(4) <= c_Se;
    o_S(5) <= c_Sf;
    o_S(6) <= c_Sg;

end Behavioral;
