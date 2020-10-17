PROCESSOR 16F887
    ;INSTITUTO TECNOLOGICO SUPERIOR DE COATZACOALCOS 
    ;INGENIERIA MECATRÓNICA    PRACTICA 1: PROGRAMACION DE INTERRUPCION INT
    ;EQUIPO: LA EGG.CELENCIA          MATERIA:MICROCONTROLADORES
    ;INTEGRANTES:
    ;Agustín Madrigal Luis          17080167          imct17.lagustinm@itesco.edu.mx
    ;Cruz Gallegos Isaac            17080186          imct17.icruzg@itesco.edu.mx
    ;Godínez Palma Jessi Darissel   17080205	imct17.jgodinezp@itesco.edu.mx
    ;Guzmán García Omar de Jesús    17080211          imct17.oguzmang@itesco.edu.mx
    ;Medina Ortiz Mauricio          17080237          imct17.mmedinao@itesco.edu.mx
    ;Méndez Osorio Julia Vanessa    17080238          imct17.jmendezo@itesco.edu.mx
    ;DOCENTE:JORGE ALBERTO SILVA VALENZUELA 
    ;SEMESTRE:7°    GRUPO:A 
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
    movlw   0b11010000	    ;carga literal en el registro W (habilitación de bits del INTCON)
    BANKSEL OSCCON	    ;se trabaja en OSCCON
    movlw   0b01110101	    ;se carga la literal en el reg. W
    movwf   OSCCON	    ;y el reg w se carga en osccon  
    BANKSEL PORTA	    ;se trabajará en el puerto A    
    clrf    PORTA	    ;se habilita el puerto A como salida
    BANKSEL PORTB	    ;se trabajará en PORTB
    clrf    PORTB	    ;se habilita el puerto B como salida
    movlw   0xFF	    ;se carga el reg. W con el valor hexadecimal 0xFF
    BANKSEL TRISB	    ;se trabajará en TRISB
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
    xorwf   PORTA,f	    ;se aplica función lógica en el PORTA registro F
    goto loop		    ;regresa a loop
    END	resetVec


