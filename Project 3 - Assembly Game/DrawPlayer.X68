*-----------------------------------------------------------
* Title      :DrawPlayer 
* Written by :
* Date       :
* Description:draws the player sprite as passed to it through update player, ignores the player sprite sheet background color
*-----------------------------------------------------------
drawPlayerSprite: 
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 
   
    move.l  D4_OFFSET(sp),-CUR_DISPLAY_X(sp)    ** moves the starting width into the stack (bottom left) 
    move.l  D5_OFFSET(sp),d0 
    add.l   D3_OFFSET(sp),d0
    move.l  d0, -CUR_DISPLAY_Y(sp)              ** moves the starting height into the stack (bottom left)
    move.l  D3_OFFSET(sp),-LOOP_COUNTER(sp)     ** initialize the loop counter to be the height of the crop 
  
    move.l  OFFSET_TO_IMAGE_WIDTH(a0),d3        ** 18 is the offset in the header file for the width of the image 
    rol.w   #8, d3                              ** Little Endian swap
    swap.w  d3 
    rol.w   #8, d3      

    move.l  OFFSET_TO_IMAGE_HEIGHT(a0),d4       ** 22 is the offset in the header file for the height of the image 
    rol.w   #8, d4                              ** Little Endian Swap
    swap.w  d4 
    rol.w   #8, d4      
     
    move.l  OFFSET_TO_IMAGE_OFFSET(a0),d5       ** 10 is the offset to the header location that stores the offset to the start of the pixel data from the start of the header
    rol.w   #8, d5                              ** Little Endian Swap
    swap.w  d5
    rol.w   #8, d5
    add.l   a0, d5
    move.l  d5, a2                              **a2 is a pointer to the start of the pixel data (bottom left corner)
       
    
    move.l  d3, d6               
    move.l  d4, d7               
    move.l  #0, d5               
**jumps to the bottom left corner of the bitmap chunk to be drawn in memory by getting the offset in bytes 
**or in terms of coordinates...this is (x = crop_x, y = crop_y + crop_height) 
**this is done by: (((Image_Height - (crop_y + crop_height)) * Image_Width) + crop_x) * 4 
*d5 is used as a buffer to store temporary values for this calcualtion 
getInitialOffset: 
    add.l   D1_OFFSET(sp),d5 
    add.l   D3_OFFSET(sp),d5 
    sub.l   d5, d7
    mulu    d3, d7 
    add.l   D0_OFFSET(sp),d7
    lsl.l   #2, d7                             ** multiply by 4 by shifting it to the left by 4 bits 
    adda.l  d7, a2                             ** adds the offset to the pointer
    bra     drawRow

** increments the display index if the pixel isnt drawn because it is the background color of the sprite image     
incrementRow:
    move.l  -CUR_DISPLAY_X(sp),d1 
    
    addi.l  #1, d1                             ** increment the width 
    move.l  D2_OFFSET(sp),d5
    add.l   D4_OFFSET(sp),d5
    move.l  d1, -CUR_DISPLAY_X(sp)
    cmp.l   d1, d5                             ** compare it to the width of the crop 
    bgt     drawRow                            ** keep drawing until cur_width = crop_width
    move.l  -CUR_DISPLAY_Y(sp),d2
    bra     incrementHeight
**now that we are pointing to the bottom row of pixel data to be drawn.
**set the pen color for each pixel. 
**then draw at the appropriate location on the screen (as desired by the user)
**it draws until it reaches the end of the row, then decrements the height and jumps down to 'skipBytes'
*d5 is used for checking if we are done drawing the row 
drawRow: 
    move.l  (a2)+, d1                          ** move the first byte into memory 
    lsr.l   #8, d1                             ** shift to trash the alpha (00 BB GG RR format) 
    cmp.l   #SPRITE_BACKGROUND_COLOR, d1
    beq     incrementRow                       ** go to increment row to ignore the background color 
    move.l  #PEN_COLOR_TRAP_CODE,d0            ** make that pen color 
    trap    #15
    
    move.l  -CUR_DISPLAY_X(sp),d1              ** get the current width and height (of the display), draw at that location
    move.l  -CUR_DISPLAY_Y(sp),d2
    move.l  #DRAW_PIXEL_TRAP_CODE, d0
    trap    #15
    
    addi.l  #1, d1                             ** increment the width 
    move.l  D2_OFFSET(sp),d5
    add.l   D4_OFFSET(sp),d5
    move.l  d1, -CUR_DISPLAY_X(sp)
    cmp.l   d1, d5                             ** compare it to the width of the crop 
    bgt     drawRow                            ** keep drawing until cur_width = crop_width
incrementHeight:   
    move.l  D4_OFFSET(sp),-CUR_DISPLAY_X(sp)
    subi.l  #1, d2                             ** decrement the height 
    move.l  d2, -CUR_DISPLAY_Y(sp)

**this skips the necesary number of bytes to get to the next location in memory to draw 
**this is done by (Image_Width - Crop_width) * 4 
**it then adds this offset to the pointer to pixel data, and jumps to draw function a (crop_height) amount of times 
**d1 is used as a buffer to store temporary values for this calcualtion 
skipBytes:
    move.l  d6, d5
    sub.l   D2_OFFSET(sp),d5
    lsl.l   #2, d5 
    adda.l  d5, a2                             ** adds the offset as calculated above in skipBytes description to the pixel data pointer
    move.l  -LOOP_COUNTER(sp),d1
    subi.l  #1, d1 
    move.l  d1, -LOOP_COUNTER(sp)
    cmp.l   #0, d1
    bge     drawRow                            ** branch to drawRow as long as the loop counter doesnt reach 0  

** this updates the sprite to draw for the running animation by incrementing or reseting the sprite counter (d6) 
updateSpriteToDraw
    move.l  #0,D0_OFFSET(sp)
    move.l  D6_OFFSET(sp),d6                  **
    addi.l  #1, d6
    cmpi.l  #RUNNING_SPRITE_COUNT,d6 
    bge     resetSpriteCounter
** if the counter hasnt reached the max amount of sprites in the running animation, then increment 
incrementSpriteCounter:
    move.l  d6, D6_OFFSET(sp) 
    bra     returnDrawPlayerSprite  
** else if the counter has reached the max amount of sprites in the running animation, then reset the counter 
resetSpriteCounter:
    move.l  #0, d6
    move.l  d6, D6_OFFSET(sp) 
returnDrawPlayerSprite:
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
