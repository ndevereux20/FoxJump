*-----------------------------------------------------------
* Title      :Runner 
* Written by :
* Date       :
* Description: This is the main file of the game, it houses all global values, loaded in files (including other x68 files and bitmap files), and arrays/variables at the bottom of the file 
*there are 3 different areas in this file, the start loop, loads all appropriate values into registers, and shows the start screen to the user until the user presses enter. 
*The game loop which calls all necesary functions that should happen (including drawing the player, objects, getting collisions, drawing seven segment, adding scores, redrawing backgrounds, and swapping buffers)
*this loops until the win condition (reach score 99) or the lose condition (hit an object). The end screen is then loaded.
*the last area is the end game, where it displays your scores and prompts you to play again, sending you back to the game loop. 
*-----------------------------------------------------------
*Controlls: 
* press space to jump 
* click to continue from start screen and end screen to game screen 
* esc to quit the application on start and end screens
*-----------------------------------------------------------
** global values 
** offset to reisters when passed to the stack 
ALL_REG         REG     D0-D7/A0-A6
D0_OFFSET       EQU     0
D1_OFFSET       EQU     4
D2_OFFSET       EQU     8
D3_OFFSET       EQU     12
D4_OFFSET       EQU     16
D5_OFFSET       EQU     20
D6_OFFSET       EQU     24
D7_OFFSET       EQU     28
A0_OFFSET       EQU     32
A1_OFFSET       EQU     36
A2_OFFSET       EQU     40
A3_OFFSET       EQU     44
A4_OFFSET       EQU     48  
A5_OFFSET       EQU     52
A6_OFFSET       EQU     56

** used in the draw bitmap function for local variables 
CUR_DISPLAY_X      EQU     4
CUR_DISPLAY_Y      EQU     8
LOOP_COUNTER       EQU     12
ERROR_COUNTER_OFFSET      EQU     4

** used as constants to offsets from the start of the .bmp header file to important info 
OFFSET_TO_FILE_SIZE     EQU     2
OFFSET_TO_IMAGE_WIDTH   EQU     18
OFFSET_TO_IMAGE_HEIGHT  EQU     22 
OFFSET_TO_IMAGE_OFFSET  EQU     10
OFFSET_TO_IMAGE_BIT_DEPTH   EQU     28

** used for checks that it is the right type of file 
BIT_DEPTH                EQU     $20 
BMP_FILE_TYPE            EQU     $424D

** trap code commands for drawing on the screen  
FILL_COLOR_TRAP__CODE   EQU     81
PEN_COLOR_TRAP_CODE     EQU     80
DRAW_PIXEL_TRAP_CODE    EQU     82
SET_OUTPUT_RESOLUTION_TRAP_CODE EQU     33 
REPAINT_SCREEN_TRAP_CODE	EQU	    94
CLEAR_SCREEN_COMMAND    EQU     11
DRAWING_MODE_TRAP_CODE	EQU	92
DOUBLE_BUFFERED_MODE	EQU	17
DRAW_RECTANGLE_COMMAND      EQU     87 
PEN_WIDTH_TRAP_CODE     EQU     93 
DRAW_LINE_TRAP_CODE     EQU     84 
SET_FONT_PROPERTIES_TRAP_CODE   EQU     21 
DISPLAY_STRING_TRAP_CODE    EQU     14 
MOUSE_STATE_TRAP_CODE       EQU     61

*pen width for seven segment 
PEN_WIDTH       EQU     2 

** keyboard values and trap code 
USER_INPUT_TRAP_CODE    EQU     19
KEY_SPACE_INPUT         EQU     $20
KEY_ESCAPE_INPUT        EQU     $1B


CLEAR_SCREEN_MAGIC_VAL  EQU     $FF00

** new line and reset position values 
CR      EQU     $0D
LF      EQU     $0A

** display window info 
DISPLAY_WINDOW_WIDTH    EQU     640   
DISPLAY_WINDOW_HEIGHT   EQU     480

** player variables 
SPRITE_BACKGROUND_COLOR     EQU     $808000
RUNNING_SPRITE_COUNT        EQU     $6
JUMP_VELOCITY       EQU     20
GRAVITY             EQU     -174


