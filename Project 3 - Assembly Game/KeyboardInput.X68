*-----------------------------------------------------------
* Title      :KeyboardInput
* Written by :
* Date       :
* Description:Gets user input from the keyboard, and returns a keycode 
*-----------------------------------------------------------
getKeyboardInput:
    movem.l ALL_REG, -(sp)                      ** load the paramaters onto the stack 

    **checks if the user presses 'SPACE' 
    move.l  #KEY_SPACE_INPUT, d1 
    move.b  #USER_INPUT_TRAP_CODE, d0 
    trap    #15
    move.l  d1,KEYCODE_VALUE(sp) 
    
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 
    
getMouseInput: 
    movem.l ALL_REG, -(sp)
    
mouseInputLoop:
    **chekcs to see if "ESC" is pressed on the keyboard 
    **if it is set a bool to quit application 
    move.l  #KEY_ESCAPE_INPUT, d1
    move.b  #USER_INPUT_TRAP_CODE, d0 
    trap    #15
    andi.l  #$FF,d1
    bne     setQuitAppBool 
    
    **checks to see if the left mouse button is pressed down 
    ** if it is load the level, else keep looping 
    move.b  #0, d1 
    move.b  #MOUSE_STATE_TRAP_CODE, d0 
    trap    #15
    cmpi.b  #1, d0 
    bne     mouseInputLoop
returnGetMouseInput:
    movem.l (sp)+, ALL_REG
    rts                                        ** return, and reset the stack 
    
setQuitAppBool:
    move.l  #1, (QUIT_APP_BOOL)(sp)             
    bra     returnGetMouseInput
  
    


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
