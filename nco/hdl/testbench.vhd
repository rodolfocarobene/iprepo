library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nco_complex_tb is
end nco_complex_tb;

architecture Behavioral of nco_complex_tb is
    -- Constants
    constant t_period : time := 10 ns;
    -- Signals for the testbench
    signal tb_aclk : std_logic := '0';
    signal tb_aresetn : std_logic := '0';
    signal tb_phase : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_gain : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_control : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_real_m_axis_tdata : std_logic_vector(31 downto 0);
    signal tb_imag_m_axis_tdata : std_logic_vector(31 downto 0);
    signal tb_tvalid : std_logic;
    


begin
    -- Instantiate the DUT (Device Under Test)
    dut: entity work.nco_complex
        port map (
            aclk => tb_aclk,
            aresetn => tb_aresetn,
            phase => tb_phase,
            gain => tb_gain,
            control => tb_control,
            real_m_axis_tdata => tb_real_m_axis_tdata,
            imag_m_axis_tdata => tb_imag_m_axis_tdata,
            tvalid => tb_tvalid
        );

    -- Clock process
    clock_process : process
      begin
        tb_aclk <= '0';
        wait for t_period/2;
        tb_aclk <= '1';
        wait for t_period/2;
      end process;

    
    tb_aresetn <= '1';
    tb_gain (31) <= '1';
    tb_gain (15) <= '1';
    tb_control (0) <= '1';
    tb_phase (25) <= '1';
end Behavioral;
