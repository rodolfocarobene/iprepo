library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nco_complex is
    Port ( 
        aclk : in std_logic;
        aresetn : in std_logic;
        
        phase : in std_logic_vector (31 downto 0);
        gain : in std_logic_vector (31 downto 0);
        control : in std_logic_vector (31 downto 0);
        
        real_m_axis_tdata : out std_logic_vector(31 downto 0);
        imag_m_axis_tdata : out std_logic_vector(31 downto 0);
        tvalid : out std_logic

    );
end nco_complex;

architecture Behavioral of nco_complex is

	COMPONENT dds_compiler
      PORT (
        aclk : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_config_tvalid : IN STD_LOGIC;
        s_axis_config_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT mult_gain
      PORT (
        CLK : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
    
    signal sig_tvalid : std_logic;
    signal sig_m_axis_tvalid : std_logic;
	  signal sig_m_axis_tdata : std_logic_vector(31 downto 0);
  	signal sig_mux_m_axis_tvalid : std_logic;
	  signal sig_mux_m_axis_tdata : std_logic_vector(31 downto 0);
	  signal sig_real_m_axis_tdata : std_logic_vector(31 downto 0);
    signal sig_imag_m_axis_tdata : std_logic_vector(31 downto 0);

    signal sig_delay_0_tvalid : std_logic;
    signal sig_delay_1_tvalid : std_logic;
    signal sig_delay_2_tvalid : std_logic;
begin

dds_compiler_inst : dds_compiler
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_config_tvalid => sig_tvalid,
    s_axis_config_tdata => phase(31 downto 16),
    m_axis_data_tvalid => sig_m_axis_tvalid,
    m_axis_data_tdata => sig_m_axis_tdata
  );
  
mult_gain_real_inst : mult_gain
  PORT MAP (
    clk => aclk, 
    a => sig_mux_m_axis_tdata(15 downto 0),
    b => gain(31 downto 16),
    p => sig_real_m_axis_tdata
  );
  
mult_gain_imag_inst : mult_gain
  PORT MAP (
    clk => aclk, 
    a => sig_mux_m_axis_tdata(31 downto 16),
    b => gain(31 downto 16),
    p => sig_imag_m_axis_tdata
  );
  
  output_process : process(aclk)
  begin
      if rising_edge(aclk) then
          if aresetn = '0' then
              sig_mux_m_axis_tdata <= (others=>'0');
              sig_mux_m_axis_tvalid <= '0';
          else
              if control(0) = '1' then
                  sig_mux_m_axis_tdata <= sig_m_axis_tdata;
                  sig_mux_m_axis_tvalid <= sig_m_axis_tvalid;
              else
                  sig_mux_m_axis_tdata <= (others=>'0');
                  sig_mux_m_axis_tvalid <= '0';
              end if;
          end if;
      end if;
  end process;
  
  tvalid_process : process(aclk)
  begin
      if rising_edge(aclk) then
          if aresetn = '0' then
              sig_delay_0_tvalid <= '0';
              sig_delay_1_tvalid <= '0';
              sig_delay_2_tvalid <= '0';
          else
              sig_delay_0_tvalid <= sig_mux_m_axis_tvalid;
              sig_delay_1_tvalid <= sig_delay_0_tvalid;
              sig_delay_2_tvalid <= sig_delay_1_tvalid;
          end if;
      end if;
  end process;
  
  sig_tvalid <= control(0);
  imag_m_axis_tdata <= sig_imag_m_axis_tdata;
  real_m_axis_tdata <= sig_real_m_axis_tdata;
  tvalid <= sig_delay_2_tvalid;

end Behavioral;
