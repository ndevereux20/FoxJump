*-----------------------------------------------------------
* Title      :GetObsticle 
* Written by :
* Date       :
* Description: This function checks to see if it has been an appropriate amount of frames since last spawning an object, and if an object is not spawned in the Obsticle1 location 
* in memory on the stack (indiated by FFFFFFFF). If these are both true then get the random value from the Random function and load the crop locations for that sprite into obsticle1's 
* location in memory on the stack 
*-----------------------------------------------------------
    
getObsticleSprite:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 
    
    move.l  D7_OFFSET(sp),d0                    ** checks to see if its been the appropriate amount of frames since last object spawned 
    cmpi.l  #FRAMES_SKIP_TO_DRAW,d0
    bne     returnGetObsticleSprite
    move.l  #0, D7_OFFSET(sp)                   ** resets the frames since object has been created counter                      
    move.l  A4_OFFSET(sp),a1 
    
    move.l  A6_OFFSET(sp),a0 
    move.l  #DRAW_PARAMETERS, d0                ** move how many paramaters we have to pass into the draw function
    lsl.l   #2, d0                              ** multiply by 4 becasue we are using longs 
    
    move.l  RANDOM_VALUE(sp),d1                 ** multiply it by the random number (gets a random object) 
    mulu    d0, d1
    move.l  a0, d3 
    add.l   d1, d3                              ** add it to the pointer to obsticleSprites 
    move.l  d3, a0    
    
** checks if there isnt an object already in Objects 1 location in memory 
** if there is then return, if not then jump to putInObject1 
checkWhereToPutObject 
    move.l  OBJECT_1_X_CROP(sp), d4 
    cmpi.l  #$FFFFFFFF, d4 
    beq     putInObject1
    bne     returnGetObsticleSprite
 
** puts the appropriate sprite (as determined by the random number) into obsticles1 location in memory       
putInObject1:    
    move.l  #0, D7_OFFSET(sp)
    move.l  #DRAW_PARAMETERS, d0
object1Loop:
    move.l  (a1)+, d5                           ** puts and the value at a1 (obsticleLocations) into d5 and post increments the location in memory
    move.l  (a0)+, d4                           ** puts and the value at a0 (obsticleSprites) into d4 and post increments the location in memory
    move.l  d4,(sp,d5)                          ** puts the value of d4, into the right location on the stack ( as determined by d5) 
    subi.l  #1, d0 
    cmpi.l  #0, d0
    bne     object1Loop
    beq     returnGetObsticleSprite

returnGetObsticleSprite
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack  


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