** Offset to keycode value 
KEYCODE_VALUE       EQU     64

** players current position and chunk size to redraw background at 
PLAYER_X_CROP       EQU     68
PLAYER_Y_CROP       EQU     72
PLAYER_WIDTH        EQU     76
PLAYER_HEIGHT       EQU     80
PLAYER_X_DISPLAY    EQU     84
PLAYER_Y_DISPLAY    EQU     88

*current location to crop at on the player sprite sheet to run through animations. 
PLAYER_SPRITE_X_CROP   EQU     92
PLAYER_SPRITE_Y_CROP   EQU     96
PLAYER_SPRITE_WIDTH    EQU     100
PLAYER_SPRITE_HEIGHT   EQU     104
PLAYER_SPRITE_X_DISPLAY    EQU     108
PLAYER_SPRITE_Y_DISPLAY    EQU     112


PLAYER_SPRITE_SHEET_POINTER    EQU     116
BACKGROUND_SPRITE_SHEET_POINTER     EQU     120

CUR_PLAYER_VELOCITY     EQU     124
CUR_PLAYER_CHANGE_IN_VELOCITY   EQU 128
IS_JUMPING      EQU     132

RANDOM_VALUE    EQU     136

** Offsets for moving objects
OBJECT_3_X_CROP     EQU     140
OBJECT_3_Y_CROP     EQU     144
OBJECT_3_WIDTH    EQU     148   
OBJECT_3_HEIGHT   EQU     152
OBJECT_3_X_DISPLAY     EQU     156
OBJECT_3_Y_DISPLAY     EQU     160

OBJECT_2_X_CROP     EQU     164
OBJECT_2_Y_CROP     EQU     168
OBJECT_2_WIDTH    EQU     172 
OBJECT_2_HEIGHT   EQU     176
OBJECT_2_X_DISPLAY     EQU     180
OBJECT_2_Y_DISPLAY     EQU     184
    
OBJECT_1_X_CROP     EQU     188
OBJECT_1_Y_CROP     EQU     192
OBJECT_1_WIDTH    EQU     196 
OBJECT_1_HEIGHT   EQU     200
OBJECT_1_X_DISPLAY     EQU     204
OBJECT_1_Y_DISPLAY     EQU     208

OBSTICLES_SPRITE_SHEET_POINTER     EQU     212

DESTROY_OBJECT_BOOL     EQU     216

* score values 
SCORE       EQU     220
SCORE_ADDED_BOOL    EQU     224

QUIT_APP_BOOL       EQU     228

STACK_POINTER_OFFSET    EQU     168      ** how much offset to add to the stack pointer for passing in paramaters onto the stack
REGISTERS_OFFSET        EQU     64      ** register offset while in main
REGISTERS_OFFSET_2      EQU     60      ** register offset for putPlayerSpriteInRegisters and putPlayerCropLocationInRegisters, because it includes the PC
** moving object variables 
OBJECT_VELOCITY     EQU     35
FRAMES_SKIP_TO_DRAW     EQU    9
DRAW_PARAMETERS     EQU     6


**Colors 
OBSTICLE_BACKGROUND_COLOR   EQU     $00000000
** moving objects color 
WHITE			equ	$00FFFFFF
TITLE_FONT_COLOR    equ $FFA500FF


