*-----------------------------------------------------------
* Title      :Collision
* Written by :
* Date       :
* Description: takes the position of the player and the obsticle on the screen
* and checks to see if the player's position is inside of the obsticles position using the if statements stated below 
*-----------------------------------------------------------

** if all of the if statements are true then the object is coliding, and call endGame, if one of the if statements is calse 
** then return and continue the game loop. 
checkCollisions:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 

** player min x <= object max x 
    move.l  PLAYER_X_DISPLAY(sp), d0 
    move.l  OBJECT_1_X_DISPLAY(sp), d1
    move.l  OBJECT_1_WIDTH(sp), d2 
    subi.l  #OBJECT_VELOCITY, d2
    add.l   d2, d1
    cmp.l   d0, d1 
    blt     notColliding 
** player max x >= object min x 
    move.l  PLAYER_WIDTH(sp), d2 
    add.l   d2, d0 
    move.l  OBJECT_1_X_DISPLAY(sp), d1 
    cmp.l   d0, d1 
    bgt     notColliding 
** player min Y <= object max Y  
    move.l  PLAYER_Y_DISPLAY(sp), d0 
    move.l  OBJECT_1_Y_DISPLAY(sp), d1
    move.l  PLAYER_HEIGHT(sp), d2
    add.l   d2, d0 
    cmp.l   d0, d1 
    bgt     notColliding
** player max Y >= Object min Y 
    move.l  PLAYER_Y_DISPLAY(sp), d0 
    move.l  OBJECT_1_HEIGHT(sp), d2 
    add.l   d2, d1 
    cmp.l   d0, d1 
    blt     notColliding 
**if all these cases are true then it is coliding 
colliding:
    jsr     endGame

notColliding:
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack  



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
