TITLE Basic Logic and Arithmetic Program     (Project1.asm)

; Author: Derek Greene
; Last Modified: 4/9/2024
; OSU email address: greenede@oregonstate.edu
; Course number/section:   CS271 Section [400]
; Project Number: 1                 Due Date: 4/21/2024
; Description: Program displays title, developer name, and instructions for the user. Program prompts user to input 3 
;              integers in descending order. The sums and differences (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C) are then
;              calculated and displayed to the user along with a goodbye message.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

programTitle    BYTE  "Basic Logic and Arithmetic Program    by Derek Greene",0
instructions    BYTE  "Please enter 3 numbers in descending order. I will calculate the sums and differences.",0
firstNumString  BYTE  "First number: ",0
secondNumString BYTE  "Second number: ",0
thirdNumString  BYTE  "Third number: ",0
plusSymbol      BYTE  " + ",0
minusSymbol     BYTE  " - ",0
equalSymbol     BYTE  " = ",0
num1            DWORD ?
num2            DWORD ?
num3            DWORD ?
result1         DWORD ?
result2         DWORD ?
result3         DWORD ?
result4         DWORD ?
result5         DWORD ?
result6         DWORD ?
result7         DWORD ?
goodbye         BYTE  "Thank you for using Basic Logic and Arithmetic! Goodbye!",0

.code
main PROC

; introduction
    mov     EDX, OFFSET programTitle
    call    WriteString
    call    CrLf
    call    CrLf
    mov     EDX, OFFSET instructions
    call    WriteString
    call    CrLf
    call    CrLf
    
; input data
    mov     EDX, OFFSET firstNumString
    call    WriteString
    call    ReadDec
    mov     num1, EAX
    mov     EDX, OFFSET secondNumString
    call    WriteString
    call    ReadDec
    mov     num2, EAX
    mov     EDX, OFFSET thirdNumString
    call    WriteString
    call    ReadDec
    mov     num3, EAX

; cacluate results
    mov     EAX, num1
    mov     EBX, num2
    ADD     EAX, EBX
    mov     result1, EAX
    mov     EAX, num1
    SUB     EAX, num2
    mov     result2, EAX
    mov     EAX, num1
    mov     EBX, num3
    ADD     EAX, EBX
    mov     result3, EAX
    mov     EAX, num1
    SUB     EAX, num3
    mov     result4, EAX
    mov     EAX, num2
    mov     EBX, num3
    ADD     EAX, EBX
    mov     result5, EAX
    mov     EAX, num2
    SUB     EAX, num3
    mov     result6, EAX
    mov     EAX, num1
    ADD     EAX, num2
    ADD     EAX, num3
    mov     result7, EAX

; output results
    call    CrLf
    mov     EAX, num1
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteChar
    mov     EAX, num2
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result1
    call    WriteDec
    call    CrLf
    mov     EAX, num1
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteChar
    mov     EAX, num2
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result2
    call    WriteDec
    call    CrLf
    mov     EAX, num1
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteChar
    mov     EAX, num3
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result3
    call    WriteDec
    call    CrLf
    mov     EAX, num1
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteChar
    mov     EAX, num3
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result4
    call    WriteDec
    call    CrLf
    mov     EAX, num2
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteChar
    mov     EAX, num3
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result5
    call    WriteDec
    call    CrLf
    mov     EAX, num2
    call    WriteDec
    mov     EDX, OFFSET minusSymbol
    call    WriteChar
    mov     EAX, num3
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result6
    call    WriteDec
    call    CrLf
    mov     EAX, num1
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteChar
    mov     EAX, num2
    call    WriteDec
    mov     EDX, OFFSET plusSymbol
    call    WriteChar
    mov     EAX, num3
    call    WriteDec
    mov     EDX, OFFSET equalSymbol
    call    WriteChar
    mov     EAX, result7
    call    WriteDec
    call    CrLf

; output goodbye message
    mov     EDX, OFFSET goodbye
    call    CrLf
    call    WriteString


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
