----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner
-- 
-- Create Date:    20:59:29 02/04/2013 
-- Design Name: 
-- Module Name:    RAT_MCU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Starter MCU file for RAT MCU. 
--
-- Dependencies: 
--
-- Revision: 3.00
-- Revision: 4.00 (08-24-2016): removed support for multibus
-- Revision: 4.01 (11-01-2016): removed PC_TRI reference
-- Revision: 4.02 (11-15-2016): added SCR_DATA_SEL 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAT_MCU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB  : out  STD_LOGIC);
end RAT_MCU;



architecture Behavioral of RAT_MCU is

   component prog_rom  
      port (     ADDRESS : in std_logic_vector(9 downto 0); 
             INSTRUCTION : out std_logic_vector(17 downto 0); 
                     CLK : in std_logic);  
   end component;

   component ALU
       Port (   A : in  STD_LOGIC_VECTOR (7 downto 0);
                B : in  STD_LOGIC_VECTOR (7 downto 0);
              Cin : in  STD_LOGIC;
              SEL : in  STD_LOGIC_VECTOR(3 downto 0);
                C : out  STD_LOGIC;
                Z : out  STD_LOGIC;
           RESULT : out  STD_LOGIC_VECTOR (7 downto 0));
   end component;

   component CONTROL_UNIT 
       Port ( CLK           : in   STD_LOGIC;
              C             : in   STD_LOGIC;
              Z             : in   STD_LOGIC;
              INT           : in   STD_LOGIC;
              RESET         : in   STD_LOGIC; 
              OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
              OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
              
              PC_LD         : out  STD_LOGIC;
              PC_INC        : out  STD_LOGIC;
              PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);		  

              SP_LD         : out  STD_LOGIC;
              SP_INCR       : out  STD_LOGIC;
              SP_DECR       : out  STD_LOGIC;
 
              RF_WR         : out  STD_LOGIC;
              RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);

              ALU_OPY_SEL   : out  STD_LOGIC;
              ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);

              SCR_WR        : out  STD_LOGIC;
              SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
			  SCR_DATA_SEL  : out  STD_LOGIC; 

              FLG_C_LD      : out  STD_LOGIC;
              FLG_C_SET     : out  STD_LOGIC;
              FLG_C_CLR     : out  STD_LOGIC;
              FLG_SHAD_LD   : out  STD_LOGIC;
              FLG_LD_SEL    : out  STD_LOGIC;
              FLG_Z_LD      : out  STD_LOGIC;
              
              I_FLAG_SET    : out  STD_LOGIC;
              I_FLAG_CLR    : out  STD_LOGIC;

              RST           : out  STD_LOGIC;
              IO_STRB       : out  STD_LOGIC);
   end component;

   component RegisterFile 
       Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
              DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
              ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
              WR     : in     STD_LOGIC;
              CLK    : in     STD_LOGIC);
   end component;

   component PC 
      port ( RST,CLK,PC_LD,PC_INC : in std_logic; 
             FROM_IMMED : in std_logic_vector (9 downto 0); 
             FROM_STACK : in std_logic_vector (9 downto 0); 
             FROM_INTRR : in std_logic_vector (9 downto 0); 
             PC_MUX_SEL : in std_logic_vector (1 downto 0); 
             PC_COUNT   : out std_logic_vector (9 downto 0)); 
   end component; 

   component FlagReg
        Port ( D    : in  STD_LOGIC; --flag input
               LD   : in  STD_LOGIC; --load Q with the D value
               SET  : in  STD_LOGIC; --set the flag to '1'
               CLR  : in  STD_LOGIC; --clear the flag to '0'
               CLK  : in  STD_LOGIC; --system clock
               Q    : out  STD_LOGIC); --flag output
    end component;
    
    component Mux_2x1
        Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
               B : in STD_LOGIC_VECTOR (7 downto 0);
             SEL : in STD_LOGIC;
          OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Mux_4x1_8bit
         Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
                B : in STD_LOGIC_VECTOR (7 downto 0);
                C : in STD_LOGIC_VECTOR (7 downto 0);
                D : in STD_LOGIC_VECTOR (7 downto 0); 
              SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));    
    end component;
     
   -- intermediate signals ----------------------------------  
   signal s_inst_reg : std_logic_vector(17 downto 0) := (others => '0'); 
 
   -- signals into PC ----------------------------------------
   signal pc_mux_input : std_logic_vector(9 downto 0) := (others => '0');
   signal s_pc_count : std_logic_vector(9 downto 0) := (others => '0');
   
   -- signal for Scratch RAM/ SP ------------------------------------------
   signal scr_data_out :std_logic_vector(9 downto 0) := (others => '0');
   
   -- signals into Register File ------------------------------
   signal reg_data_in : std_logic_vector(7 downto 0) := "00000000";
   
   -- signals into the ALU -----------------------------------
   signal dx_out : std_logic_vector(7 downto 0) := "00000000";
   signal dy_out : std_logic_vector(7 downto 0) := "00000000";
   signal alu_b_input : std_logic_vector(7 downto 0) := "00000000";
   signal carry_flag : std_logic := '0';

    -- signals out of the ALU ---------------------------------
    signal alu_result : std_logic_vector(7 downto 0) := "00000000";
    signal c_flag_in : std_logic := '0';
    signal z_flag_in : std_logic := '0';

    -- signals from the Control Unit --------------------------
    signal rf_wr : std_logic := '0';
    signal rf_wr_sel : std_logic_vector(1 downto 0) := "00";
    signal alu_sel : std_logic_vector(3 downto 0) := "0000";
    signal alu_opy_sel : std_logic := '0';
    signal s_pc_ld : std_logic := '0'; 
    signal s_pc_inc : std_logic := '0'; 
    signal s_rst : std_logic := '0'; 
    signal s_pc_mux_sel : std_logic_vector(1 downto 0) := "00"; 
    
   -- helpful aliases ------------------------------------------------------------------
   alias s_ir_immed_bits : std_logic_vector(9 downto 0) is s_inst_reg(12 downto 3); 
   
   

