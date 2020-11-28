/*
 * GccApplication1.c
 *
 * Created: 11/28/2020 1:40:57 PM
 * Author : Mehdi Raza Khorasani
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int extratime = 0; //counting upto a second
int seconds = 0; 
int minutes = 0; 
int hours; 
int main(void)
{
    
	DDRB = 0x01; //configure port B as output for seconds
	DDRC = 0x01; //configure port C as output for minutes
	DDRD = 0x01; //configure port D as output for hours 
	
	TCCR0A = (1 << WGM01); 
	OCR0A = 195; //set the compare match value for the timer
    while (1) 
    {
		sei(); //enable global interrupt
    }
	
}
ISR(TIMER0_COMPA_vect){//interrupt which updates the state of digital clock 
	extratime++; 
	if(extratime>100){
		//digital clock logic:
		if (hours == 24){
			//if 24 hours passed, reset hours 
			hours = 0; 
		} 
		if (minutes == 60){
			//check if minutes have moved upto 60: if yes then reset to zero and add 1 to hours
			minutes=0; //reset minutes
			hours++; 
			
		}
		if(seconds ==60){
			//check if seconds have moved upto 60: if yes then reset to zero and add 1 to minutes
			seconds = 0; //reset seconds
			minutes++; 
			
		}
		else{
			seconds++; 
			
		}
		
		PORTB = seconds; //write the value of seconds to PORTB
		PORTC = minutes; //write the value of minutes to PORTC
		extratime= 0; 
		
	}
}

