TITLE Program Template     (template.asm)

; Author: Derek Greene
; Last Modified:
; OSU email address: greenede@oregonstate.edu
; Course number/section:   CS271 Section [400]
; Project Number:                 Due Date:
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data
; General purpose variables

upperLevel    SDWORD     18
lowerLevel    SDWORD     3
; Strings
yes           BYTE      "Yes",0
no            BYTE      "No",0
maybe         BYTE      "Maybe",0

.code
main PROC
mov EAX, 064h
mov EAX, 052h

; (insert executable instructions here)

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
