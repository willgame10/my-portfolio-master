;
; SOSApp.asm
;
; Created: 9/18/2020 3:53:53 PM
; Author : william Howell
; Purpose: blink a light on the Arduino displaying an SOS message in morse code.

.def      blink_ntimes = r19
.def      p_delay = r20
.def      lc_100ms = r21
.def      lc_250 = r22
.def      blink_interval = r23

.equ      DOT = 3
.equ      DASH = 6
.equ      WORD_BREAK = DASH + DASH
    



start:              ;initialize the stack pointer
                    ldi       r16, LOW(RAMEND)
                    out       SPL, r16
                    ldi       r16, HIGH(RAMEND)
                    out       SPH, r16

                    ;force clock to 1mhz
                    ldi       r16, 0b10000000     ;CLKPCE
                    sts       CLKPR, r16          ;enable clock prescaler change
                    ldi       r16, 0b00000011     ;DIV8 mask
                    sts       CLKPR, r16          ;set clock prescaler to DIV8

                    sbi       DDRB, PB5           ;setting PORT B to output

SOS_signal:
                    ;output S in morse code
                                          ;=
                    ldi       blink_ntimes , 3              
                    ldi       blink_interval , DOT
                    call      blink_PBp5
                    
                    ;dash delay
                    ldi       p_delay, DASH-DOT
                    call      delay_ms

                    ;output O in morse code
                    ldi       blink_ntimes , 3              
                    ldi       blink_interval , DASH
                    call      blink_PBp5

                    ;output S in morse code
                    ldi       blink_ntimes , 3              
                    ldi       blink_interval , DOT
                    call      blink_PBp5
                    
                    ;Word break between SOS signal
                    ldi       p_delay, WORD_BREAK
                    call      delay_ms


end_main:           rjmp      SOS_signal


;blink_ntimes = 3
;blink_interval
blink_PBp5:                                                 ;do{
                    sbi       PORTB, PB5
                    mov       p_delay, blink_interval
                    call      delay_ms                      ;call      line 100

                    cbi       PORTB, PB5
                    mov       p_delay, blink_interval
                    call      delay_ms                      ;call      line 100

                    dec       blink_ntimes                  ;blink_ntimes--
                    brne      blink_PBp5                    ;}while(blink_ntimes > 0)
                    
                    ret                                     ;returning from blink_PBp5

;x = 5
;y = 5
;x - y = 0
;==

delay_ms:
                    ldi       lc_100ms, 80
lp_100ms:
                    ldi       lc_250, 250
lp_250:
                    nop
                    nop
                    dec       lc_250
                    brne      lp_250

                    dec       lc_100ms
                    brne      lp_100ms

                    dec       p_delay
                    brne      delay_ms

                    ret