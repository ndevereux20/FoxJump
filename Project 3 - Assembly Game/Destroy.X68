*-----------------------------------------------------------
* Title      :Destroy 
* Written by :
* Date       :
* Description: Destroys the obsticle when the DESTROY_OBJECT_BOOL is set in UpdateObsticle 
*-----------------------------------------------------------
* loads 
destroyObsticle:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack
    
    move.l  #0, SCORE_ADDED_BOOL(sp)            ** resets the score added bool 
    
    move.l  A4_OFFSET(sp),a1 
    
    move.l  #0, DESTROY_OBJECT_BOOL(sp)         ** resets the object destroyed bool 
    
    move.l  #0, D7_OFFSET(sp)
    move.l  #DRAW_PARAMETERS, d0                ** moves the draw paramaters (number of paramaters for drawing the bitmap sprite, 6, into d0 as a counter)

* places FFFFFFFF into the objects location in memory on the stack (this indicates an object does not exist) 
* it does this Draw Parameters amount of times    
obsticleLoop:
    move.l  (a1)+, d5
    
    move.l  #$FFFFFFFF,(sp,d5)
    subi.l  #1, d0 
    cmpi.l  #0, d0
    bne     obsticleLoop 

    movem.l (sp)+, ALL_REG  ** return, and reset the stack 
    rts             


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
