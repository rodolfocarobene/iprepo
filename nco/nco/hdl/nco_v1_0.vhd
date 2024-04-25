library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco_v1_0 is
	port (
		aclk	: in std_logic;
		aresetn	: in std_logic;
		s_axi_lite_awaddr	: in std_logic_vector(3 downto 0);
		s_axi_lite_awprot	: in std_logic_vector(2 downto 0);
		s_axi_lite_awvalid	: in std_logic;
		s_axi_lite_awready	: out std_logic;
		s_axi_lite_wdata	: in std_logic_vector(31 downto 0);
		s_axi_lite_wstrb	: in std_logic_vector(3 downto 0);
		s_axi_lite_wvalid	: in std_logic;
		s_axi_lite_wready	: out std_logic;
		s_axi_lite_bresp	: out std_logic_vector(1 downto 0);
		s_axi_lite_bvalid	: out std_logic;
		s_axi_lite_bready	: in std_logic;
		s_axi_lite_araddr	: in std_logic_vector(3 downto 0);
		s_axi_lite_arprot	: in std_logic_vector(2 downto 0);
		s_axi_lite_arvalid	: in std_logic;
		s_axi_lite_arready	: out std_logic;
		s_axi_lite_rdata	: out std_logic_vector(31 downto 0);
		s_axi_lite_rresp	: out std_logic_vector(1 downto 0);
		s_axi_lite_rvalid	: out std_logic;
		s_axi_lite_rready	: in std_logic;
		
    m_axis_real_tdata : out std_logic_vector(15 downto 0);
    m_axis_real_tvalid : out std_logic;
		
    m_axis_imag_tdata : out std_logic_vector(15 downto 0);
    m_axis_imag_tvalid : out std_logic
	);
end nco_v1_0;

architecture arch_imp of nco_v1_0 is

	component nco_v1_0_S_AXI_Lite is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		CONTROL : out std_logic_vector(31 downto 0);
		PHASE : out std_logic_vector(31 downto 0);
		GAIN : out std_logic_vector(31 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component nco_v1_0_S_AXI_Lite;
	
	component nco_complex is
      Port ( 
          aclk : in std_logic;
          aresetn : in std_logic;
          
          phase : in std_logic_vector (31 downto 0);
          gain : in std_logic_vector (31 downto 0);
          control : in std_logic_vector (31 downto 0);
          
          imag_m_axis_tdata : out std_logic_vector (31 downto 0);
          real_m_axis_tdata : out std_logic_vector (31 downto 0);
          tvalid : out std_logic
      );
  end component nco_complex;
	
	
	signal sig_control : std_logic_vector(31 downto 0);
	signal sig_phase : std_logic_vector(31 downto 0);
	signal sig_gain : std_logic_vector(31 downto 0);
	signal sig_tvalid : std_logic;
	
	signal sig_real_m_axis_tdata : std_logic_vector(31 downto 0);
	signal sig_imag_m_axis_tdata : std_logic_vector(31 downto 0);
	
begin

nco_v1_0_S_AXI_Lite_inst : nco_v1_0_S_AXI_Lite
	port map (
	    CONTROL => sig_control,
	    PHASE => sig_phase,
	    GAIN => sig_gain,
		S_AXI_ACLK	=> aclk,
		S_AXI_ARESETN	=> aresetn,
		S_AXI_AWADDR	=> s_axi_lite_awaddr,
		S_AXI_AWPROT	=> s_axi_lite_awprot,
		S_AXI_AWVALID	=> s_axi_lite_awvalid,
		S_AXI_AWREADY	=> s_axi_lite_awready,
		S_AXI_WDATA	=> s_axi_lite_wdata,
		S_AXI_WSTRB	=> s_axi_lite_wstrb,
		S_AXI_WVALID	=> s_axi_lite_wvalid,
		S_AXI_WREADY	=> s_axi_lite_wready,
		S_AXI_BRESP	=> s_axi_lite_bresp,
		S_AXI_BVALID	=> s_axi_lite_bvalid,
		S_AXI_BREADY	=> s_axi_lite_bready,
		S_AXI_ARADDR	=> s_axi_lite_araddr,
		S_AXI_ARPROT	=> s_axi_lite_arprot,
		S_AXI_ARVALID	=> s_axi_lite_arvalid,
		S_AXI_ARREADY	=> s_axi_lite_arready,
		S_AXI_RDATA	=> s_axi_lite_rdata,
		S_AXI_RRESP	=> s_axi_lite_rresp,
		S_AXI_RVALID	=> s_axi_lite_rvalid,
		S_AXI_RREADY	=> s_axi_lite_rready
	);
	
	nco_complex_inst : nco_complex
	   port map(
	       aclk => aclk,
         aresetn => aresetn,
         phase => sig_phase,
         gain => sig_gain,
         control => sig_control,
         imag_m_axis_tdata => sig_imag_m_axis_tdata,
         real_m_axis_tdata => sig_real_m_axis_tdata,
         tvalid => sig_tvalid

	   );

m_axis_real_tdata <= sig_imag_m_axis_tdata(31 downto 16);
m_axis_imag_tdata <= sig_real_m_axis_tdata(31 downto 16);
m_axis_real_tvalid <= sig_tvalid;
m_axis_imag_tvalid <= sig_tvalid;

end arch_imp;
