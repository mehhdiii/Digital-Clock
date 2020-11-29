/*
LDI  R16, (1<<5)
SBI   DDRB,5	;PB5 as an output
LDI   R17, 0
OUT  PORTB, R17    ; all ports low

START:
Call Delay
EOR  R17,R16     ; toggle D5 of R17
OUT  PORTB, R17
RJMP START

Delay:
LDI R20, 242
OUT TCNT0, R20
LDI R20, 0x00
OUT TCCR0A, R20
LDI R20, 0x01
OUT TCCR0B, R20
Again :
in  r20	,   TIFR0	; r eading  TIFR0 r e g i s t e r	( I / O r e g i s t e r )
sbrs   r20	,  TOV0   ; s k i p s   t he  n e x t	i n s t r u c t i o n
;if	b i t   TOV0  i s	s e t  i n	r e g i s t e r r 20
rjmp  Again	; jumps  t o   l a b e l  Again ,	u n t i l	b i t   TOV0  i s	s e t
ldi   r20	, 0x00
out TCCR0B , r20 ; t i m e r 0 i s s t opped
ldi r20 , (1<<TOV0 )
out  TIFR0   ,   r20  ; r e s e t t i n g	r e g i s t e r TIFR0
ret
*/
/*
LDI  R16, (1<<0)
SBI   DDRB,0	;PB5 as an output
LDI   R17, 0
OUT  PORTB, R17    ; all ports low

START:
Call Delay
EOR  R17,R16     ; toggle D5 of R17
OUT  PORTB, R17
RJMP START

Delay:
LDI R20, 131
OUT TCNT0, R20
LDI R20, 0x00
OUT TCCR0A, R20
LDI R20, 0x03
OUT TCCR0B, R20
Again :
in  r20	,   TIFR0	; r eading  TIFR0 r e g i s t e r	( I / O r e g i s t e r )
sbrs   r20	,  TOV0   ; s k i p s   t he  n e x t	i n s t r u c t i o n
;if	b i t   TOV0  i s	s e t  i n	r e g i s t e r r 20
rjmp  Again	; jumps  t o   l a b e l  Again ,	u n t i l	b i t   TOV0  i s	s e t
ldi   r20	, 0x00
out TCCR0B , r20 ; t i m e r 0 i s s t opped
ldi r20 , (1<<TOV0 )
out  TIFR0   ,   r20  ; r e s e t t i n g	r e g i s t e r TIFR0
ret
*/
/*
LDI  R16, (1<<0)
SBI   DDRC,0	;PB5 as an output
SBI   DDRC,1	;PB5 as an output
SBI   DDRC,2	;PB5 as an output
SBI   DDRC,3	;PB5 as an output
SBI   DDRC,4	;PB5 as an output
LDI R17, 0xFF
OUT PORTC, R17

LDI  R16, (1<<4)
CBI   DDRD,4


LDI R20, 0x00
OUT TCNT0, R20

LDI R20, 0x00
OUT TCCR0A, R20
LDI R20, 0x06
OUT TCCR0B, R20

START:
IN R19, TCNT0
OUT PORTC, R19
RJMP START
*/

LDi r16, HIGH(RAMEND)
OUT SPH, r16
LDI r16, LOW(RAMEND)
OUT SPL, r16
LDI r17, 0xFF
OUT DDRB, r17	;second unit
OUT DDRC, r17	;minutes
OUT DDRD, r17	;second tens

LDI r17,0  ;second unit
LDI r18,0  ;second tens
LDI r21,0  ;minutes

LDI r22,10
LDI r24,6

Count:
OUT portb,r17
RCALL pass_second
inc r17
cp r17,r22
breq addSecondTens
rjmp Count

addSecondTens:
LDI r17,0
inc r18
OUT portb,r17
OUT portd,r18
inc r23
cp r18,r24
breq addMinutes
rjmp Count

addMinutes:
LDI r17,0
LDI r18,0
inc r21
OUT portb,r17
OUT portd,r18
OUT portc,r21
rjmp Count


pass_second:
LDI r20, 0x00
STS TCNT1H,r20
STS TCNT1L,r20

LDI r20, 0b111101	;wite 15625 to OCCR1
STS OCR1AH, R20
LDI r20, 0b00001001
STS OCR1AL, R20

LDI r20,0
STS TCCR1A,r20
LDI r20,13
STS TCCR1B, r20	; CTC Mode Prescalar 1024

again:
SBIS TIFR1,OCF1A  ;check OCF set?
rjmp again
LDI r19,0
sts tccr1b,r19 ;stop timer
sts tccr1a,r19
LDI r20, 1<<OCF1A
OUT TIFR1, r20	;clear OCF1A flag
ret



