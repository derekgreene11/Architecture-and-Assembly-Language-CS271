TITLE A More Advanced Arithmetic Program     (Proj3_greenede.asm)

; Author: Derek Greene
; Last Modified: 4/24/2024
; OSU email address: greenede@oregonstate.edu
; Course number/section:   CS271 Section [400]
; Project Number: 3                Due Date: 5/5/24
; Description: Program displays title and programmers name, followed by getting the user name and greeting
;              the user. The program then will prompt the user repeatedly to input a number.
;              Program validates user input in range [-200,-100] OR [-50,-1] (inclusive).
;              Program will alert user of any out of range negative numbers.
;              Program will store the number of valid inputs entered and calculate the valid input values.
;              Program will number each line of user input and increment the line number for valid input only.
;              Program will then calculate the rounded integer average of the valid inputs and store in a variable.
;              Program will display the number of valid inputs, the sum, max, min, rounded average, decimal-point-number, and a goodbye message.

INCLUDE Irvine32.inc

; constant definitions for range [-200,-100] & [-50,-1]
LOWER_LIMIT_1 = -200
LOWER_LIMIT_2 = -50
UPPER_LIMIT_1 = -100
UPPER_LIMIT_2 = -1

.data

programTitle        BYTE    "A More Advanced Arithmetic Program     by Derek Greene",0
extraCredit1        BYTE    "**EC: Program numbers each line of input, incrementing the line number for each valid input.",0
extraCredit2        BYTE    "**EC: Program calculates the average as a decimal-point-number, rounded to nearest 0.01.",0
instruct1           BYTE    "This program allows for the input of negative numbers within the specified range.",0
instruct2           BYTE    "The min, max, average, sum, number of inputs, & decimal-number are then calculated and displayed.",0
getUserName         BYTE    "Please enter your name: ",0
greetUser           BYTE    "Hello, ",0
explPnt             BYTE    "! ",0
colon               BYTE    ": ",0
decimal             BYTE    ".",0
userInputMsg1       BYTE    "Please enter integers in the range [-200,-100] or [-50,-1]",0
userInputMsg2       BYTE    "When you're done, enter a non-negative number to calculate results.",0
userInput           BYTE    "Input ",0
invalidNeg          BYTE    "INVALID: number is not in range [-200,-100] or [-50,-1].",0
noValidNums         BYTE    "ERROR: no valid integers entered!",0
resultMsg1          BYTE    "You entered ",0
resultMsg2          BYTE    " valid numbers",0
resultSum           BYTE    "Sum: ",0
resultMax           BYTE    "Maximum: ",0
resultMin           BYTE    "Minimum: ",0
resultAvg           BYTE    "Rounded Average: ",0
resultDec           BYTE    "Decimal-Number: ",0
goodbyeMsg          BYTE    "Thanks for using A more Advanced Arithemetic Program! Goodbye, ",0
userNameBytes       DWORD   ?         ; holds number of characters in username
userName            BYTE    20 DUP(0) 
inputNum            SDWORD  ?
max                 SDWORD  -200      
min                 SDWORD  ?
sum                 SDWORD  ?
avg                 SDWORD  ?
count               DWORD   0
rmd                 DWORD   ?
intPart             DWORD   ?
oneHundred          DWORD   ?

.code
main PROC

; ----------------------------------------------------------
; Displays program title, instructions, and username prompt.
; Username input is stored in userName.  
; Displays hello message with username
; -----------------------------------------------------------
    mov     EDX, OFFSET programTitle
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit2
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET instruct1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET instruct2
    call    WriteString
    call    CrLf
    call    CrLf
    mov     EDX, OFFSET getUserName
    call    WriteString
    mov     EDX, OFFSET userName
    mov     ECX, SIZEOF userName
    call    ReadString
    mov     userNameBytes, EAX
    call    CrLf
    mov     EDX, OFFSET greetUser
    call    WriteString
    mov     EDX, OFFSET userName
    call    WriteString
    mov     EDX, OFFSET explPnt
    call    WriteString
    mov     EDX, OFFSET userInputMsg1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET userInputMsg2
    call    WriteString
    call    CrLf
    call    CrLf

