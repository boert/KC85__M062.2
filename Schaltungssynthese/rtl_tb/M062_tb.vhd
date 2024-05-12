library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.conversions.all;


entity M062_tb is
end entity M062_tb;


architecture testbench of M062_tb is
    
    constant cpu_frequency  : natural   := 2_000_000;
    constant cpu_period     : time      := 1 sec / cpu_frequency;
    constant slot       : std_logic_vector(  7 downto 0) := x"0C";
        
    signal tb_RD_n      : std_logic := '1';
    signal tb_WR_n      : std_logic := '1';
    signal tb_IORQ_n    : std_logic := '1';
    signal tb_MREQ_n    : std_logic := '1';
    signal tb_MAD_n     : std_logic := '1';
    signal tb_MEI       : std_logic := '1';
    signal tb_A         : std_logic_vector( 15 downto 0) := ( others => '0');
    signal tb_D         : std_logic_vector(  7 downto 0) := ( others => 'H');
    signal tb_MEO       : std_logic;
    --
    signal data         : std_logic_vector(  7 downto 0);

    
    procedure mem_read
    (
                   address  :       std_logic_vector( 15 downto 0);
            signal dat      : out   std_logic_vector(  7 downto 0);
            --
            signal AB       : out   std_logic_vector( 15 downto 0);
            signal DB       :       std_logic_vector(  7 downto 0);
            signal mreq_n   : out   std_logic;
            signal rd_n     : out   std_logic
    ) is
    begin
        wait for 20 ns;
        AB          <= address;
        wait for cpu_period / 2;
        mreq_n      <= '0';
        rd_n        <= '0';
        wait for cpu_period;
        -- hier könnte/sollte auf WAIT geguckt werden
        wait for cpu_period;
        dat         <= DB;
        mreq_n      <= '1';
        rd_n        <= '1';
        wait for cpu_period / 2;
        AB          <= ( others => 'Z');
        wait for 20 ns;
    end procedure mem_read;

    
    procedure mem_write
    (
                   address  :       std_logic_vector( 15 downto 0);
                   dat      :       std_logic_vector(  7 downto 0);
            --
            signal AB       : out   std_logic_vector( 15 downto 0);
            signal DB       : inout std_logic_vector(  7 downto 0);
            signal mreq_n   : out   std_logic;
            signal wr_n     : out   std_logic
    ) is
    begin
        wait for 20 ns;
        AB          <= address;
        wait for cpu_period / 2;
        mreq_n      <= '0';
        wait for 20 ns;
        DB          <= dat;
        wait for cpu_period;
        wr_n        <= '0';
        -- hier könnte/sollte auf WAIT geguckt werden
        wait for cpu_period;
        wr_n        <= '1';
        mreq_n      <= '1';
        wait for cpu_period / 2;
        DB          <= ( others => 'Z');
        AB          <= ( others => 'Z');
        wait for 20 ns;
    end procedure mem_write;

    
    procedure io_read
    (
                   address  :       std_logic_vector( 15 downto 0);
            signal dat      : out   std_logic_vector(  7 downto 0);
            --
            signal AB       : out   std_logic_vector( 15 downto 0);
            signal DB       :       std_logic_vector(  7 downto 0);
            signal iorq_n   : out   std_logic;
            signal rd_n     : out   std_logic
    ) is
    begin
        wait for 20 ns;
        AB          <= address;
        wait for cpu_period / 2;
        iorq_n      <= '0';
        rd_n        <= '0';
        wait for cpu_period;
        -- hier könnte/sollte auf WAIT geguckt werden
        wait for cpu_period;
        dat         <= DB;
        iorq_n      <= '1';
        rd_n        <= '1';
        wait for cpu_period / 2;
        AB          <= ( others => 'Z');
        wait for 20 ns;
    end procedure io_read;

    
    procedure io_write
    (
                   address  :       std_logic_vector( 15 downto 0);
                   dat      :       std_logic_vector(  7 downto 0);
            --
            signal AB       : out   std_logic_vector( 15 downto 0);
            signal DB       : inout std_logic_vector(  7 downto 0);
            signal iorq_n   : out   std_logic;
            signal wr_n     : out   std_logic
    ) is
    begin
        wait for 20 ns;
        AB          <= address;
        wait for cpu_period / 2;
        iorq_n      <= '0';
        wait for 20 ns;
        DB          <= dat;
        wait for cpu_period;
        wr_n        <= '0';
        -- hier könnte/sollte auf WAIT geguckt werden
        wait for cpu_period;
        wr_n        <= '1';
        iorq_n      <= '1';
        wait for cpu_period / 2;
        DB          <= ( others => 'Z');
        AB          <= ( others => 'Z');
        wait for 20 ns;
    end procedure io_write;



