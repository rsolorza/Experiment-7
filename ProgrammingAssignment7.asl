

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


(0001)                            || ;- Programmer: Ty Farris and Ryan Solorzano
(0002)                            || ;- Date: 10-18-17
(0003)                            || ;- Experiment 7 Progamming Assignment
(0004)                            || ;- Description: 
(0005)                            || ;-----------------------------------------------------------------
(0006)                            || .CSEG
(0007)                       001  || .ORG 0x01
(0008)                            || 
(0009)                     0x001  || My_Subroutine:
(0010)  CS-0x001  0x37400  0x001  || init:				MOV r20, 0x00			;r10 counter for set bits
(0011)  CS-0x002  0x37500         || 					MOV r21, 0x00			;r11 counter for set bits
(0012)  CS-0x003  0x36A01         || 					MOV r10, 0x01			;given value for r10
(0013)  CS-0x004  0x36B01         || 					MOV r11, 0x01			;given value for r11
(0014)  CS-0x005  0x12A01         || 					PUSH r10
(0015)  CS-0x006  0x12B01         || 					PUSH r11
(0016)                            || 
(0017)  CS-0x007  0x30A00  0x007  || count_r10:			CMP r10, 0x00			;check if r10 is all zeros
(0018)  CS-0x008  0x0806A         || 					BREQ count_r11			;if r10 is all zeros
(0019)  CS-0x009  0x18000         || 					CLC						;clear carry flag
(0020)  CS-0x00A  0x10A01         || 					LSR r10					;shift r10 right
(0021)  CS-0x00B  0x2B400         || 					ADDC r20, 0x00			;add the carry flag to the r10 counter
(0022)  CS-0x00C  0x08038         || 					BRN count_r10
(0023)                            || 				
(0024)                            || 
(0025)  CS-0x00D  0x30B00  0x00D  || count_r11:			CMP r11, 0x00			;check if r11 is all zeros
(0026)  CS-0x00E  0x0809A         || 					BREQ done				;if r11 is all zeros
(0027)  CS-0x00F  0x18000         || 					CLC						;clear carry flag
(0028)  CS-0x010  0x10B01         || 					LSR r11					;shift r11 right
(0029)  CS-0x011  0x2B500         || 					ADDC r21, 0x00			;add the carry flag to the r11 counter
(0030)  CS-0x012  0x08068         || 					BRN count_r11
(0031)                            || 
(0032)  CS-0x013  0x12B02  0x013  || done:				POP r11
(0033)  CS-0x014  0x12A02         || 					POP r10
(0034)  CS-0x015  0x054A8         || 					CMP r20, r21			;if r20 and r21 are equal
(0035)  CS-0x016  0x0A0D0         || 					BRCS r10_less_than		;if r20 is less than r21
(0036)  CS-0x017  0x080E2         || 					BREQ equal				;if r20 and r21 are equal
(0037)  CS-0x018  0x04BA1         || 					MOV r11, r20			;move r20 to r11
(0038)  CS-0x019  0x18002         || 					Ret
(0039)                            || 
(0040)  CS-0x01A  0x04AA9  0x01A  || r10_less_than:		MOV r10, r21			;move r21 to r10
(0041)  CS-0x01B  0x18002         || 					Ret
(0042)                            || 
(0043)  CS-0x01C  0x36A00  0x01C  || equal:				MOV r10, 0x00			;clear r10
(0044)  CS-0x01D  0x36B00         || 					MOV r11, 0x00			;clear r20
(0045)  CS-0x01E  0x18002         || 					Ret





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
COUNT_R10      0x007   (0017)  ||  0022 
COUNT_R11      0x00D   (0025)  ||  0018 0030 
DONE           0x013   (0032)  ||  0026 
EQUAL          0x01C   (0043)  ||  0036 
INIT           0x001   (0010)  ||  
MY_SUBROUTINE  0x001   (0009)  ||  
R10_LESS_THAN  0x01A   (0040)  ||  0035 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
--> No ".EQU" directives used


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