_getInput:
; ---------------------------------------------------------------------------
; Displays current line number and requests user input integer.
; Displays current line number as count + 1 so line number starts at 1 instead of 0.
; ---------------------------------------------------------------------------
    mov     EDX, OFFSET userInput
    call    WriteString
    mov     EAX, count
    add     EAX, 1
    call    WriteDec
    mov     EDX, OFFSET colon
    call    WriteString
    call    ReadInt
    mov     inputNum, EAX

; ----------------------------------------------------------------------------------
; Validate inputs. If input is out or range, out-of-range message will be displayed.
; If input is positive, program will display results, goodbye message, and end.
; If no valid intput, program will display error message, goodbye message, and end.
; ----------------------------------------------------------------------------------

; validate input for negative integers. If positive, jmp to calculate results else exit loop
    mov     EAX, 0              ; set EAX to 0 in order to correctly set the sign flag in next cmp instruction (inputNum - EAX) 
    cmp     inputNum, EAX
    jns      _exitLoop          ; jmp if sign flag = 0 (positive result)

; validate input for lower end of first range n >= -200. If n < -200, jmp to invalidNegMsg
    mov     EAX, inputNum
    cmp     EAX, LOWER_LIMIT_1
    jl      _invalidNegMsg      ; jmp if input < -200 (out of bounds)

; validate input for upper end of first range n <= -100. If n > -100, check if input fits within 2nd range [-50, -1]
    cmp     EAX, UPPER_LIMIT_1
    jg      _continue           ; jmp if input > -100 (out of bounds)
    jmp     _valid              

; validate input for lower end of second range n >= -50. If n < -50, jmp to invalidNegMsg
_continue:
    cmp     EAX, LOWER_LIMIT_2
    jl      _invalidNegMsg      ; jmp if input < -50 (out of bounds)

; validate input for upper end of second range n <= -1. If n > -1, jmp to invalidNegMsg
    cmp     EAX, UPPER_LIMIT_2
    jg      _invalidNegMsg      ; jmp if input > -1 (out of bounds)
    jmp     _valid              ;

; display invalidNegMsg
_invalidNegMsg:
    call    CrlF
    mov     EDX, OFFSET invalidNeg
    call    WriteString
    call    CrlF
    jmp     _getInput           ; return back to input loop after displaying invalidNeg message

; ----------------------------------------------------------------------------------------------------
; Check input to determine if input is new max or new min.
; If input is > min, jmp to _max and checks if input < max. If input < min, input is saved as new min.
; If input > max, input is saved as new max.
; After checking each input, returns back to input loop.
; -----------------------------------------------------------------------------------------------------

; add input to sum, increment count
_valid:
    mov     EAX, inputNum
    add     sum, EAX
    inc     count

; check if input < min, if true, update min
_min:
    mov     EAX, inputNum
    cmp     EAX, min
    jg      _max            ; jmp if input > min
    mov     min, EAX        ; else store as new min

; check if input > max, if true, update max
_max:
    mov     EAX, inputNum
    cmp     EAX, max
    jl      _getInput       ; jmp if input < max
    mov     max, EAX        ; else store as new max
    jmp     _getInput       

; Exit from user input loop. Exits if input is positive integer
_exitLoop:
; check for count = 0, meaning no valid integers entered, if count = 0 jmp to noValidNums msg
    mov     EAX, count
    cmp     EAX, 0
    je     _noValidNums     ; jmp if count = 0

; -----------------------------------------------------------------------------------------------------
; Calculate rounded integer average with equation (((((sum * 100) / count ) + |-49|)) / 100).
; Works by moving decimal place (sum * 100) and then adding -49 then dividing by 100 to move the decimal place back.
; For 0.5 round down & 0.51 round up.
; ------------------------------------------------------------------------------------------------------