** paramaters
*d0 - top left corner of bitmap to be displayed (x)
*d1 - top right corner of bitmap to be displayed (y)
*d2 - width of chunk 
*d3 - height of chunk
*d4 - top left corner of the display screen (x)
*d5 - top left corner of the display screen (y)
*d6 - player sprite counter 
*d7 - frames since an object has been spawned 
** memory registers 
*a0 - pointer to the start of the .bmp file of player sprites 
*a1 - pointer to the start of the .bmp file of the background 
*a2 - 
*a3 - 
*a4 - pointer to an array of obsticleLocations on the stack 
*a5 - pointer to the start of the .bmp file of the obsticles 
*a6 - pointer to an array of crop locations for the 4 obsticle sprites in the obsticles sprite sheet
START    ORG    $1000

 
    * loads tables and bitmaps into memory as listed above 
    lea     bitmap32, a1                                          
    lea     obsticleLocation, a4
    lea     obsticles, a5
    lea     obsticleSprites, a6 
    *set double buffered mode                   
    move.b	#DRAWING_MODE_TRAP_CODE,d0          
    move.b	#DOUBLE_BUFFERED_MODE,d1
    trap	#15    
    clr.l   d0
    clr.l   d1
    
    move.b  #60,d0          ; set mouse IRQ
    move.w  #$0101,d1       ; IRQ1 for mouse down
    trap    #15
    
    move.l  #STACK_POINTER_OFFSET, d6         ; make room for the objects position on the stack 
    sub.l   d6, sp
    
    ** set window size 
    move.b  #SET_OUTPUT_RESOLUTION_TRAP_CODE, d0    
    move.l  #DISPLAY_WINDOW_WIDTH,d1 
    swap.w  d1 
    move.w  #DISPLAY_WINDOW_HEIGHT,d1
    trap    #15 
    
loadingScreen: 
    ** paramaters for loading in the loading screen 
    move.l  #1, d0
    move.l  #1, d1
    move.l  #267, d2
    move.l  #110, d3
    move.l  #207, d4
    move.l  #185, d5
    lea     loading, a0 
    jsr     drawBackground 
    jsr     swapBuffers 
    
    move.l  #0, (QUIT_APP_BOOL - REGISTERS_OFFSET)(sp)
loadstartScreen:    
    ** paramaters for loading the start screen  
    move.l  #0, d0
    move.l  #0, d1
    move.l  #DISPLAY_WINDOW_WIDTH, d2
    move.l  #DISPLAY_WINDOW_HEIGHT, d3
    move.l  #0, d4
    move.l  #0, d5
    lea     startScreen, a0 
    jsr     drawBackground 
    jsr     swapBuffers 
loadGame: 
    **intitial paramaters for drawing the background 
    move.l  #0, d0
    move.l  #45, d1
    move.l  #DISPLAY_WINDOW_WIDTH, d2
    move.l  #435, d3
    move.l  #0, d4
    move.l  #45, d5
    lea     background, a0  
    jsr     drawBackground 
    jsr     getMouseInput           ** doesnt swap buffers until the user left clicks anywhere on the screen 
    
    move.l  (QUIT_APP_BOOL - REGISTERS_OFFSET)(sp), d0 
    cmpi.l  #1, d0 
    beq     stop
startGame: 
    jsr     swapBuffers
    
    * initialize variables on the stack 
    move.l  #JUMP_VELOCITY, (CUR_PLAYER_VELOCITY - REGISTERS_OFFSET)(sp)
    move.l  #JUMP_VELOCITY, (CUR_PLAYER_CHANGE_IN_VELOCITY - REGISTERS_OFFSET)(sp)
    move.l  #0, (SCORE - REGISTERS_OFFSET)(sp)
    move.l  #1, (SCORE_ADDED_BOOL - REGISTERS_OFFSET)(sp) 
    
    
    ** move the stack pointers into memory to be accessed later
    move.l  a5, (OBSTICLES_SPRITE_SHEET_POINTER - REGISTERS_OFFSET)(sp)
    move.l  a1, (PLAYER_SPRITE_SHEET_POINTER - REGISTERS_OFFSET)(sp)
    move.l  a0, (BACKGROUND_SPRITE_SHEET_POINTER - REGISTERS_OFFSET)(sp)
    
    
    ** initializing paramaters for the player sprite running animation 
    move.l  #0,(PLAYER_SPRITE_X_CROP - REGISTERS_OFFSET)(sp)                            
    move.l  #105,(PLAYER_SPRITE_Y_CROP - REGISTERS_OFFSET)(sp)
    move.l  #69,(PLAYER_SPRITE_WIDTH - REGISTERS_OFFSET)(sp)
    move.l  #70,(PLAYER_SPRITE_HEIGHT - REGISTERS_OFFSET)(sp)
    move.l  #200,(PLAYER_SPRITE_X_DISPLAY - REGISTERS_OFFSET)(sp)
    move.l  #410,(PLAYER_SPRITE_Y_DISPLAY - REGISTERS_OFFSET)(sp)
    
   
    
    move.l  #0, d6                            ** initializes the player sprite counter 
    move.l  #FRAMES_SKIP_TO_DRAW, d7          ** initialize the counter for how many frames it has been since an object has been spawned 
    

