;- Programmer: Ty Farris and Ryan Solorzano
;- Date: 10-18-17
;- Experiment 7 Progamming Assignment
;- Description: 
;-----------------------------------------------------------------
.CSEG
.ORG 0x01

My_Subroutine:
init:			MOV r20, 0x00
				MOV r21, 0x00
	
count_r10:		CLC
				CMP r10, 0x00	
				BRNE count_r11
				LSR r10
				ADDC r20, 0x00
				BRN count_r10
				

count_r11:		CLC
				CMP r11, 0x00
				BRNE done
				LSR r11
				ADDC r21, 0x00
				BRN count_r11

done:

Ret