; calculate rounded integer average        -       (((((sum * 100) / count ) + |-49|)) / 100)
    imul    EAX, sum, 100
    mov     avg, EAX
    cdq                         ; sign-extend EAX into EDX for signed division
    idiv    count
    mov     avg, EAX
    add     avg, -49
    mov     EAX, avg
    cdq                         ; sign-extend EAX into EDX for signed division
    mov     oneHundred, 100
    idiv    oneHundred
    mov     avg, EAX

; -----------------------------------------------------------------------------------------------------------------------------------------
; In order to display decimal number without floating point units, break up the non decimal part from the decimal part.
; Then round the decimal part to nearest 0.01 and print both numbers seperated by a decimal. To the user, this appears as a decimal number.
; ((Remainder of sum / count) * 1000) / count = decimal part of number.
; To round decimal part (rmd) to nearest 0.01, (((rmd * 10) + |-49|) / 100) * -1) = rounded decimal part.
; Decimal part (rmd) * -1 to get rid of "-" sign.
; ------------------------------------------------------------------------------------------------------------------------------------------

; calculate remainder of sum / count in order to get decimal part of number to display     -      intPart = sum / count  &   (rmd * 1000) / count = decimal-number decimal portion
    mov     EAX, sum
    cdq                         ; sign-extend EAX into EDX for signed division
    idiv    count
    mov     rmd, EDX
    mov     intPart, EAX                 ; store to display later as initial part of decimal number
    imul    EAX, rmd, 1000
    mov     rmd, EAX
    cdq                         ; sign-extend EAX into EDX for signed division
    idiv    count
    mov     rmd, EAX

; round decimal part (rmd) to the nearest 0.01
; (((rmd * 10) + |-49|) / 100) * -1) = rounded decimal part
    imul    EAX, rmd, 10
    mov     rmd, EAX
    add     rmd, -49                    ; + |-49| will round 0.05 down to keep the same rounding format as used with the rounded integer number. If want 0.05 to round up, change to + |-50|
    mov     EAX, rmd
    cdq                                 ; sign-extend EAX into EDX for signed division
    idiv    oneHundred
    mov     rmd, EAX
    imul    EAX, rmd, -1                ; multiply by -1 to get rid of '-' symbol 
    mov     rmd, EAX

; --------------------------------------------------------------
; Display results max, min, avg, sum, count, and decimal-number.
; --------------------------------------------------------------

; display count of valid inputs 
    call    CrLf
    mov     EDX, OFFSET resultMsg1
    call    WriteString
    mov     EAX, count
    call    WriteDec
    mov     EDX, OFFSET resultMsg2
    call    WriteString
    call    CrLf
; display sum of valid inputs
    mov     EDX, OFFSET resultSum
    call    WriteString
    mov     EAX, sum
    call    WriteInt
    call    CrLf
; display max of valid inputs
    mov     EDX, OFFSET resultMax
    call    WriteString
    mov     EAX, max
    call    WriteInt
    call    CrLf
; display min of valid inputs
    mov     EDX, OFFSET resultMin
    call    WriteString
    mov     EAX, min
    call    WriteInt
    call    CrLf
; display avg of valid inputs
    mov     EDX, OFFSET resultAvg
    call    WriteString
    mov     EAX, avg
    call    WriteInt
    call    CrLf
; display average in a decimal-point-number 
    mov     EDX, OFFSET resultDec
    call    WriteString
    mov     EAX, intPart
    call    WriteInt
    mov     EDX, OFFSET decimal
    call    WriteString
    mov     EAX, rmd
    call    WriteDec
    call    CrLf
    jmp     _goodbyeMsg                     ; jmp to goobye message to skip displaying the noValidNums message

; ---------------------------------------------------------
; Display message if no valid numbers entered to calculate.
; ---------------------------------------------------------
_noValidNums:
    call    Crlf
    mov     EDX, OFFSET noValidNums
    call    WriteString
    call    Crlf

; --------------------------------------------
; Display goodbye msg and prints the username.
; --------------------------------------------
_goodbyeMsg:
    call    CrLf
    mov     EDX, OFFSET goodbyeMsg
    call    WriteString
    mov     EDX, OFFSET userName
    call    WriteString
    mov     EDX, OFFSET explPnt
    call    WriteString
    call    CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main
