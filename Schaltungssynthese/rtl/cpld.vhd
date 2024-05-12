library ieee;
use ieee.std_logic_1164.all;

entity cpld is
port
(
    RD_n     : in    std_logic;
    WR_n     : in    std_logic;
    IORQ_n   : in    std_logic;
    MREQ_n   : in    std_logic;
    --
    MAD_n    : in    std_logic;
    MEI      : in    std_logic;
    --
    A        : in    std_logic_vector( 15 downto 0);
    D        : in    std_logic_vector(  7 downto 0);
    --
    STRUKT_n : out   std_logic;
    SEG_on   : out   std_logic;
    AD13     : out   std_logic;
    AD14     : out   std_logic;
    AD15     : out   std_logic;
    CS_n     : out   std_logic;
    RAM_WR_n : out   std_logic;
    MEO      : out   std_logic
);
end entity cpld;

architecture rtl of cpld is

    signal ctrl_sel     : std_logic;
    signal wr80_n       : std_logic;
    signal control      : std_logic_vector( 7 downto 0);
    signal adrsel       : std_logic;
    signal ram_sel      : std_logic;

begin

    -- 80h-Zugriff
    ctrl_sel    <= '1' when A( 9 downto 0) = "0010000000" and MAD_n = '0' and IORQ_n = '0' else '0';

    -- read/write IO-Port 80h
    STRUKT_n    <= '0' when ctrl_sel = '1' and RD_n = '0' else '1';
    wr80_n      <= '0' when ctrl_sel = '1' and WR_n = '0' else '1';

    -- Steuerbyte FFs
    control     <= D when falling_edge (wr80_n);

    -- Adress-Vergleicher
    adrsel      <= '1' when control( 7 downto 5) = A( 15 downto 13) else '0';

    -- Steuersignale
    RAM_WR_n    <= '0' when control( 1) = '1' and WR_n = '0' else '1';
    ram_sel     <= '1' when control( 0) = '1' and adrsel = '1' and MEI = '1' and MREQ_n = '0' else '0';
    CS_n        <= not ram_sel;
    MEO         <= not ram_sel and MEI;

    SEG_on      <= control( 0); -- high aktiv
    AD13        <= control( 2);
    AD14        <= control( 3);
    AD15        <= control( 4);

end architecture rtl;
