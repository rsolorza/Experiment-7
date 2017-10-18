;-------------------------------------------------------
;- I/O Port Constants
;-------------------------------------------------------
.EQU SWITCH_PORT	= 0x20		; port for switch input
.EQU LED_PORT		= 0x40		; port for LED output
;-------------------------------------------------------
.CSEG
.ORG 0x01

main:	IN 	R10, SWITCH_PORT
		MOV r11, 0x01
		SUB r10, r11
		OUT r10, LED_PORT
		BRN main
