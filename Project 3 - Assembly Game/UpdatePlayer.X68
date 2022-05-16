*-----------------------------------------------------------
* Title      :UpdatePlayer 
* Written by :
* Date       :
* Description: This subroutine changes the players sprite, and location on the screen 
* if the player is not jumping (checks keycode returned from getKeyboardInput) then run 
* through the sprite animation for running. If the player is jumping change the position of the player by using projectile motion. 
*-----------------------------------------------------------
updatePlayerSprite:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 
    
    ** move the players current position into the stack, to be accessed in the drawBackground function
    move.l  D4_OFFSET(sp),PLAYER_X_CROP(sp)
    move.l  D5_OFFSET(sp),PLAYER_Y_CROP(sp)
    move.l  D2_OFFSET(sp),PLAYER_WIDTH(sp)
    move.l  D3_OFFSET(sp),PLAYER_HEIGHT(sp)
    move.l  D4_OFFSET(sp),PLAYER_X_DISPLAY(sp)
    move.l  D5_OFFSET(sp),PLAYER_Y_DISPLAY(sp)

    move.l  KEYCODE_VALUE(sp), d1 
    andi.l  #$FF, d1 
    bne     jumping

** change the sprite every frame to make it look like the player is running 
running: 
    move.l  D6_OFFSET(sp),d0
    move.l  #0,d1 
    move.l  D2_OFFSET(sp),d2 
    
    mulu    d0,d2
    add.l   d2,d1
    move.l  d1,D0_OFFSET(sp)
    move.l  d1,PLAYER_SPRITE_X_CROP(sp)
    bra     returnUpdatePlayerSprite

;p(t) = p(0) + v(0)t + a*t^2/2
; set some value to 1 if it reaches here, and check if that value in the draw player function to start a jumping animation
;
jumping:
    move.l  #1, IS_JUMPING(sp)
    move.l  D5_OFFSET(sp),d0
    
    ** change the position based off the current velocity 
    ** velocity will change each frame based off of gravity 
    move.l  CUR_PLAYER_CHANGE_IN_VELOCITY(sp), d1           ** this is a value that goes up and is used to shift to know what to subtract from the players velocity 
    move.l  CUR_PLAYER_VELOCITY(sp),d4
    move.l  #GRAVITY, d2
    sub.l   d2, d1                                          ** add gravity to CUR_PLAYER_CHANGE_IN_VELOCITY
    move.l  d1, d3 
    move.l  d3, CUR_PLAYER_CHANGE_IN_VELOCITY(sp)
    lsr.l   #8, d3                                          ** shift it by 8 to determine what value to subtract from the CUR_PLAYER_VELOCITY 
    sub.l   d3, d4 
    move.l  d4, CUR_PLAYER_VELOCITY(sp)
    sub.l   d4, d0                                          ** subtract the current players velocity from the players y position 


    move.l  d0, D5_OFFSET(sp)
    move.l  d0,PLAYER_SPRITE_Y_DISPLAY(sp)
    
    cmpi.l  #(DISPLAY_WINDOW_HEIGHT - 70), d0               ** checks to see if the player will go below the screen bounds, if it does then stop jumping, otherwise return 
    blt     returnUpdatePlayerSprite 

* stops the player from jumping by reseting values, and sets the IS_JUMPING bool to false   
stopJumping:
    move.l  #410, D5_OFFSET(sp)                             
    move.l  #410, PLAYER_SPRITE_Y_DISPLAY(sp)
    move.l  #0, IS_JUMPING(sp)
    move.l  #JUMP_VELOCITY, CUR_PLAYER_VELOCITY(sp)
    move.l  #JUMP_VELOCITY, CUR_PLAYER_CHANGE_IN_VELOCITY(sp)  
returnUpdatePlayerSprite
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
