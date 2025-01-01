.MODEL SMALL
.STACK 100H

.DATA
welcome_msg DB 10, 13, 'Welcome!$'
name_prompt DB 10, 13, 'What''s your name?$'
account_msg DB 10, 13, 'Do you have an account? Press 1 for Yes or 2 for No. Enter your choice: $'
enter_password DB 10, 13, 'Enter your password: $'
new_password DB 10, 13, 'Enter a new password: $'
invalid_msg DB 10, 13, 'Invalid. No account found. Exiting...$'
success_msg DB 10, 13, 'Account created successfully! You can now log in.$'
invalid_choice_msg DB 10, 13, 'Invalid choice. Please try again.$'
login_failed_msg DB 10, 13, 'Incorrect password. Please try again.$'
welcome_trivia_msg DB 10, 13, 'Welcome to Seham-Samira Trivia Game!$'

default_password DB 10, 13, '1234', 0

name_buffer DB 20, 0, 20 DUP(0)
password_buffer DB 20, 0, 20 DUP(0)
stored_password DB 20, 0, 20 DUP(0)

MSG1 DB '*************************************************$'
MSG2 DB 10, 13, 10, 13, 'Basic Mathematics Quiz$'
MSG3 DB 10, 13, 'Press Enter to start the quiz : $'
MSG4 DB 10, 13, 'Enter your answer : $'
MSG5 DB 10, 13, 'Correct.$'
MSG6 DB 10, 13, 'Wrong.$'
MSG7 DB 10, 13, 'You have successfully completed the quiz.$'
MSG8 DB 10, 13, 'You scored : $'
MSG9 DB 10, 13, 'Excellent, You completed the quiz with a perfect score.$'
MSG10 DB 10, 13, '   ***Thank you for participating in the quiz.! ***$'

questions DB 10, 13, 'Question 1: 5 + 3 = ? (a) 8 (b) 7 (c) 6$'
question2 DB 10, 13, 'Question 2: 4 * 2 = ? (a) 6 (b) 8 (c) 9$'
question3 DB 10, 13, 'Question 3: 6 - 4 = ? (a) 2 (b) 1 (c) 0$'
question4 DB 10, 13, 'Question 4: 9 / 3 = ? (a) 4 (b) 2 (c) 3$'
question5 DB 10, 13, 'Question 5: 7 + 2 = ? (a) 8 (b) 9 (c) 10$'

CRCTOPT1 DB 'a'
CRCTOPT2 DB 'b'
CRCTOPT3 DB 'a'
CRCTOPT4 DB 'c'
CRCTOPT5 DB 'b'

score DB 0

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    CALL FirstProgram
    CALL SecondProgram
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

FirstProgram PROC
    MOV DX, OFFSET welcome_msg
    MOV AH, 09h
    INT 21h

    MOV DX, OFFSET name_prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 0Ah
    LEA DX, name_buffer
    INT 21h

account_options:
    MOV DX, OFFSET account_msg
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    CMP AL, '1'
    JE has_account
    CMP AL, '2'
    JE create_account
    JMP invalid_choice

has_account:
    MOV DX, OFFSET enter_password
    MOV AH, 09h
    INT 21h

    MOV AH, 0Ah
    LEA DX, password_buffer
    INT 21h

    LEA SI, stored_password
    LEA DI, password_buffer + 2

    MOV CX, 20
    CLD
    REPE CMPSB
    JZ login_success

    MOV DX, OFFSET login_failed_msg
    MOV AH, 09h
    INT 21h
    RET

create_account:
    MOV DX, OFFSET new_password
    MOV AH, 09h
    INT 21h

    MOV AH, 0Ah
    LEA DX, password_buffer
    INT 21h

    LEA SI, stored_password
    LEA DI, password_buffer + 2

    MOV CX, 20
    CLD
    REPE MOVSB

    MOV DX, OFFSET success_msg
    MOV AH, 09h
    INT 21h
    JMP account_options

invalid_choice:
    MOV DX, OFFSET invalid_choice_msg
    MOV AH, 09h
    INT 21h
    JMP account_options

login_success:
    MOV DX, OFFSET welcome_trivia_msg
    MOV AH, 09h
    INT 21h
    RET
FirstProgram ENDP

SecondProgram PROC
    LEA DX, MSG1
    MOV AH, 09h
    INT 21h

    LEA DX, MSG2
    MOV AH, 09h
    INT 21h

    LEA DX, MSG3
    MOV AH, 09h
    INT 21h

WAIT_FOR_ENTER:
    MOV AH, 01h
    INT 21h
    CMP AL, 0Dh
    JNE WAIT_FOR_ENTER

    MOV score, 0

    ; Question 1
    LEA DX, questions
    MOV AH, 09h
    INT 21h
    LEA DX, MSG4
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, CRCTOPT1
    JE CORRECT1
    JMP NEXT1

CORRECT1:
    INC score
NEXT1:

    ; Question 2
    LEA DX, question2
    MOV AH, 09h
    INT 21h
    LEA DX, MSG4
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, CRCTOPT2
    JE CORRECT2
    JMP NEXT2

CORRECT2:
    INC score
NEXT2:

    ; Question 3
    LEA DX, question3
    MOV AH, 09h
    INT 21h
    LEA DX, MSG4
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, CRCTOPT3
    JE CORRECT3
    JMP NEXT3

CORRECT3:
    INC score
NEXT3:

    ; Question 4
    LEA DX, question4
    MOV AH, 09h
    INT 21h
    LEA DX, MSG4
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, CRCTOPT4
    JE CORRECT4
    JMP NEXT4

CORRECT4:
    INC score
NEXT4:

    ; Question 5
    LEA DX, question5
    MOV AH, 09h
    INT 21h
    LEA DX, MSG4
    MOV AH, 09h
    INT 21h
    MOV AH, 01h
    INT 21h
    CMP AL, CRCTOPT5
    JE CORRECT5
    JMP NEXT5

CORRECT5:
    INC score
NEXT5:

    ; Display Final Score
    LEA DX, MSG8
    MOV AH, 09h
    INT 21h
    MOV AL, score
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    LEA DX, MSG10
    MOV AH, 09h
    INT 21h

    MOV AH, 4Ch
    INT 21h
SecondProgram ENDP

END MAIN