** game loop: calls all functions needed in one game cycle, keeps running until the player loses or wins 
** the player loses by coliding with an object, and wins by reaching a score of 99.
gameLoop:
    
    ** checks if the player is jumping, if he is then dont get keyboard input, if he isnt then get keyboard input 
    move.l  (IS_JUMPING - REGISTERS_OFFSET)(sp), d0
    cmpi.l  #1, d0 
    beq     ignoreKeyboardInput
    jsr     getKeyboardInput
ignoreKeyboardInput:
   
    jsr     putPlayerSpriteInRegisters
    jsr     updatePlayerSprite
    
    jsr     putPlayerCropLocationInRegisters   
    jsr     drawBackground 
    
    jsr     putPlayerSpriteInRegisters
    jsr     drawPlayerSprite
    
    jsr     getRandomValue
    jsr     getObsticleSprite
    jsr     updateObsticle

    ** if no object exists skip past drawing the obsticle 
    move.l  (OBJECT_1_X_CROP - REGISTERS_OFFSET)(sp),d0 
    cmpi.l  #$FFFFFFFF, d0 
    beq     continue
    jsr     putObsticle1LocationInRegisters
    jsr     drawBackground
    ** check if the object needs to be destroyed 
    move.l  (DESTROY_OBJECT_BOOL - REGISTERS_OFFSET)(sp), d0
    cmpi.l  #1, d0
    bne     drawObsticle1       ** if bool is not set, dont destroy, if it is destroy 
    jsr     destroyObsticle
    beq     continue
drawObsticle1:
    jsr     putObsticle1InRegisters
    jsr     drawObsticleSprite
 
    
continue: 
    jsr     addScore
    
    jsr     clearSevenSegment
    jsr     sevenSegment
    
    jsr     swapBuffers
    jsr     checkCollisions
    
    addi.l  #1, d7                          ** increment the frame since last drawn new object counter 
    move.l  (SCORE - REGISTERS_OFFSET)(sp), d0 
    cmpi.l  #99, d0 
    bne     gameLoop                        ** stay in game loop until he dies (in collision script) or until score reaches 99 
    
endGame:
    jsr     destroyObsticle
    move.b  #CLEAR_SCREEN_COMMAND,d0
    move.l  #CLEAR_SCREEN_MAGIC_VAL,d1
    trap    #15  
    move.b  #REPAINT_SCREEN_TRAP_CODE, d0 
    trap    #15 
   
    ** paramaters for loading in the loading screen 
    move.l  #1, d0
    move.l  #1, d1
    move.l  #267, d2
    move.l  #110, d3
    move.l  #207, d4
    move.l  #185, d5
    lea     loading, a0 
    jsr     drawBackground 
    jsr     swapBuffers 
    
    ** paramaters for either the win screen or the lose screen 
    move.l  #0, d0
    move.l  #0, d1
    move.l  #DISPLAY_WINDOW_WIDTH, d2
    move.l  #DISPLAY_WINDOW_HEIGHT, d3
    move.l  #0, d4
    move.l  #0, d5
    
    *checks the score, if they have a score of 99 they win, else they lose. Then loads appropriate screen 
    move.l  (SCORE - REGISTERS_OFFSET)(sp), d6 
    cmpi.l  #99, d6 
    beq     loadWin
    
loadLose:
    lea     loseScreen, a0 
    bra     drawEndScreen  
loadWin:
    lea     winScreen, a0 
     
drawEndScreen
    jsr     drawBackground 
    jsr     swapBuffers 
    bra     loadGame

    
** swaps the buffers 
swapBuffers
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 

	move.b  #REPAINT_SCREEN_TRAP_CODE,d0
    TRAP    #15
    
    movem.l (sp)+, ALL_REG
	rts  
     


    

stop: 
    move.b  $9,d0            *halts similation
    trap #15
        
    STOP #$2000
           

    SIMHALT             
