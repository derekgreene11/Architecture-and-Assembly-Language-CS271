TITLE Basic Logic and Arithmetic Program     (Project1.asm)

; Author: Derek Greene
; Last Modified: 4/16/2024
; OSU email address: greenede@oregonstate.edu
; Course number/section:   CS271 Section [400]
; Project Number: 1                 Due Date: 4/21/2024
; Description: Program displays title, developer name, and instructions for the user. Program prompts user to input 3 
;              integers in descending order. The sums and differences (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C, B-A, C-A, C-B, C-B-A) and quotients/remainders (A/B, A/C, B/C) are then
;              calculated and displayed to the user along with a goodbye message. Program validates user input such that A > B > C and repeates until the user quits.

INCLUDE Irvine32.inc

.data

programTitle    BYTE  "Basic Logic and Arithmetic Program    by Derek Greene",0
extraCredit1    BYTE  "EC: Program repeats until user chooses to quit.",0
extraCredit2    BYTE  "EC: Program ensures numbers are in strictly descending order A > B > C.",0
extraCredit3    BYTE  "EC: Program calculates and displays negative results B-A, C-A, C-B, C-B-A.",0
extraCredit4    BYTE  "EC: Program calculates and displays quotients and remainders A/B, A/C, B/C.",0
instructions    BYTE  "Please enter 3 numbers in descending order.",0
notInOrder      BYTE  "Numbers must be in descending order! Please re-enter numbers.",0
firstNumString  BYTE  "First number: ",0
secondNumString BYTE  "Second number: ",0
thirdNumString  BYTE  "Third number: ",0
plusSymbol      BYTE  " + ",0
minusSymbol     BYTE  " - ",0
equalSymbol     BYTE  " = ",0
divisionSymbol  BYTE  " / ",0
remainder       BYTE "   Remainder: ",0
numA            DWORD ?
numB            DWORD ?
numC            DWORD ?
aPlusB          DWORD ?
aMinusB         DWORD ?
aPlusC          DWORD ?
aMinusC         DWORD ?
bPlusC          DWORD ?
bMinusC         DWORD ?
aPlusBplusC     DWORD ?
bMinusA         DWORD ?
cMinusA         DWORD ?
cMinusB         DWORD ?
cMinusBminusA   DWORD ?
aDivB           DWORD ?
aDivBremainder  DWORD ?
aDivC           DWORD ?
aDivCremainder  DWORD ?
bDivC           DWORD ?
bDivCremainder  DWORD ?
goodbye         BYTE  "Thank you for using Basic Logic and Arithmetic! Goodbye!",0
repeatPg        BYTE  "Enter 0 to continue or 1 to exit: ",0
repeatAns       DWORD ?     ;variable to store user choice for repeatPg prompt

.code
main PROC

; introduction - display program title, extra credit info and instructions
    mov     EDX, OFFSET programTitle
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit1
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit2
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit3
    call    WriteString
    call    CrLf
    mov     EDX, OFFSET extraCredit4
    call    WriteString
    call    CrLf
    call    CrLf
    mov     EDX, OFFSET instructions
    call    WriteString
    call    CrLf
    call    CrLf

_repeat:    ;label for user to re-enter data if numB || numC > numA (not strictly descending order)

; input data - requests user input numA, numB, numC
    mov     EDX, OFFSET firstNumString
    call    WriteString
    call    ReadDec
    mov     numA, EAX
    mov     EDX, OFFSET secondNumString
    call    WriteString
    call    ReadDec
    mov     numB, EAX
    cmp     EAX, numA       ; check for descending order  
    jge     _notInOrder
    jmp     _skip           ; jmp _skip if numB < A (strictly descending order)

; displays notInOrder message then jmp _repeat to re-enter data
_notInOrder:                
    call    CrLf
    mov     EDX, OFFSET notInOrder
    call    WriteString 
    call    CrLf
    call    CrLf
    jmp     _repeat         ;jmp _repeat for user to re-enter data

_skip:                      ; 
    mov     EDX, OFFSET thirdNumString
    call    WriteString
    call    ReadDec
    mov     numC, EAX
    cmp     EAX, numB       ; check for descending order C < B
    jge     _notInOrder     ; jmp if numB <= numC

; cacluate results
; numA + numB store in aPlusB
    mov     EAX, numA
    mov     EBX, numB
    add     EAX, EBX
    mov     aPlusB, EAX     

; numA - numB store in aMinusB
    mov     EAX, numA
    sub     EAX, numB
    mov     aMinusB, EAX    

; numA + numC store in aPlusC
    mov     EAX, numA
    mov     EBX, numC
    add     EAX, EBX
    mov     aPlusC, EAX     

