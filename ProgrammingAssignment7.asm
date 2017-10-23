;- Programmer: Ty Farris and Ryan Solorzano
;- Date: 10-18-17
;- Experiment 7 Progamming Assignment
;- Description: Counts the number of bits that are set in register
;- r10 and r11. If both registers have the same number of bits set,
;- clear both registers. Otherwise, replace the value in the register
;- with the higher number of set bits with the number of bits that
;- are set in that register (don’t alter the other register).
;-----------------------------------------------------------------
.CSEG
.ORG 0x01

My_Subroutine:
init:				MOV r20, 0x00			;r10 counter for set bits
					MOV r21, 0x00			;r11 counter for set bits
					MOV r10, 0x01			;given value for r10
					MOV r11, 0x01			;given value for r11
					PUSH r10
					PUSH r11

count_r10:			CMP r10, 0x00			;check if r10 is all zeros
					BREQ count_r11			;if r10 is all zeros
					CLC						;clear carry flag
					LSR r10					;shift r10 right
					ADDC r20, 0x00			;add the carry flag to the r10 counter
					BRN count_r10
				

count_r11:			CMP r11, 0x00			;check if r11 is all zeros
					BREQ done				;if r11 is all zeros
					CLC						;clear carry flag
					LSR r11					;shift r11 right
					ADDC r21, 0x00			;add the carry flag to the r11 counter
					BRN count_r11

done:				POP r11
					POP r10
					CMP r20, r21			;if r20 and r21 are equal
					BRCS r10_less_than		;if r20 is less than r21
					BREQ equal				;if r20 and r21 are equal
					MOV r11, r20			;move r20 to r11
					Ret

r10_less_than:		MOV r10, r21			;move r21 to r10
					Ret

equal:				MOV r10, 0x00			;clear r10
					MOV r11, 0x00			;clear r20
					Ret
