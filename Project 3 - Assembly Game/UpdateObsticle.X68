*-----------------------------------------------------------
* Title      :UpdateObsticle 
* Written by :
* Date       :
* Description: updates the obsticles position on the screen by adding the object velocity to it. If the object is going to move off the screen 
* set the destroy object bool to 1 so DestroyObject is called 
*-----------------------------------------------------------
updateObsticle: 
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack
    
   
obsticle1:
    move.l  OBJECT_1_X_DISPLAY(sp), d0 
    cmpi.l  #$FFFFFFFF, d0 
    beq     returnUpdateObsticle                ** checks to see if an object actually exists 
    
    subi.l  #OBJECT_VELOCITY, d0
    move.l  d0, OBJECT_1_X_DISPLAY(sp)          ** adds the velocity to the current position 
    
    move.l  #OBJECT_VELOCITY, d2
    cmp.l   d2, d0
    bgt     returnUpdateObsticle                ** checks to see if the object will go off screen, if it doesnt return, if it does then set the object to be destroyed 
    
    move.l  #1, DESTROY_OBJECT_BOOL(sp)
    
returnUpdateObsticle: 
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