begin

    tb_MAD_n    <= '0' when tb_A( 15 downto 8+2) = slot(7 downto 2) else '1';

    dut: entity work.M062
    port map
    (
        RD_n    => tb_RD_n,       --: in    std_logic;
        WR_n    => tb_WR_n,       --: in    std_logic;
        IORQ_n  => tb_IORQ_n,     --: in    std_logic;
        MREQ_n  => tb_MREQ_n,     --: in    std_logic;
        --         --             
        MAD_n   => tb_MAD_n,      --: in    std_logic;
        MEI     => tb_MEI,        --: in    std_logic;
        --         --             
        A       => tb_A,          --: in    std_logic_vector( 15 downto 0);
        D       => tb_D,          --: in    std_logic_vector(  7 downto 0);
        --         --
        MEO     => tb_MEO         --: out   std_logic
    );

    process
    begin
        -- initial wait
        wait for 250 ns;

        report "read memory 1234h";
        mem_read( x"1234", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: no reaction";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
        
        -- read: Strukturbyte
        report "read IO80, slot 0D";
        io_read( x"0D80", data, tb_A, tb_D, tb_IORQ_n, tb_RD_n); 
        report "expect: no reaction";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
        
        -- read: Strukturbyte
        report "read IO80, slot 0C";
        io_read( x"0C80", data, tb_A, tb_D, tb_IORQ_n, tb_RD_n); 
        report "expect: correct struct byte";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
        wait for 500 ns;
        
        -- write: Controlbyte (rw)
        report "write ctrl, slot 0C, rw, segment 0 on, adr 0000h";
        io_write( x"0C80", x"03", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        report "expect: activated module";
        wait for 500 ns;

        -- memtest
        report "write memory 0012h";
        mem_write( x"0012", x"12", tb_A, tb_D, tb_MREQ_n, tb_WR_n); 
        wait for 500 ns;
        wait for 500 ns;
        
        -- write: Controlbyte (ro)
        report "write ctrl, slot 0C, ro, segment 0 on, adr 0000h";
        io_write( x"0C80", x"01", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        report "expect: activated module";
        wait for 500 ns;
       

        -- memtest
        report "write memory 0012h";
        mem_write( x"0012", x"55", tb_A, tb_D, tb_MREQ_n, tb_WR_n); 
        wait for 500 ns;
        wait for 500 ns;
        
        report "read memory 0012h";
        mem_read( x"0012", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: correct data";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;

        
        -- write: Controlbyte
        report "write ctrl, slot 0C, off";
        io_write( x"0C80", x"00", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        report "expect: disabled module";
        wait for 500 ns;
        
        report "read memory 0012h";
        mem_read( x"0012", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: no reaction";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
       

        -- write: Controlbyte
        report "write ctrl, slot 0C, segment 0 on, adr 0E000h";
        io_write( x"0C80", "11100001", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        wait for 500 ns;
        
        report "read memory 0E012h";
        mem_read( x"E012", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: 12";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
       

        -- write: Controlbyte
        report "write ctrl, slot 0C, segment 7 on, adr 0000h";
        io_write( x"0C80", "00011101", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        report "expect: activated module";
        wait for 500 ns;
       

        -- memtest
        report "write memory 0012h";
        mem_write( x"0012", x"78", tb_A, tb_D, tb_MREQ_n, tb_WR_n); 
        wait for 500 ns;
       

        -- write: Controlbyte
        report "write ctrl, slot 0C, segment 7 on, adr 0E000h";
        io_write( x"0C80", "11111101", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        wait for 500 ns;
        
        report "read memory 0E012h";
        mem_read( x"E012", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: 78";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
       

        -- write: Controlbyte
        report "write ctrl, slot 0C, segment 0 on, adr 08000h";
        io_write( x"0C80", "10000001", tb_A, tb_D, tb_IORQ_n, tb_WR_n);
        wait for 500 ns;
        
        report "read memory 08012h";
        mem_read( x"8012", data, tb_A, tb_D, tb_MREQ_n, tb_RD_n); 
        report "expect: 12";
        report "data " & to_hex_str( data, 2);
        wait for 500 ns;
        
        wait for 1 us;

        wait;
    end process;

end architecture testbench;
