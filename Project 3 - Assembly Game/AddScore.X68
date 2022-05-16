*-----------------------------------------------------------
* Title      :AddScore 
* Written by :
* Date       :
* Description: checks to see if the player has made it past the object, if it has then add 1 to the score, otherwise return and dont add to the score  
*-----------------------------------------------------------
addScore: 
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 

    
    move.l  PLAYER_X_DISPLAY(sp), d0 
    move.l  OBJECT_1_X_DISPLAY(sp), d1 
    cmp.l   d0, d1 
    bgt     returnAddScore
    move.l  SCORE_ADDED_BOOL(sp), d0 
    cmpi.l  #1, d0
    beq     returnAddScore
 
    move.l  #1, SCORE_ADDED_BOOL(sp)    
    move.l  SCORE(sp), d0 
    addi.l  #1, d0 
    move.l  d0, SCORE(sp)
    
returnAddScore:  
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack  


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
