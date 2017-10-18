

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;-------------------------------------------------------
(0002)                            || ;- I/O Port Constants
(0003)                            || ;-------------------------------------------------------
(0004)                       032  || .EQU SWITCH_PORT	= 0x20		; port for switch input
(0005)                       064  || .EQU LED_PORT		= 0x40		; port for LED output
(0006)                            || ;-------------------------------------------------------
(0007)                            || .CSEG
(0008)                       001  || .ORG 0x01
(0009)                            || 
(0010)  CS-0x001  0x32A20  0x001  || main:	IN 	R10, SWITCH_PORT
(0011)  CS-0x002  0x36B01         || 		MOV r11, 0x01
(0012)  CS-0x003  0x02A5A         || 		SUB r10, r11
(0013)  CS-0x004  0x34A40         || 		OUT r10, LED_PORT
(0014)  CS-0x005  0x08008         || 		BRN main





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
MAIN           0x001   (0010)  ||  0014 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
LED_PORT       0x040   (0005)  ||  0013 
SWITCH_PORT    0x020   (0004)  ||  0010 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
