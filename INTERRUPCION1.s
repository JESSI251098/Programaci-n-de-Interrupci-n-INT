PROCESSOR 16F887
    ;INSTITUTO TECNOLOGICO SUPERIOR DE COATZACOALCOS 
    ;INGENIERIA MECATR�NICA    PRACTICA 1: PROGRAMACION DE INTERRUPCION INT
    ;EQUIPO: LA EGG.CELENCIA          MATERIA:MICROCONTROLADORES
    ;INTEGRANTES:
    ;Agust�n Madrigal Luis          17080167          imct17.lagustinm@itesco.edu.mx
    ;Cruz Gallegos Isaac            17080186          imct17.icruzg@itesco.edu.mx
    ;God�nez Palma Jessi Darissel   17080205	imct17.jgodinezp@itesco.edu.mx
    ;Guzm�n Garc�a Omar de Jes�s    17080211          imct17.oguzmang@itesco.edu.mx
    ;Medina Ortiz Mauricio          17080237          imct17.mmedinao@itesco.edu.mx
    ;M�ndez Osorio Julia Vanessa    17080238          imct17.jmendezo@itesco.edu.mx
    ;DOCENTE:JORGE ALBERTO SILVA VALENZUELA 
    ;SEMESTRE:7�    GRUPO:A 
    ;FECHA: 16/10/2020
    
#include <xc.inc>
	
CONFIG FOSC = INTRC_NOCLKOUT
CONFIG WDTE = OFF
CONFIG PWRTE = ON
CONFIG MCLRE = OFF
CONFIG CP = OFF
CONFIG CPD = OFF
CONFIG BOREN = OFF
CONFIG IESO = OFF
CONFIG FCMEN = OFF
CONFIG DEBUG = OFF
    
CONFIG BOR4V=BOR40V
CONFIG WRT = OFF
    
    PSECT udata
    tick:
   DS	1
    counter:
   DS	1
    counter2:
   DS	1
   
    PSECT   code
    delay:
    movlw   0xFF
    movwf   counter
    counter_loop:
    movlw   0xFF
    movwf   tick
    tick_loop:
    decfsz  counter,f
    goto    counter_loop
    return
    
    PSECT   resetVec, class=CODE,delta=2
    resetVec:
	goto	main
    
    PSECT   isr,class=CODE,delta=2
    isr:
    btfss   INTCON,1
    retfie
    
    bcf	    INTCON,1
    movlw   0x11
    retfie
    
    PSECT   main,class=CODE,delta=2
    main:
    clrf    INTCON	    ;limpia el registro intcon para su uso
    movlw   0b11010000	    ;carga literal en el registro W (habilitaci�n de bits del INTCON)
    BANKSEL OSCCON	    ;se trabaja en OSCCON
    movlw   0b01110101	    ;se carga la literal en el reg. W
    movwf   OSCCON	    ;y el reg w se carga en osccon  
    BANKSEL PORTA	    ;se trabajar� en el puerto A    
    clrf    PORTA	    ;se habilita el puerto A como salida
    BANKSEL PORTB	    ;se trabajar� en PORTB
    clrf    PORTB	    ;se habilita el puerto B como salida
    movlw   0xFF	    ;se carga el reg. W con el valor hexadecimal 0xFF
    BANKSEL TRISB	    ;se trabajar� en TRISB
    movwf   TRISB	    ;se habilita TRISB
    BANKSEL ANSEL	    ;se trabaja en ANSEL
    movlw   0x00	    ;se carga en W el valor determinado
    movwf   ANSEL	    ;El valor cargado en W se mueve a ANSEL
    BANKSEL TRISA	    ;se trabaja en TRISA
    clrf    TRISA	    ;se habilita TRISA
    loop:
    BANKSEL PORTA
    call    delay	    ;hace un llamado a la subrutina delay
    movlw   0x01	    
    xorwf   PORTA,f	    ;se aplica funci�n l�gica en el PORTA registro F
    goto loop		    ;regresa a loop
    END	resetVec


