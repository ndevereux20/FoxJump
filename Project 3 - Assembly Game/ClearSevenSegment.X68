*-----------------------------------------------------------
* Title      :ClearSevenSegment 
* Written by :
* Date       :
* Description: clears the screen at the location of the seven segment 
*-----------------------------------------------------------

** draws a black rectangle where the seven segment is on every game loop cycle 
clearSevenSegment: 
    movem.l ALL_REG, -(sp)
    
    lea     sevenSegmentLocation, a3            *loads the array of paramaters for the draw rectangle function 
    
    move.l  #OBSTICLE_BACKGROUND_COLOR, d1 
    move.l  #PEN_COLOR_TRAP_CODE, d0
    trap    #15 
    move.l  #OBSTICLE_BACKGROUND_COLOR, d1 
    move.l  #FILL_COLOR_TRAP__CODE, d0
    trap    #15 
    
    move.w  (a3)+, d1                           ** places coordinates into appropriate registers 
    move.w  (a3)+, d2 
    move.w  (a3)+, d3 
    move.w  (a3)+, d4 
    
    move.l  #DRAW_RECTANGLE_COMMAND, d0 
    trap    #15
    
    movem.l (sp)+, ALL_REG
	rts   

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
