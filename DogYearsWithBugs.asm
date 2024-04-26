TITLE Dog Years Calculator     (DogYearsWithBugs.asm)

; Author: Wile E. Coyote
; Last Modified: Now!
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number: Project 00     Due Date: Never
; Description: This program will introduce the programmer, get the user's name and age,
;        calculate the user's age in "dog years", and report the result.

INCLUDE Irvine32.inc

DOG_FACTOR = 7

.data

userAge		DWORD	?				; Integer to be entered by the user
intro_1		BYTE	"Hi, my name is Lassie, and I'm here to tell you your age in dog years!", 0
prompt_1	BYTE	"What's your name? ",0
intro_2		BYTE	"Nice to meet you, ",0
prompt_2	BYTE	"What's your age? ",0
dogAge		DWORD	?				; To be calculated...
userName	BYTE	10 DUP(0)	; string to be entered by user
result_1	BYTE	"Wow, that's ",0
result_2	BYTE	" in dog years!",0
goodbye		BYTE	"So long and farewell, ",0

.code
main PROC

; Introduce programmer
  mov    EDX, OFFSET intro_1
  call   WriteString
  call   CrLf


; Get user's name
  mov    EDX, OFFSET prompt_1
  call   WriteString
  ; Preconditions of Readstring: (1) Max length saved in ECX, EDX holds pointer to string
  mov    EDX, OFFSET userName
  mov    ECX, 14
  call   Readstring

; Get user's age
  mov    EDX, OFFSET prompt_2
  call   WriteString
  ; Preconditions of ReadDec: None
  call   ReadDec
  ; Postconditions of ReadDec: value is saved in EAX
  mov    userAge, EAX


; Calculate age in dog years
  mov    EAX, userAge
  mov    EBX, DOG_Factor
  mul    EBX
  mov    dogAge, edx

; Report the result
  mov    EDX, OFFSET result_1
  call   WriteString
  mov    EAX, dogAge
  call   WriteDec
  mov    EDX, OFFSET result_2
  call   WriteString
  call   CrLf

; Say goodbye

  mov    EDX, OFFSET goodbye
  call   WriteString
  mov    EDX, OFFSET userName
  call   WriteString
  call   CrLf


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
