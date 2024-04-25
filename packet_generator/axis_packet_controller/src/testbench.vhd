library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity packet_control_tb is
end packet_control_tb;

architecture Behavioral of packet_control_tb is

  component packet_control is
    Port (aclk : in std_logic;
          aresetn : in std_logic;
          packet_size : in std_logic_vector(31 downto 0);
          packet_enable : in std_logic_vector(31 downto 0);
          packet_reset : in std_logic_vector(31 downto 0);
          s_axis_tdata : in std_logic_vector(31 downto 0);
          s_axis_tvalid : in std_logic;
          m_axis_tdata : out std_logic_vector(31 downto 0);
          m_axis_tvalid : out std_logic;
          m_axis_tlast : out std_logic;
          m_axis_tready : in std_logic;
          debug_accum : out std_logic_vector(31 downto 0)
        );
  end component packet_control;

  signal aclk, aresetn, s_axis_tvalid, m_axis_tvalid, m_axis_tlast, m_axis_tready : std_logic;
  signal packet_size, packet_enable, packet_reset, s_axis_tdata, m_axis_tdata : std_logic_vector(31 downto 0);
  constant t_period : time := 10 ns;

begin

  packet_control_inst : packet_control
  port map (
      aclk => aclk,
      aresetn => aresetn,
      packet_size => packet_size,
      packet_enable => packet_enable,
      packet_reset => packet_reset,
      s_axis_tdata => s_axis_tdata,
      s_axis_tvalid => s_axis_tvalid,
      m_axis_tdata => m_axis_tdata,
      m_axis_tvalid => m_axis_tvalid,
      m_axis_tlast => m_axis_tlast,
      m_axis_tready => m_axis_tready,
      debug_accum => open
    );

  clock_process : process
  begin
    aclk <= '0';
    wait for t_period/2;
    aclk <= '1';
    wait for t_period/2;
  end process;

  data_process : process
  begin
    aresetn <= '0';
    packet_size <= (others=>'0');
    packet_enable <= (others=>'0');
    packet_reset <= (others=>'0');
    s_axis_tdata <= (others=>'0');
    s_axis_tvalid <= '0';
    m_axis_tready <= '1';

    wait for t_period * 4;

    aresetn <= '1';

    wait for t_period * 4;

    packet_enable <= (0=>'1', others=>'0');
    packet_size <= (2=>'1', 1=>'1', 0=>'1', others=>'0');

    wait for t_period * 2;

    s_axis_tvalid <= '1';

    wait for t_period * 8;

    s_axis_tvalid <= '0';

    wait;
  end process;

  -- Process to generate random data for s_axis_tdata
  process
  begin
    while (not end_simulation) loop
      wait for t_period;

      -- Generate random data
      s_axis_tdata <= std_logic_vector(to_unsigned(random(2**s_axis_tdata'length - 1), s_axis_tdata'length));

      -- Toggle s_axis_tvalid randomly
      if (to_integer(unsigned(s_axis_tdata)) mod 10 = 0) then
        s_axis_tvalid <= not s_axis_tvalid;
      end if;
    end loop;
    wait;
  end process;

end Behavioral;
