TITLE A Prime Number Calculator     (Proj4_greenede.asm)

; Author: Derek Greene
; Last Modified: 5/15/2024
; OSU email address: greenede@oregonstate.edu
; Course number/section:   CS271 Section [400]
; Project Number: 4                Due Date: 5/19/24
; Description: Program displays title and programmers name, followed by instructions for
;              the user. The program then will prompt the user to input a number n of primes to display.
;              Program validates user input in range [1,4000] (inclusive).
;              Program will alert user of any out of range numbers and reprompt the user until input is in range.
;              Program will calculate and display every prime number up to and including the nth prime.
;              Program aligns the output columns and displays 20 rows of primes per page. 
;              Program allows user to press any key to continue. After all primes are shown, a goodbye message is displayed.

INCLUDE Irvine32.inc

; constant definitions for range [1,4000]
LOWER_LIMIT = 1
UPPER_LIMIT = 4000
ROW_SIZE = 10
PRIMES_PER_PAGE = 200           ; 20 rows per page with 10 primes per row          

.data

programTitle        BYTE    "A Prime Number Calculator     by Derek Greene",0
extraCredit1        BYTE    "**EC: Program aligns output columns.",0
extraCredit2        BYTE    "**EC: Program extends range up to 4000 primes displayed 20 rows per page. User can press any key to continue.",0
instruct1           BYTE    "Enter the amount of primes to display.",0
instruct2           BYTE    "Input must be in the range [1,4000]",0
inputMsg            BYTE    "Number of primes to display: ",0
invalidInp          BYTE    "INVALID: number is not in range [1,4000]!",0
await               BYTE    "Press any key to continue...",0
goodbyeMsg          BYTE    "Thanks for using A Prime Number Calculator by Derek Greene, Goodbye!",0
space               BYTE    " ",0
inputNum            DWORD   ?
potPrime            DWORD   ?
boolean             DWORD   ?
tempCounter         DWORD   ?
rowCount            DWORD   1
primeNumsAmt        DWORD   1

.code

; ----------------------------------------------------------
; Name: introduction
;
; Displays program title and instructions.
;
; Postconditions: changes registers EAX, EDX
;
; Receives:
;       programTitle = title of program
;       extraCredit1 = extra credit description
;       extraCredit2 = extra credit description
;       instruct1 = instructions for user input
;       instruct2 = instructions for user input
; -----------------------------------------------------------
introduction PROC
    mov     EDX, OFFSET programTitle
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit2
    call    WriteString
    call    CrLf
    call    CrLf
    mov     EDX, OFFSET instruct1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET instruct2
    call    WriteString
    call    CrLf
    call    CrLf
    ret
introduction ENDP

; ---------------------------------------------------
; Name: getInput
;
; Prompts user to enter amount of primes to display.
;
; Preconditions: input must be an integer
;
; Postconditions: changes registers EAX, EDX
;
; Receives:
;        inputMsg = user input message  
; ----------------------------------------------------
getInput PROC
    mov     EDX, OFFSET inputMsg
    call    WriteString
    call    ReadInt
    mov     inputNum, EAX
    call    validate
getInput ENDP

; ---------------------------------------------------------------------------------
; Name: validate
;
; Validates user input to be in range [1,4000]. If out of range, error is displayed
; and user is prompted to enter a valid number.
;
; Preconditions: input must be an integer
;
; Postconditions: changes registers EAX, EDX
;
; Receives:
;        invalidInp = out of range error message
;
; Returns: input num is within range = TRUE
; ---------------------------------------------------------------------------------
validate PROC
    mov     EAX, LOWER_LIMIT
    cmp     inputNum, EAX
    jl      _error              ; if inputNum < 1, display error
    mov     EAX, UPPER_LIMIT
    cmp     inputNum, EAX
    jg      _error              ; if inputNum > 4000, display error
    ret
_error:
    mov     EDX, OFFSET invalidInp
    call    WriteString
    call    CrLf
    call    CrLf
    call    getInput
    ret
validate ENDP

; ------------------------------------------------------------------------
; Name: displayPrime
;
; Displays prime numbers up to the nth prime number entered by the user.
; Makes calls to checkPrime proc to validate prime nums and alignRow to
; properly pad each prime with the correct amount of whitespace.
;
; Preconditions: inputNum must contain number of primes to display
;
; Postconditions: changes registers EAX, ECX, ESI, EBX
;
; Receives:
;       inputNum = number of primes to display
; -------------------------------------------------------------------------
displayPrime PROC
    mov     ECX, inputNum       ; load loop counter ECX with inputNum
    dec     ECX                 ; EXC loop counter -1 as '2' will be displayed by default so loop is 1 less than inputNum
    mov     ESI, 1
    mov     EAX,2
    call    CrLf
    call    WriteDec            ; print prime num '2' as formula for primes will not print '2'
_numGenLoop:
    mov     tempCounter, ECX    ; tempCounter to restore ECX value for numGenLoop after calling checkPrime
    mov     potPrime, ESI     
    call    checkPrime
    cmp     boolean, 1        
    jne     _skipPrint           ; if not return 1, skip printing
    mov     EBX, ROW_SIZE
    cmp     EBX, primeNumsAmt
    jne      _spaces       ; if primeNumsAmt != ROW_SIZE, need to calculate how many spaces to padd prime with 
    call    CrLf
    jmp     _resetRowCount
_spaces:
    call    alignRow      ; call alignRow procedure to calculate number of spaces to pad prime with for alignment
    jmp    _skipReset
_resetRowCount:
    mov     EBX, 0
    mov     primeNumsAmt, EBX
