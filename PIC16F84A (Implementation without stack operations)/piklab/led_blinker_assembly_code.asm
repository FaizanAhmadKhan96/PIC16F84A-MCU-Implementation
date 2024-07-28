RESET CODE 0x000
     goto main

ISR CODE 0x004
     goto isr_handler

MAIN CODE
isr_handler  ; interrupt code goes here

main

; your code goes here

;*****Set up the Constants**** 

STATUS  equ 03h      ;Address of the STATUS register
TRISA   equ 85h      ;Address of the tristate register for port A
PORTA   equ 05h      ;Address of Port A
COUNT1  equ 08h      ;First counter for our delay loops
COUNT2  equ 09h      ;Second counter for our delay loops 

;****Set up the port**** 

        bsf     STATUS,5     ;Switch to Bank 1
        movlw   00h          ;Set the Port A pins
        movwf   TRISA        ;to output.
        bcf     STATUS,5     ;Switch back to Bank 0 



;****Turn the LED on**** 
Start  movlw    05h     ;value 5 to counter1
       movwf    COUNT1  ;transfer
       movlw    0Ah     ;value 10 to counter2
       movwf    COUNT2  ; transfer
       movlw    02h     ;Turn the LED on by first putting
       movwf    PORTA   ;it into the w register and then
                         ;on the port 

;****Start of the delay loop 1**** 

Loop1   decfsz   COUNT1,1       ;Subtract 1 from 255
        goto     Loop1          ;If COUNT is zero, carry on.
        movlw    05h            ;value 5 to counter1
        movwf    COUNT1         ;transfer
        decfsz   COUNT2,1       ;Subtract 1 from 255
        goto     Loop1          ;Go back to the start of our loop.
                                ;This delay counts down from
                                ;255 to zero, 255 times

;****Delay finished, now turn the LED off**** 

        movlw   00h                     ;Turn the LED off by first putting
        movwf   PORTA                   ;it into the w register and then on
                                        ;the port 

;****Add another delay**** 
;Initial values
        movlw    05h     ;value 5 to counter1
        movwf    COUNT1  ;transfer
        movlw    0Ah     ;value 10 to counter2
        movwf    COUNT2  ; transfer
Loop2   decfsz  COUNT1,1        ;This second loop keeps the
        goto    Loop2           ;LED turned off long enough for
        movlw    05h            ;value 5 to counter1 
        movwf    COUNT1  ;transfer
        decfsz  COUNT2,1        ;us to see it turned off
        goto    Loop2           ; 

;****Now go back to the start of the program

        goto    Start      ;go back to Start and turn LED
                           ;on again 

;****End of the program**** 

end                 ;Needed by some compilers,
                    ;and also just in case we miss
                    ;the goto instruction.