begin

   my_prog_rom: prog_rom  
   port map(     ADDRESS => s_pc_count, 
             INSTRUCTION => s_inst_reg, 
                     CLK => CLK); 

   my_alu: ALU
   port map ( A => dx_out,       
              B => alu_b_input,       
              Cin => carry_flag,     
              SEL => alu_sel,     
              C => c_flag_in,       
              Z => z_flag_in,       
              RESULT => alu_result); 


   my_cu: CONTROL_UNIT 
   port map ( CLK           => CLK, 
              C             => , 
              Z             => , 
              INT           => , 
              RESET         => RESET, 
              OPCODE_HI_5   => , 
              OPCODE_LO_2   => , 
              
              PC_LD         => s_pc_ld, 
              PC_INC        => s_pc_inc,  
              PC_MUX_SEL    => s_pc_mux_sel, 

              SP_LD         => , 
              SP_INCR       => , 
              SP_DECR       => , 

              RF_WR         => rf_wr, 
              RF_WR_SEL     => rf_wr_sel, 

              ALU_OPY_SEL   => alu_opy_sel, 
              ALU_SEL       => alu_sel,
			  
              SCR_WR        => , 
              SCR_ADDR_SEL  => ,              
			  SCR_DATA_SEL  => ,
			  
              FLG_C_LD      => , 
              FLG_C_SET     => , 
              FLG_C_CLR     => , 
              FLG_SHAD_LD   => , 
              FLG_LD_SEL    => , 
              FLG_Z_LD      => , 
              I_FLAG_SET    => , 
              I_FLAG_CLR    => ,  

              RST           => s_rst,
              IO_STRB       => );
              

   my_regfile: RegisterFile 
   port map ( D_IN   => reg_data_in,   
              DX_OUT => dx_out,   
              DY_OUT => dy_out,   
              ADRX   => s_inst_reg(12 downto 8),   
              ADRY   => s_inst_reg(7 downto 3),     
              WR     => rf_wr,   
              CLK    => CLK); 


   my_PC: PC 
   port map ( RST        => s_rst,
              CLK        => CLK,
              PC_LD      => s_pc_ld,
              PC_INC     => s_pc_inc,
              FROM_IMMED => s_inst_reg(12 downto 3),
              FROM_STACK => scr_data_out,
              FROM_INTRR => "1111111111",
              PC_MUX_SEL => s_pc_mux_sel,
              PC_COUNT   => s_pc_count); 


end Behavioral;