_skipReset:
    mov     EAX, potPrime       ; else if return 1, print prime
    call    WriteDec
    inc     primeNumsAmt
    inc     rowCount
    mov     EAX, rowCount
    cmp     EAX, PRIMES_PER_PAGE
    jae     _await
    jmp     _skipPrint
_await:
    call    awaitKey
_skipPrint:
    inc     ESI                 ; increment potential prime number
    loop    _numGenLoop         ; loop until all primes found
    call    CrLf
    ret
displayPrime ENDP

; --------------------------------------------------------------------------------------
; Name: checkPrime
;
; Determines whether a number is prime or not.
;
; Preconditions: potPrime must contain the number to check for primality
;
; Postconditions: changes registers EAX, EDX, ECX
;
; Receives:
;       potPrime = number to check for primality
;
; Returns: boolean = 0 if not prime, 1 if prime
; --------------------------------------------------------------------------------------
checkPrime PROC
    mov     ECX, 2
    cmp     potPrime, 1      
    jbe     _notPrime           ; if <= 1, not prime
_primeLoop:
    mov     EAX, potPrime    
    cdq                         ; clear EDX for signed division
    idiv    ECX              
    cmp     EDX, 0           
    je      _notPrime           ; if divisible, not prime
    inc     ECX              
    cmp     ECX, potPrime    
    jae     _prime              ; if not reached inputNum, prime
    jmp     _primeLoop       
_prime:                      
    mov     boolean, 1          ; prime, return 1
    mov     ECX, tempCounter    ; restore ECX from tempCounter value for numGenLoop in displayPrime procedure
    ret
_notPrime:
    mov     boolean, 0          ; not prime, return 0
    add     tempCounter, 1
    mov     ECX, tempCounter    ; restore EXC as EXC+1 since not prime
    ret
checkPrime ENDP

; --------------------------------------------------------------------------------------
; Name: alignRow
;
; Aligns the output columns based on the magnitude of each prime number.
; The number of spaces added before displaying each prime number depends
; on its magnitude to ensure proper alignment in the output.
;
; Preconditions: potPrime must contain the value of the current prime number
;
; Postconditions: the output columns are aligned according to the magnitude of prime number
;
; Receives: potPrime = value of the current prime number
; --------------------------------------------------------------------------------------
alignRow PROC
    mov     EAX, potPrime
    cmp     EAX, 10007          ; prime nums 10008+... (up to 4000 primes) need 3 spaces
    ja      _3spaces
    cmp     EAX, 1013           ; prime nums 1013 - 10007 need 5 spaces
    jb      _5spaces
    mov     ECX, 4
 _spacesLoop:                   ;loop to print num of spaces based on ECX value
    mov     EDX, OFFSET space
    call    WriteString
    loop    _spacesLoop
    mov     ECX, tempCounter    ; restore ECX from tempCounter value before returning to numGenLoop
    ret                         ; return to numGenLoop
 _3spaces:
    mov     ECX, 3              
    jmp     _spacesLoop
_5spaces:
    cmp     EAX, 101            ; 1013 > prime nums >= 101 need 5 spaces
    jbe     _6spaces
    mov     ECX, 5
    jmp     _spacesLoop
_6spaces:
    cmp     EAX, 11             ; 101 > prime nums >= 11 need 6 spaces
    jbe     _7spaces
    mov     ECX, 6      
    jmp     _spacesLoop
_7spaces:
    mov     ECX, 7              ; prime nums < 11 need 7 spaces
    jmp    _spacesLoop
alignRow ENDP

; --------------------------------------------------------------------------------------------
; Name: awaitKey
;
; Waits for user to press any key and prompts the user with a message.
; After the user presses a key, row count resets and next page of primes is displayed.
;
; Postconditions: screen cleared, row count is reset to 0, user is prompted
;                 to press any key to continue, changes registers EDX
; ---------------------------------------------------------------------------------------------
awaitKey PROC
    call    CrLf
    call    CrLf
    mov     rowCount, 0      ; reset rowCount to 0
    mov     EDX, OFFSET await
    call    WriteString
    call    ReadChar
    call    CrLf
    ret     
awaitKey ENDP

; ----------------------------------------------------------
; Name: goodbye
;
; Displays a goodbye message and exits the program.
;
; Postconditions: changes registers EDX, exits the program
;
; Receives:
;       goodbyeMsg = goodbye message
; -----------------------------------------------------------
goodbye PROC
    mov     EDX, OFFSET goodbyeMsg      
    call    CrLf
    call    WriteString
    call    CrLf
    Invoke ExitProcess,0	; exit to operating system
goodbye ENDP

main PROC
;---------------------------------------------------
; Displays program title and instructions for input.
; Input must be an integer in the range [1,4000].
;---------------------------------------------------
call    introduction

;---------------------------------------------------
; Prompts user to enter number of primes to display.
; User input is stored in inputNum variable.
;---------------------------------------------------
call    getInput

;------------------------------------------------------------------------------------
; Displays prime num '2' and generates nums > 2 <= inputNum.
; Each inputNum is passed to checkPrime procedure which returns 1 if prime and
; 0 if not prime. Only numbers that return 1 are then passed to the alignRow 
; procedure which acalculates the correct amount of whitespace to pad the prime with.
; Upon return from alignRow procedure, displayPrime procedure prints the prime.
;------------------------------------------------------------------------------------
call    displayPrime

;---------------------------------------------------
; Displays goodbye message and invokes exit process
;---------------------------------------------------
call    goodbye

main ENDP

END main
