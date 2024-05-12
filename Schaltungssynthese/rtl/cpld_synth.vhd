library ieee;
use ieee.std_logic_1164.all;

library rft;
use rft.component_package.DL002D;
use rft.component_package.DL004D;
use rft.component_package.DL011D;
use rft.component_package.DL020D;
use rft.component_package.DL032D;
use rft.component_package.DL086D;
use rft.component_package.DL374D;


entity cpld_synth_ohne_DL008 is
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
    D       : in    std_logic_vector(  7 downto 0);
    --
    STRUKT_n: out   std_logic;
    LED_n   : out   std_logic;
    AD13    : out   std_logic;
    AD14    : out   std_logic;
    AD15    : out   std_logic;
    CS_n    : out   std_logic;
    MEO     : out   std_logic
);
end entity cpld_synth_ohne_DL008;

architecture rtl of cpld_synth_ohne_DL008 is

    signal n00          : std_logic;
    signal n01          : std_logic;
    signal n02          : std_logic;
    signal n03          : std_logic;
    signal n04          : std_logic;
    signal n05          : std_logic;
    signal n06          : std_logic;
    signal n07          : std_logic;
    signal n08          : std_logic;
    signal n09          : std_logic;
    signal n10          : std_logic;
    signal n11          : std_logic;
    signal n12          : std_logic;
    signal n13          : std_logic;
    signal n14          : std_logic;
    signal n15          : std_logic;
    signal n16          : std_logic;
    signal n17          : std_logic;
    signal n18          : std_logic;
    signal n19          : std_logic;
    signal n20          : std_logic;
    signal n21          : std_logic;
    signal n22          : std_logic;
    signal n23          : std_logic;
    signal n24          : std_logic;
    signal control      : std_ulogic_vector(7 downto 0);
    signal CS_n_int     : std_logic;
    signal LED_n_int    : std_logic;

begin

    ic_i25: DL004D
    port map
    (
        a => a(6),
        q => n07
    );

    ic_i26: DL004D
    port map
    (
        a => a(14),
        q => n08
    );

    ic_i27: DL004D
    port map
    (
        a => control(0),
        q => LED_n_int
    );

    ic_i28: DL004D
    port map
    (
        a => MEI,
        q => n09
    );

    ic_i29: DL004D
    port map
    (
        a => MREQ_n,
        q => n10
    );


    ic_i30: DL032D
    port map
    (
        a => a(8),
        b => a(9),
        q => n11
    );

    ic_i31: DL032D
    port map
    (
        a => MAD_n,
        b => IORQ_n,
        q => n12
    );

    ic_i32: DL002D
    port map
    (
        a => n11, 
        b => n12, 
        q => n13
    );

    ic_i33: DL002D
    port map
    (
        a => a(2),
        b => a(3),
        q => n14
    );

    ic_i34: DL002D
    port map
    (
        a => a(1),
        b => a(0),
        q => n15
    );

    ic_i35: DL002D
    port map
    (
        a => a(4),
        b => a(5),
        q => n16
    );

    ic_i36: DL011D
    port map
    (
        a => n07,
        b => a(7),    
        c => n16,
        q => n17
    );


    ic_i37: DL020D
    port map
    (
        a => n13, 
        b => n14, 
        c => n15, 
        d => n17, 
        q => n18
    );

    
    ic_i38: DL032D
    port map
    (
        a => RD_n, 
        b => n18,   
        q => STRUKT_n
    );

    ic_i39: DL086D
    port map
    (
        a => a(13),
        b => control( 5),
        q => n19
    );

    ic_i40: DL086D
    port map
    (
        a => a(15),
        b => control( 7),
        q => n20
    );

    ic_i41: DL002D
    port map
    (
        a => n19, 
        b => n20, 
        q => n21
    );

    ic_i42: DL086D
    port map
    (
        a => n08,
        b => control( 6),
        q => n22
    );


    ic_i43: DL011D
    port map
    (
        a => control(0),
        b => MEI,     
        c => n10,
        q => n23
    );


    ic_i44: DL011D
    port map
    (
        a => n21,
        b => n22,     
        c => n23,
        q => n24
    );

    ic_i45: DL004D
    port map
    (
        a => n24,
        q => CS_n
    );
    


    ic_i46: DL002D
    port map
    (
        a => n09,
        b => n24,
        q => MEO
    );

    ic_i47: DL032D
    port map
    (
        a => WR_n, 
        b => n18,   
        q => n00
    );

--  ic_i48: DL032D
--  ic_i49: DL032D
--  ic_i50: DL032D
--  ic_i51: DL032D
--  ic_i52: DL032D
--  ic_i53: DL032D

    ic_i54: DL374D
    port map
    (
        di      => D,
        clk     => n00,
        oe_n    => '0',
        do      => control
    );
    AD13    <= control( 2);
    AD14    <= control( 3);
    AD15    <= control( 4);

    CS_n    <= CS_n_int;
    LED_n   <= LED_n_int;

end architecture rtl;
