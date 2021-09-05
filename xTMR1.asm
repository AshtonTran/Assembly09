;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F690. This file contains the basic code               *
;   building blocks to build upon.                                    *  
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     * 
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F690.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list		p=16f690		; list directive to define processor
	#include	<P16F690.inc>		; processor specific variable definitions
	
	__CONFIG    _CP_OFF & _CPD_OFF & _BOR_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.






;***** VARIABLE DEFINITIONS
w_temp		EQU	0x7D			; variable used for context saving
status_temp	EQU	0x7E			; variable used for context saving
pclath_temp	EQU	0x7F			; variable used for context saving

portc		EQU	0x25
count		EQU 0x23
setinel		EQU 0x24
portb		EQU	0x26
;**********************************************************************
	ORG			0x000			; processor reset vector
  	goto		main			; go to beginning of program


	ORG			0x004			; interrupt vector location
	movwf		w_temp			; save off current W register contents
	movf		STATUS,w		; move status register into W register
	movwf		status_temp		; save off contents of STATUS register
	movf		PCLATH,w		; move pclath register into W register
	movwf		pclath_temp		; save off contents of PCLATH register


; isr code can go here or be located as a call subroutine elsewhere

nop

	bsf			setinel,0
	bcf			PIR1,TMR1IF		;clear inturpt flag
	movlw		0xE7
	movwf		TMR1H
	movlw		0x95
	movwf		TMR1L


	movf		pclath_temp,w		; retrieve copy of PCLATH register
	movwf		PCLATH			; restore pre-isr PCLATH register contents	
	movf		status_temp,w		; retrieve copy of STATUS register
	movwf		STATUS			; restore pre-isr STATUS register contents
	swapf		w_temp,f
	swapf		w_temp,w		; restore pre-isr W register contents
	retfie					; return from interrupt


main
;housekeeping
	banksel		TRISC
	clrf		TRISC
	bsf			TRISA,RA2	;make RA2 as input
	clrf		TRISB

	banksel		ANSEL
	movlw		0x04
	movwf		ANSEL

	banksel		ADCON0
	movlw		0x89
	movwf		ADCON0		;setup AD for convertion
	banksel		ADCON1
	movlw		0x20		;0x60 FOSC/64 - 0x20 FOSC/32
	movwf		ADCON1

	banksel		INTCON
	movlw		0xC0
	movwf		INTCON
	banksel		PIR1
	clrf		PIR1
	banksel		T1CON
	movlw		0x31
	movwf		T1CON
	banksel		PIE1
	bsf			PIE1,TMR1IE


	banksel		PORTC

	movlw		0xE7
	movwf		TMR1H
	movlw		0x95
	movwf		TMR1L

	

again
	btfss		setinel,0
	goto		again

	bsf			ADCON0,GO
	btfsc		ADCON0,GO
	goto		$-1
	movf		ADRESH,w
	movwf		portb
	movf		portb,w
	swapf		portb,w
	movwf		PORTB
	banksel		ADRESL
	movf		ADRESL,w
	banksel		PORTC
	movwf		portc	

	movf		portc,w
	movwf		PORTC
		
	bcf			setinel,0






	ORG	0x2100				; data EEPROM location
	DE	1,2,3,4				; define first four EEPROM locations as 1, 2, 3, and 4




	END                       ; directive 'end of program'