; numA - numC store in aMinusC
    mov     EAX, numA
    sub     EAX, numC
    mov     aMinusC, EAX    

; numB + numC store in bPlusC
    mov     EAX, numB
    mov     EBX, numC
    add     EAX, EBX
    mov     bPlusC, EAX     

; numB - numC store in bMinusC
    mov     EAX, numB
    sub     EAX, numC
    mov     bMinusC, EAX    

; numA + numB + numC store in aPlusBplusC
    mov     EAX, numA
    add     EAX, numB
    add     EAX, numC
    mov     aPlusBplusC, EAX 

; numB - numA store in bMinusA
    mov     EAX, numB
    sub     EAX, numA
    mov     bMinusA, EAX    

; numC - numA store in cMinusA
    mov     EAX, numC
    sub     EAX, numA
    mov     cMinusA, EAX    

; numC - numB store in cMinusB
    mov     EAX, numC
    sub     EAX, numB
    mov     cMinusB, EAX    

; numC - numB - numA store in cMinusBminusA
    mov     EAX, numC
    sub     EAX, numB
    sub     EAX, numA
    mov     cMinusBminusA, EAX  

; numA / numB store in aDivB & remainder store in aDivBremainder
    mov     EAX, numA
    mov     EDX, 0          ; cleared EDX for division
    mov     EBX, numB
    div     EBX
    mov     aDivB, EAX
    mov     aDivBremainder, EDX

; numA / numC store in aDivC & remainder store in aDivCremainder
    mov     EAX, numA
    mov     EDX, 0          ; cleared EDX for division
    mov     EBX, numC
    div     EBX
    mov     aDivC, EAX
    mov     aDivCremainder, EDX

; numB / numC store in bDivC & remainder store in bDivCremainder
    mov     EAX, numB
    mov     EDX, 0          ; cleared EDX for division
    mov     EBX, numC
    div     EBX
    mov     bDivC, EAX
    mov     bDivCremainder, EDX

; output results
; display numA + numB = aPlusB
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aPlusB
    call    WriteDec

; display numA - numB = aMinusB
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aMinusB
    call    WriteDec

; display numA + numC = aPlusC
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aPlusC
    call    WriteDec

; displays numA - numC = aMinusC
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aMinusC
    call    WriteDec

; displays numB + numC = bPlusC
    call    CrLf
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, bPlusC  
    call    WriteDec

; displays numB - numC = bMinusC
    call    CrLf
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, bMinusC
    call    WriteDec

; displays numA + numB + numC = aPlusBplusC
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aPlusBplusC
    call    WriteDec

; displays numB - numA = bMinusA
    call    CrLf
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, bMinusA
    call    WriteInt

; displays numC - numA = cMinusA
    call    CrLf
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, cMinusA
    call    WriteInt

; displays numC - numB = cMinusB
    call    CrLf
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, cMinusB
    call    WriteInt

; displaus numC - numB - numA = cMinusBminusA
    call    CrLf
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteString
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, cMinusBminusA
    call    WriteInt

; displays numA / numB = aDivB   Remainder: aDivBremainder
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET divisionSymbol
    call    WriteString
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aDivB
    call    WriteDec
    mov     EDX, OFFSET remainder
    call    WriteString
    mov     EAX, aDivBremainder
    call    WriteDec

; displays numA / numC = aDivC   Remainder: aDivCremainder
    call    CrLf
    mov     EAX, numA
    call    WriteDec
    mov     EDX, OFFSET divisionSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, aDivC
    call    WriteDec
    mov     EDX, OFFSET remainder
    call    WriteString
    mov     EAX, aDivCremainder
    call    WriteDec

; displays numB / numC = bDivC   Remainder: bDivCremainder
    call    CrLf
    mov     EAX, numB
    call    WriteDec
    mov     EDX, OFFSET divisionSymbol
    call    WriteString
    mov     EAX, numC
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteString
    mov     EAX, bDivC
    call    WriteDec
    mov     EDX, OFFSET remainder
    call    WriteString
    mov     EAX, bDivCremainder
    call    WriteDec
    call    CrLf

;check if user wants to repeat
    call    CrLf
    mov     EDX, OFFSET repeatPg                ; repeat message
    call    WriteString                 
    call    ReadDec
    call    CrLf
    mov     repeatAns, 0 
    cmp     EAX, repeatAns                      ; if repeatAns == 0 then jmp _repeat  for user to re-enter data else continue sequential execution
    je      _repeat
 
; output goodbye message
    mov     EDX, OFFSET goodbye
    call    CrLf
    call    WriteString

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
