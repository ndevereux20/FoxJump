*-----------------------------------------------------------
* Title      :sevenSegment 
* Written by :
* Date       :
* Description: This file contains code for drawing the seven segment, it houses 3 functions the "sevenSegment" function, the "draw1s7Segment" function, and the "draw10s7segment" function. 
* the seven segment function loops through to determine what segments to draw in the draw functions. The draw function draws the appropriate segment whose locations are in their corresponding word arrays 
* when called upon. 
*-----------------------------------------------------------
*the seven segment function takes the current score and divides it by 10, placing the remainder in d3 (1's digit) and the value in d4 (10's digit) 
*it then offsets into the bitmaskTable the appropriate value for each the 1's and 10's place 
*next it loops through the bitmask value for the specified number checking if a bit is set or not by anding it by 1 
*if it is set, then jump to the draw function for the corresponding place, if not increment the counter and shift the bitmask over to get the next segment
sevenSegment:
    movem.l ALL_REG, -(sp)
    
    lea     bitmaskTable, a0  
    lea     drawLocations10s, a2 
   
    move.l  SCORE(sp),d0 
    move.l  d0, d1 
    divu    #10, d1 
    move.w  d1, d2          ;; 10's digit 
    swap.w  d1
    move.w  d1, d3          ;; remainder or 1's digit  
offsetTo1Digit:
    add.l   d3, a0 
    move.b  (a0),d4                ;; moves the mask of the 1's value 
    move.l  #0, d7                  ;; loop counter 
loop1sDigit:
    move.b  d4, d0 
    andi.b  #1, d0
    beq     skip1sDraw              ;; checks if the bit is set, if it is then draw the segment,
    jsr     draw1s7Segment          ;; if not increment the counter and shift 
skip1sDraw: 
    lsr.b   #1, d4                  ;; shifts the bit over by 1 to get the next bitmask segment
    add.l   #1, d7 
    cmpi.l  #7, d7
    blt     loop1sDigit             ;; branch out if reached max bit checks (7 because A-G) 
******************************************** 10's    
offsetTo10sDigit:
    lea     bitmaskTable, a0 
    add.l   d2, a0
    clr.l   d4
    move.b  (a0),d4
    move.l  #0, d7
loop10sDigit: 
    move.b  d4, d0 
    andi.b  #1, d0
    beq     skip10sDraw             ;; checks if the bit is set, if it is then draw the segment,
    jsr     draw10s7Segment         ;; if not increment the counter and shift 
skip10sDraw: 
    lsr.b   #1, d4                  ;; shifts the bit over by 1 to get the next bitmask segment
    add.l   #1, d7 
    cmpi.l  #7, d7
    blt     loop10sDigit            ;; branch out if reached max bit checks (7 because A-G) 

    movem.l (sp)+, ALL_REG
	rts   
********************************************** DRAW
*the draw functions load the appropriate table of draw locations for the 1's and 10's segment 
*into a1, it then goes to the appropriate segment (A-G) in the table then draws the line at (x1, y1) (x2, y2)
draw1s7Segment:
    movem.l ALL_REG, -(sp)
    lea     drawLocations1s, a1 
    move.l  d7, d6 
    mulu    #8, d6
    add.l   d6, a1
    
    move.l  #WHITE, d1 
    move.l  #PEN_COLOR_TRAP_CODE, d0
    trap    #15
    move.b  #PEN_WIDTH, d1
    move.b  #PEN_WIDTH_TRAP_CODE, d0 
    trap    #15 
    move.w  (a1)+, d1 
    move.w  (a1)+, d2 
    move.w  (a1)+, d3 
    move.w  (a1),d4
    move.l  #DRAW_LINE_TRAP_CODE, d0 
    trap    #15 
    
    movem.l (sp)+, ALL_REG
	rts  

draw10s7Segment:
    movem.l ALL_REG, -(sp)
    lea     drawLocations10s, a1 
    move.l  d7, d6 
    mulu    #8, d6
    add.l   d6, a1
    
    move.l  #WHITE, d1 
    move.l  #PEN_COLOR_TRAP_CODE, d0
    trap    #15
    move.b  #PEN_WIDTH, d1
    move.b  #PEN_WIDTH_TRAP_CODE, d0 
    trap    #15 
    move.w  (a1)+, d1 
    move.w  (a1)+, d2 
    move.w  (a1)+, d3 
    move.w  (a1),d4
    move.l  #DRAW_LINE_TRAP_CODE, d0 
    trap    #15 
    
    movem.l (sp)+, ALL_REG
	rts  





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
