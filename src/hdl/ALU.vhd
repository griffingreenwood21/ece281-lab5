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
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|     SUB     001
--|     OR      010
--|     X       011
--|     AND     100
--|     X       101
--|     LSHIFT  110
--|     RSHIFT  111
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
-- TODO
    Port (
        i_A         : in std_logic_vector (7 downto 0);
        i_B         : in std_logic_vector (7 downto 0);
        i_opcode    : in std_logic_vector (2 downto 0);
        o_result    : out std_logic_vector (7 downto 0);
        o_flags     : out std_logic_vector (2 downto 0)
    );
end ALU;

architecture behavioral of ALU is 
  
	-- declare components and signals
    signal w_add_sub : std_logic_vector(8 downto 0);
    signal w_add : std_logic_vector(8 downto 0);
    signal w_sub : std_logic_vector(8 downto 0);
    signal w_or : std_logic_vector(7 downto 0);
    signal w_and : std_logic_vector(7 downto 0);
    signal w_shift : std_logic_vector(7 downto 0);
    signal w_cin   : std_logic_vector(0 downto 0);
    signal w_result : std_logic_vector(7 downto 0);
  
begin
	-- PORT MAPS ----------------------------------------
    with i_opcode(2 downto 1) select
    w_result <= w_add_sub(7 downto 0) when "00",
                w_or when "01",
                w_and when "10",
                w_shift when "11",
                "00000000" when others;
	
	w_or <= (i_A or i_B) when i_opcode(0) = '0';
	
	w_and <= (i_A and i_B) when i_opcode(0) = '0';
	
	-- cin corresponds to subtract, which is controlled by opcode(0)
	w_cin <= i_opcode(0 downto 0);
	w_add <= std_logic_vector(unsigned("0" & i_A) + unsigned("0" & i_B));
	w_sub <= std_logic_vector(unsigned("0" & i_A) + not unsigned("0" & i_B) + unsigned(w_cin));
	w_add_sub <=  w_sub when w_cin = "1" else
	              w_add;
	o_flags(0) <= w_add_sub(8) when i_opcode(2 downto 1) = "00";
	o_flags(1) <= '1' when w_result = "00000000" else
	              '0';
	o_flags(2) <= w_result(7);
	
	w_shift <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0))))) when i_opcode(0) = '0' else
	           std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0))))) when i_opcode(0) = '1';
	           
	o_result <= w_result;
	-- CONCURRENT STATEMENTS ---------------------------
	
	
end behavioral;