* bitmap files 
background  INCBIN      "Background.png (1).bmp"
bitmap32    INCBIN      "testCharacter32.bmp"
obsticles   INCBIN      "Obsticles.bmp"

loading     INCBIN      "Loading.bmp"
loseScreen  INCBIN      "LoseState.bmp"
winScreen   INCBIN      "WinState.bmp"
startScreen INCBIN      "StartScreen.bmp"

* location of the obsticles 
obsticleLocation    dc.l    OBJECT_1_X_CROP, OBJECT_1_Y_CROP, OBJECT_1_WIDTH, OBJECT_1_HEIGHT, OBJECT_1_X_DISPLAY, OBJECT_1_Y_DISPLAY
                    dc.l    OBJECT_2_X_CROP, OBJECT_2_Y_CROP, OBJECT_2_WIDTH, OBJECT_2_HEIGHT, OBJECT_2_X_DISPLAY, OBJECT_2_Y_DISPLAY
                    dc.l    OBJECT_3_X_CROP, OBJECT_3_Y_CROP, OBJECT_3_WIDTH, OBJECT_3_HEIGHT, OBJECT_3_X_DISPLAY, OBJECT_3_Y_DISPLAY

** crop and draw locations for each of the 4 obsticle sprites 
obsticleSprites     dc.l    0, 1, 41, 42, 599, 440
                    dc.l    42, 1, 35, 57, 605, 424
                    dc.l    82, 1, 63, 63, 577, 418
                    dc.l    0, 79, 43, 60, 597, 421
                    
                           ;0ABCDEFG        ;NUMBER
bitmaskTable        dc.b    %01111110        ;0
                    dc.b    %00110000        ;1
                    dc.b    %01101101        ;2
                    dc.b    %01111001        ;3
                    dc.b    %00110011        ;4
                    dc.b    %01011011        ;5
                    dc.b    %01011111        ;6
                    dc.b    %01110000        ;7
                    dc.b    %01111111        ;8
                    dc.b    %01110011        ;9
                    
; length of 10               x1, y1;  x2, y2     ;LETTER
drawLocations1s     dc.w    620, 30, 630, 30    ;G 
                    dc.w    620, 30, 620, 20    ;F 
                    dc.w    620, 40, 620, 30    ;E 
                    dc.w    630, 40, 620, 40    ;D
                    dc.w    630, 30, 630, 40    ;C
                    dc.w    630, 20, 630, 30    ;B
                    dc.w    620, 20, 630, 20    ;A
                                                                 
; length of 10               x1, y1;  x2, y2     ;LETTER
drawLocations10s    dc.w    600, 30, 610, 30    ;G 
                    dc.w    600, 30, 600, 20    ;F 
                    dc.w    600, 40, 600, 30    ;E
                    dc.w    610, 40, 600, 40    ;D 
                    dc.w    610, 30, 610, 40    ;C
                    dc.w    610, 20, 610, 30    ;B
                    dc.w    600, 20, 610, 20    ;A
   
                             ;left x, upper y, right x, lower y                  
sevenSegmentLocation    dc.w    598, 18, 632, 42  

GameTitle           dc.b    'FOX JUMPER',CR,LF,0    
gameStartCommand    dc.l    'Click anywhere on the screen to start...',CR,LF,0
howToPlay           dc.l    'Press space to jump',CR,LF,0
                   
** all includes 
include15   INCLUDE     "clearSevenSegment.X68"
include14   INCLUDE     "sevenSegment.X68"                   
include13   INCLUDE     "AddScore.X68"
include12   INCLUDE     "Collision.X68"
include11   INCLUDE     "Destroy.X68"
include10   INCLUDE     "DrawObsticles.X68"
include7    INCLUDE     "PutInRegisters.X68"  
include9    INCLUDE     "UpdateObsticle.X68"
include8    INCLUDE     "GetObsticle.X68"                 
include1    INCLUDE     "KeyboardInput.X68"
include2    INCLUDE     "UpdatePlayer.X68"
include3    INCLUDE     "DrawBackground.X68"
;include4    INCLUDE     "RedrawBackground.X68"
include5    INCLUDE     "DrawPlayer.X68"
include6    INCLUDE     "Random.X68"





    END    START        ; last line of source


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
