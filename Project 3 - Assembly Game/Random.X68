*-----------------------------------------------------------
* Title      :Random 
* Written by :
* Date       :
* Description: gets a random value and returns it to a location on the stack to be used for spawing objects. 
*-----------------------------------------------------------
getRandomValue:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack
    
    move.b  #8, d0 
    trap    #15                                 ** moves the current time into d1 
    move.l  d1, d2 
    and.l   #$1FFFF,d2                          ** bit mask needed for dividing by 4 
    divu    #4,d2
    clr.w   d2
    swap    d2                                  ** puts the remainder of the divide into d2, as the random value 
    
*    
    move.l  d2, RANDOM_VALUE(sp)                ** move the random value into the location in memory on the stack 
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
