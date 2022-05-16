*-----------------------------------------------------------
* Title      :PutInregisters 
* Written by :
* Date       :
* Description: this houses functions for putting the right values of paramaters into the right registrs to be used by the draw functions 
*-----------------------------------------------------------
putPlayerSpriteInRegisters: 
                        
    move.l  (PLAYER_SPRITE_X_CROP - REGISTERS_OFFSET_2)(sp),d0                            ** load the crop location of the sprite sheet 
    move.l  (PLAYER_SPRITE_Y_CROP - REGISTERS_OFFSET_2)(sp),d1
    move.l  (PLAYER_SPRITE_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    move.l  (PLAYER_SPRITE_HEIGHT - REGISTERS_OFFSET_2)(sp),d3
    move.l  (PLAYER_SPRITE_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (PLAYER_SPRITE_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (PLAYER_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp),a0
    rts
 
putPlayerCropLocationInRegisters:
    move.l  (PLAYER_X_CROP - REGISTERS_OFFSET_2)(sp),d0
    move.l  (PLAYER_Y_CROP - REGISTERS_OFFSET_2)(sp),d1
    move.l  (PLAYER_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    move.l  (PLAYER_HEIGHT - REGISTERS_OFFSET_2)(sp),d3 
    move.l  (PLAYER_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (PLAYER_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (BACKGROUND_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp),(a2)
    move.l  (a2),a0  
    rts
    
putObsticle1InRegisters: 
    move.l  (OBJECT_1_X_CROP - REGISTERS_OFFSET_2)(sp),d0
    move.l  (OBJECT_1_Y_CROP - REGISTERS_OFFSET_2)(sp),d1
    move.l  (OBJECT_1_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    move.l  (OBJECT_1_HEIGHT - REGISTERS_OFFSET_2)(sp),d3
    move.l  (OBJECT_1_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (OBJECT_1_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (OBSTICLES_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp), (a2)
    move.l  (a2),a0  
    rts
    
putObsticle2InRegisters: 
    move.l  (OBJECT_2_X_CROP - REGISTERS_OFFSET_2)(sp),d0
    move.l  (OBJECT_2_Y_CROP - REGISTERS_OFFSET_2)(sp),d1
    move.l  (OBJECT_2_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    move.l  (OBJECT_2_HEIGHT - REGISTERS_OFFSET_2)(sp),d3
    move.l  (OBJECT_2_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (OBJECT_2_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (OBSTICLES_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp), (a2)
    move.l  (a2),a0
    rts
putObsticle1LocationInRegisters:
    move.l  (OBJECT_1_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d0
    move.l  (OBJECT_1_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d1
    move.l  (OBJECT_1_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    addi.l  #OBJECT_VELOCITY, d2                                    ** adds the objects velocity to be sure to redraw all locations the object has covered 
    move.l  (OBJECT_1_HEIGHT - REGISTERS_OFFSET_2)(sp),d3
    move.l  (OBJECT_1_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (OBJECT_1_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (BACKGROUND_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp),(a2)
    move.l  (a2),a0  
    rts
putObsticle2LocationInRegisters:
    move.l  (OBJECT_2_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d0
    move.l  (OBJECT_2_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d1
    move.l  (OBJECT_2_WIDTH - REGISTERS_OFFSET_2)(sp),d2
    addi.l  #OBJECT_VELOCITY, d2                                    ** adds the objects velocity to be sure to redraw all locations the object has covered 
    move.l  (OBJECT_2_HEIGHT - REGISTERS_OFFSET_2)(sp),d3
    move.l  (OBJECT_2_X_DISPLAY - REGISTERS_OFFSET_2)(sp),d4
    move.l  (OBJECT_2_Y_DISPLAY - REGISTERS_OFFSET_2)(sp),d5
    move.l  (BACKGROUND_SPRITE_SHEET_POINTER - REGISTERS_OFFSET_2)(sp),(a2)
    move.l  (a2),a0  
    rts 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
