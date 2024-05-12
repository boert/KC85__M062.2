library ieee;
use ieee.std_logic_1164.all;


library rft;
use rft.component_package.D146D;
use rft.component_package.D345D;
use rft.component_package.U62256D;
use rft.component_package.U74HCT245DK;

-- Steuerwort:
-- AAASSS0M

-- EPROM:   27C512
-- RAM:     M48Z35

entity M062 is
    port
    (
        RD_n    : in    std_logic;
        WR_n    : in    std_logic;
        IORQ_n  : in    std_logic;
        MREQ_n  : in    std_logic;
        --
        MAD_n   : in    std_logic;
        MEI     : in    std_logic;
        --
        A       : in    std_logic_vector( 15 downto 0);
        D       : inout std_logic_vector(  7 downto 0);
        --
        MEO     : out   std_logic
    );
end entity M062;


architecture rtl of M062 is
        
    signal STRUKT_n             : std_logic;
    signal SEG_on               : std_logic;
    signal AD13                 : std_logic;
    signal AD14                 : std_logic;
    signal AD15                 : std_logic;
    signal CS_n                 : std_logic;
    signal RAM_WR_n             : std_logic;
    --
    signal memory_i0_a          : std_logic_vector( 14 downto 0);
    signal struct_byte          : std_logic_vector( 7 downto 0);
    signal segment_decoder_i0_a : std_ulogic_vector( 3 downto 0);
    signal JP1                  : std_ulogic;
    signal JP2                  : std_ulogic;
    signal JP3                  : std_ulogic;
    signal JP4A                 : std_ulogic;
    signal JP4B                 : std_ulogic;
    signal segments_out         : std_logic_vector( 6 downto 0);

begin

    -- Jumper
      JP1 <= RAM_WR_n;  -- 32k, RAM
      JP2 <= AD14;      -- 32k, RAM
      JP3 <= '0';       -- 32k, RAM

    --JP1 <= AD14;    -- 64k, ROM
    --JP2 <= AD15;    -- 64k, ROM
    --JP3 <= AD15;    -- 64k, ROM

    -- F3h
    JP4A <= '0';
    JP4B <= '0';


    -- Steuerlogik
    cpld_i0: entity work.cpld
    port map
    (
        RD_n     => RD_n,       --: in    std_logic;
        WR_n     => WR_n,       --: in    std_logic;
        IORQ_n   => IORQ_n,     --: in    std_logic;
        MREQ_n   => MREQ_n,     --: in    std_logic;
        --                    
        MAD_n    => MAD_n,      --: in    std_logic;
        MEI      => MEI,        --: in    std_logic;
        --                    
        A        => A,          --: in    std_logic_vector( 15 downto 0);
        D        => D,          --: in    std_logic_vector(  7 downto 0);
        --                    
        STRUKT_n => STRUKT_n,   --: out   std_logic;
        SEG_on   => SEG_on,     --: out   std_logic;
        AD13     => AD13,       --: out   std_logic;
        AD14     => AD14,       --: out   std_logic;
        AD15     => AD15,       --: out   std_logic;
        CS_n     => CS_n,       --: out   std_logic;
        RAM_WR_n => RAM_WR_n,   --: out   std_logic;
        MEO      => MEO         --: out   std_logic
    );


    -- Strukturbyte
    struct_byte <= ( 2 => JP4B, 3 => JP4A, others => '1');
    struct_gen_i0: U74HCT245DK
    port map
    (
        a    => struct_byte,        --: inout std_ulogic_vector(7 downto 0);
        b    => D,                  --: inout std_ulogic_vector(7 downto 0);
        dir  => '1',                --: in    std_ulogic;
        oe_n => STRUKT_n            --: in    std_ulogic
    );                             
    

    -- Speicher                               
    memory_i0_a <= JP2 & AD13 & A( 12 downto 0);
    memory_i0: U62256D              
    port map                       
    (                              
        a     => memory_i0_a,       --: in    std_logic_vector( 14 downto 0);
        ce_n  => CS_n,              --: in    std_logic;
        oe_n  => CS_n,              --: in    std_logic;
        we_n  => JP1,               --: in    std_logic;
        dq    => D                  --: inout std_logic_vector( 7 downto 0)
    );

    segment_decoder_i0_a( 0) <= AD13;
    segment_decoder_i0_a( 1) <= AD14;
    segment_decoder_i0_a( 2) <= JP3;
    segment_decoder_i0_a( 3) <= '0';
    --
    segment_decoder_i0: D345D
    port map
    (
        a   => segment_decoder_i0_a,    --: in  std_ulogic_vector( 3 downto 0);
        bi  => SEG_on,                  --: in  std_ulogic;
        rbi => '1',                     --: in  std_ulogic; Vornullen
        --
        q   => segments_out             --: out std_logic_vector( 6 downto 0);
    );

end architecture rtl;
