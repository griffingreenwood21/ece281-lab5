--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : controller_fsm.vhd
--| AUTHOR(S)     : C3C Griffin Greenwood
--| CREATED       : 04/2024
--| DESCRIPTION   : This file implements the Lab 5 controller (Moore Machine)
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
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


--|    One-Hot Encoding Table
--|    State     | Encoding
--|    state0    | 0001
--|    state1    | 0010
--|    state2    | 0100
--|    state3    | 1000
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_fsm is
    Port ( i_reset   : in  STD_LOGIC;
           i_adv     : in  STD_LOGIC;
           i_clk    : in STD_LOGIC;
           o_cycle   : out STD_LOGIC_VECTOR (3 downto 0)		   
		 );
end controller_fsm;

architecture Behavioral of controller_fsm is	

type state is (state0, state1, state2, state3);
signal f_Q, f_Q_next : state;
signal w_adv : std_logic := '1';

begin
    -- CONCURRENT STATEMENTS ------------------------------------------------------------------------------
	-- Next State Logic
    f_Q_next <= state0 when f_Q = state3 else
                state1 when f_Q = state0 else
                state2 when f_Q = state1 else
                state3 when f_Q = state2 else
                f_Q; -- default case
  
	-- Output logic
    with f_Q select
        o_cycle <= "0001" when state0,
                   "0010" when state1,
                   "0100" when state2,
                   "1000" when state3;
	
	-------------------------------------------------------------------------------------------------------
	
	-- PROCESSES ------------------------------------------------------------------------------------------	
	-- State memory ------------
	register_proc : process (i_adv, i_reset)
    begin
    --asynchronous reset
        if rising_edge(i_clk) then
        if i_reset = '1' then
            f_Q <= state3;
        
        elsif (i_adv = '1' and w_adv = '1') then
            f_Q <= f_Q_next;
            w_adv <= '0';
        elsif (i_adv = '0' and w_adv = '0') then
             w_adv <= '1' after 1000 ms;

        end if;
        end if;
    
	end process register_proc;	
	
	-------------------------------------------------------------------------------------------------------
	
	



end Behavioral;