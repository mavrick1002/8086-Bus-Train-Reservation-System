.MODEL SMALL
.STACK 100H

.DATA
    ; ========== USER AUTHENTICATION ARRAYS ==========
    MAX_USERS EQU 10
    total_users DB 4
    
    user_names DB 'admin', 0, 0, 0, 0, 0
               DB 'adi', 0, 0, 0, 0, 0, 0, 0
               DB 'kristina', 0, 0
               DB 'prome', 0, 0, 0, 0, 0
               DB 70 DUP(0)
    
    user_passes DB 'admin123', 0, 0
                DB 'pass1234', 0, 0
                DB 'pass5678', 0, 0
                DB 'pass5791', 0, 0
                DB 70 DUP(0)
    
    login_attempts DB 0
    current_user DB 10 DUP(0)
    is_admin DB 0
    
    ; ========== ROUTE & SCHEDULE ARRAYS ==========
    MAX_ROUTES EQU 10
    total_routes DB 10
    
    route_sources DB 'Dhaka    ','Chittagong','Sylhet   ','Rajshahi '
                  DB 'Khulna   ','Dhaka    ','Barishal ','Rangpur  '
                  DB 'Comilla  ','Mymensngh'
    
    route_dests DB 'Chittagong','Sylhet   ','Rajshahi ','Khulna   '
                DB 'Dhaka    ','Cox Bazar','Dhaka    ','Dhaka    '
                DB 'Sylhet   ','Dhaka    '
    
    route_services DB 'Train','Bus  ','Train','Bus  ','Train'
                   DB 'Bus  ','Train','Bus  ','Train','Bus  '
    
    route_types DB 'AC   ','AC   ','N-AC ','N-AC ','AC   '
                DB 'AC   ','N-AC ','N-AC ','AC   ','AC   '
    
    route_fares DW 600, 450, 400, 280, 650, 800, 350, 320, 500, 550
    route_available_seats DB 40, 35, 38, 30, 42, 25, 36, 28, 32, 40
    
    ; ========== BOOKING STORAGE ==========
    booking_pnr DW 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    booking_user DB 100 DUP(0)
    booking_route DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    booking_seats DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    booking_seat_nums DB 50 DUP(0)
    booking_status DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    booking_count DB 0
    
    ; ========== SEAT SELECTION ARRAYS ==========
    ; Route-specific seat arrays
    ; AC routes (30 seats each)
    route1_ac_seats DB 30 DUP(0)    ; Route 1: Dhaka->Chittagong (Train, AC)
    route2_ac_seats DB 30 DUP(0)    ; Route 2: Chittagong->Sylhet (Bus, AC)
    route5_ac_seats DB 30 DUP(0)    ; Route 5: Khulna->Dhaka (Train, AC)
    route6_ac_seats DB 30 DUP(0)    ; Route 6: Dhaka->Cox Bazar (Bus, AC)
    route9_ac_seats DB 30 DUP(0)    ; Route 9: Comilla->Sylhet (Train, AC)
    route10_ac_seats DB 30 DUP(0)   ; Route 10: Mymensngh->Dhaka (Bus, AC)
    
    ; Non-AC routes (40 seats each)
    route3_nonac_seats DB 40 DUP(0) ; Route 3: Sylhet->Rajshahi (Train, Non-AC)
    route4_nonac_seats DB 40 DUP(0) ; Route 4: Rajshahi->Khulna (Bus, Non-AC)
    route7_nonac_seats DB 40 DUP(0) ; Route 7: Barishal->Dhaka (Train, Non-AC)
    route8_nonac_seats DB 40 DUP(0) ; Route 8: Rangpur->Dhaka (Bus, Non-AC)
    
    ; Helper variables
    current_seat_array DW 0         ; Pointer to current route's seat array
    selected_seats DB 5 DUP(0)
    selected_count DB 0
    seats_needed DB 0
    
    ; ========== INPUT BUFFERS ==========
    input_buffer DB 20 DUP(0)
    temp_buffer DB 10 DUP(0)
    route_choice DB 0
    seats_to_book DB 0
    service_filter DB 0
    type_filter DB 0
    
    ; ========== MESSAGES ==========
    msg_line1 DB 10,13,'=====================================',10,13,'$'
    msg_line2 DB '      TICKET BOOKING SYSTEM',10,13,'$'
    msg_line3 DB '=====================================',10,13,'$'
    
    msg_menu1 DB 10,13,'--- MAIN MENU ---',10,13,'$'
    msg_menu2 DB '1. Signup',10,13,'$'
    msg_menu3 DB '2. Login',10,13,'$'
    msg_menu4 DB '3. Exit',10,13,'$'
    msg_choice DB 'Choice: $'
    
    ;;;;;KRISTINA;;;;;;;
    msg_umenu1 DB 10,13,'--- USER MENU ---',10,13,'$'
    msg_umenu2 DB '1. Search and Book',10,13,'$'
    msg_umenu3 DB '2. My Bookings',10,13,'$'
    msg_umenu4 DB '3. Cancel Ticket',10,13,'$'
    msg_umenu5 DB '4. Logout',10,13,'$' 
    
    
    msg_amenu1 DB 10,13,'--- ADMIN MENU ---',10,13,'$'
    msg_amenu2 DB '1. View All Bookings',10,13,'$'
    msg_amenu3 DB '2. View Route Status',10,13,'$'
    msg_amenu4 DB '3. Search Passenger',10,13,'$'
    msg_amenu5 DB '4. Logout',10,13,'$'
    
    msg_username DB 10,13,'Username: $'
    msg_password DB 10,13,'Password: $'
    msg_login_ok DB 10,13,'Login successful!',10,13,'$'
    msg_login_no DB 10,13,'Invalid credentials!',10,13,'$'
    msg_locked DB 10,13,'Account locked!',10,13,'$'
    
    msg_signup_header DB 10,13,'--- SIGNUP ---',10,13,'$'
    msg_signup_ok DB 10,13,'Signup successful!',10,13,'$'
    msg_signup_fail DB 10,13,'Signup failed!',10,13,'$'
    msg_user_exists DB 10,13,'Username exists!',10,13,'$'
    
    msg_routes DB 10,13,'--- AVAILABLE ROUTES ---',10,13,'$'
    msg_service_menu DB 10,13,'--- SELECT SERVICE ---',10,13,'$'
    msg_service1 DB '1. Bus',10,13,'$'
    msg_service2 DB '2. Train',10,13,'$'
    msg_type_menu DB 10,13,'--- SELECT TYPE ---',10,13,'$'
    msg_type1 DB '1. AC',10,13,'$'
    msg_type2 DB '2. Non-AC',10,13,'$'
    msg_route DB 'Route ','$'
    msg_from DB ': $'
    msg_to DB ' -> $'
    msg_service DB ' | $'
    msg_type DB ' | Type: $'
    msg_fare DB ' | Fare: $'
    msg_seats DB ' | Seats: $'
    
    msg_select DB 10,13,'Select route (1-10): $'
    msg_confirm DB 10,13,'Booking confirmed!',10,13,'$'
    msg_pnr_text DB 'PNR: $'
    
    msg_mybookings DB 10,13,'--- MY BOOKINGS ---',10,13,'$'
    msg_nobookings DB 'No bookings found.',10,13,'$'
    msg_enterpnr DB 10,13,'Enter PNR to cancel: $'
    msg_cancelled DB 10,13,'Booking cancelled!',10,13,'$'
    msg_notfound DB 10,13,'Booking not found!',10,13,'$'
    msg_allbook DB 10,13,'--- ALL BOOKINGS ---',10,13,'$'
    msg_search_pass DB 10,13,'--- SEARCH PASSENGER ---',10,13,'$'
    msg_enter_pass DB 10,13,'Enter passenger name: $'
    msg_pass_not_found DB 10,13,'No bookings found for this passenger!',10,13,'$'
    
    msg_bye DB 10,13,'Thank you!',10,13,'$'
    msg_newline DB 10,13,'$'
    msg_pipe DB ' | $'
    msg_seats_text DB ' | Seats: $'
    msg_passenger DB ' | Passenger: $'
    
    ; Seat selection messages
    msg_seat_hdr DB 10,13,'======= SEAT LAYOUT =======',10,13,'$'
    msg_seat_ac DB 10,13,'--- AC (1+2) ---',10,13,'$'
    msg_seat_nac DB 10,13,'--- NON-AC (2+2) ---',10,13,'$'
    msg_driver DB '      [DRIVER]',10,13,10,13,'$'
    msg_aisle DB ' | $'
    msg_legend DB 10,13,'[##]=Free [XX]=Booked [**]=Your Pick',10,13,'$'
    msg_how_many DB 10,13,'How many seats needed? (1-5): $'
    msg_what_is DB 10,13,'What is your $'
    msg_st DB 'st$'
    msg_nd DB 'nd$'
    msg_rd DB 'rd$'
    msg_th DB 'th$'
    msg_seat_num DB ' seat number? (0=done): $'
    msg_seat_ok DB 10,13,'Seat selected!',10,13,'$'
    msg_seat_taken DB 10,13,'Seat taken!',10,13,'$'
    msg_seat_bad DB 10,13,'Invalid seat!',10,13,'$'
    msg_max_seat DB 10,13,'Max 5 seats!',10,13,'$'
    msg_your_seats DB 10,13,'Your seats: $'
    msg_comma DB ', $'
    msg_no_sel DB 10,13,'No seats selected!',10,13,'$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, msg_line1
    MOV AH, 9
    INT 21H
    LEA DX, msg_line2
    MOV AH, 9
    INT 21H
    LEA DX, msg_line3
    MOV AH, 9
    INT 21H
    
MAIN_LOOP:
    LEA DX, msg_menu1
    MOV AH, 9
    INT 21H
    LEA DX, msg_menu2
    MOV AH, 9
    INT 21H
    LEA DX, msg_menu3
    MOV AH, 9
    INT 21H
    LEA DX, msg_menu4
    MOV AH, 9
    INT 21H
    LEA DX, msg_choice
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '1'
    JE DO_SIGNUP
    CMP AL, '2'
    JE DO_LOGIN
    CMP AL, '3'
    JE EXIT_PROG
    JMP MAIN_LOOP
    
DO_SIGNUP:
    CALL SIGNUP_PROC
    JMP MAIN_LOOP
    
DO_LOGIN:
    CALL LOGIN_PROC
    CMP AL, 1
    JNE MAIN_LOOP
    CMP is_admin, 1
    JE ADMIN_LOOP
    JMP USER_LOOP
    
ADMIN_LOOP:
    LEA DX, msg_amenu1
    MOV AH, 9
    INT 21H
    LEA DX, msg_amenu2
    MOV AH, 9
    INT 21H
    LEA DX, msg_amenu3
    MOV AH, 9
    INT 21H
    LEA DX, msg_amenu4
    MOV AH, 9
    INT 21H
    LEA DX, msg_amenu5
    MOV AH, 9
    INT 21H
    LEA DX, msg_choice
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '1'
    JE VIEW_BOOKS
    CMP AL, '2'
    JE VIEW_ROUTES
    CMP AL, '3'
    JE SEARCH_PASS
    CMP AL, '4'
    JE LOGOUT
    JMP ADMIN_LOOP
;;;;;;;;;;;;;;;;;;;;KRISTINA;;;;;;;;;;;;;;    
USER_LOOP:   
    LEA DX, msg_umenu1
    MOV AH, 9
    INT 21H
    LEA DX, msg_umenu2
    MOV AH, 9
    INT 21H
    LEA DX, msg_umenu3
    MOV AH, 9
    INT 21H
    LEA DX, msg_umenu4
    MOV AH, 9
    INT 21H
    LEA DX, msg_umenu5
    MOV AH, 9
    INT 21H
    LEA DX, msg_choice
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '1' ;FOR SEARCH AND BOOK
    JE DO_BOOK 
    
    CMP AL, '2'
    JE MY_BOOKS ;FOR MY BOOKINGS 
    
    CMP AL, '3'
    JE CANCEL   ;FOR CANCEL TIC 
    
    CMP AL, '4'
    JE LOGOUT   ;FOR LOGOUT
    JMP USER_LOOP
    
DO_BOOK:
    CALL SEARCH_BOOK_PROC
    JMP USER_LOOP
MY_BOOKS:
    CALL DISP_MY_BOOK
    JMP USER_LOOP
CANCEL:
    CALL CANCEL_PROC
    JMP USER_LOOP
VIEW_BOOKS:
    CALL DISP_ALL_BOOK
    JMP ADMIN_LOOP
VIEW_ROUTES:
    MOV service_filter, 0
    CALL DISP_RT
    JMP ADMIN_LOOP
SEARCH_PASS:
    CALL SEARCH_PASSENGER_PROC
    JMP ADMIN_LOOP
LOGOUT:
    MOV is_admin, 0
    MOV login_attempts, 0
    MOV CX, 10
    LEA SI, current_user
CLR_USR:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_USR
    JMP MAIN_LOOP
    
EXIT_PROG:
    LEA DX, msg_bye
    MOV AH, 9
    INT 21H
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

; ========== SIGNUP ==========
SIGNUP_PROC PROC NEAR
    LEA DX, msg_signup_header
    MOV AH, 9
    INT 21H
    
    MOV AL, total_users
    CMP AL, MAX_USERS
    JGE SIGNUP_FAIL
    
    MOV CX, 20
    LEA SI, input_buffer
CLR_SU1:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_SU1
    
    MOV CX, 10
    LEA SI, temp_buffer
CLR_SU2:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_SU2
    
    LEA DX, msg_username
    MOV AH, 9
    INT 21H
    
    MOV CX, 10
    LEA SI, input_buffer
RD_SU_USR:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE SU_USR_DN
    MOV [SI], AL
    INC SI
    LOOP RD_SU_USR
SU_USR_DN:
    CALL CHK_USER
    CMP AL, 1
    JE USR_EXISTS
    
    LEA DX, msg_password
    MOV AH, 9
    INT 21H
    
    MOV CX, 10
    LEA SI, temp_buffer
RD_SU_PWD:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE SU_PWD_DN
    MOV [SI], AL
    INC SI
    LOOP RD_SU_PWD
SU_PWD_DN:
    MOV AL, total_users
    MOV AH, 10
    MUL AH
    LEA SI, input_buffer
    LEA DI, user_names
    ADD DI, AX
    MOV CX, 10
CPY_NU:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP CPY_NU
    
    MOV AL, total_users
    MOV AH, 10
    MUL AH
    LEA SI, temp_buffer
    LEA DI, user_passes
    ADD DI, AX
    MOV CX, 10
CPY_NP:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP CPY_NP
    
    INC total_users
    LEA DX, msg_signup_ok
    MOV AH, 9
    INT 21H
    RET
SIGNUP_FAIL:
    LEA DX, msg_signup_fail
    MOV AH, 9
    INT 21H
    RET
USR_EXISTS:
    LEA DX, msg_user_exists
    MOV AH, 9
    INT 21H
    RET
SIGNUP_PROC ENDP

; ========== CHECK USER ==========
CHK_USER PROC NEAR
    MOV BL, 0
    MOV CL, total_users
    MOV CH, 0
CK_NXT:
    CMP CX, 0
    JE USR_NOT_EX
    PUSH CX
    MOV AL, BL
    MOV AH, 10
    MUL AH
    LEA SI, input_buffer
    LEA DI, user_names
    ADD DI, AX
    MOV CX, 10
CMP_UN:
    MOV AL, [SI]
    CMP AL, 0
    JE CK_UN_END
    CMP AL, [DI]
    JNE UN_NO_M
    INC SI
    INC DI
    LOOP CMP_UN
    JMP UN_FND
CK_UN_END:
    CMP BYTE PTR [DI], 0
    JE UN_FND
UN_NO_M:
    INC BL
    POP CX
    LOOP CK_NXT
    JMP USR_NOT_EX
UN_FND:
    POP CX
    MOV AL, 1
    RET
USR_NOT_EX:
    MOV AL, 0
    RET
CHK_USER ENDP

; ========== LOGIN ==========
LOGIN_PROC PROC NEAR
    CMP login_attempts, 3
    JGE LGN_LCK
    
    MOV CX, 20
    LEA SI, input_buffer
CLR_LI:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_LI
    
    MOV CX, 10
    LEA SI, temp_buffer
CLR_LT:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_LT
    
    LEA DX, msg_username
    MOV AH, 9
    INT 21H
    MOV CX, 10
    LEA SI, input_buffer
RD_LU:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE LU_DN
    MOV [SI], AL
    INC SI
    LOOP RD_LU
LU_DN:
    LEA DX, msg_password
    MOV AH, 9
    INT 21H
    MOV CX, 10
    LEA SI, temp_buffer
RD_LP:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE LP_DN
    MOV [SI], AL
    INC SI
    LOOP RD_LP
LP_DN:
    CALL CHK_CRED
    CMP AL, 1
    JE LGN_OK
    INC login_attempts
    LEA DX, msg_login_no
    MOV AH, 9
    INT 21H
    MOV AL, 0
    RET
LGN_OK:
    MOV login_attempts, 0
    LEA DX, msg_login_ok
    MOV AH, 9
    INT 21H
    MOV CX, 10
    LEA SI, input_buffer
    LEA DI, current_user
CPY_CU:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP CPY_CU
    MOV AL, 1
    RET
LGN_LCK:
    LEA DX, msg_locked
    MOV AH, 9
    INT 21H
    MOV AL, 0
    RET
LOGIN_PROC ENDP

; ========== CHECK CREDENTIALS ==========
CHK_CRED PROC NEAR
    MOV BL, 0
    MOV CL, total_users
    MOV CH, 0
CK_NXT_U:
    CMP CX, 0
    JE CRED_FL
    PUSH CX
    MOV AL, BL
    MOV AH, 10
    MUL AH
    LEA SI, input_buffer
    LEA DI, user_names
    ADD DI, AX
    MOV CX, 10
CMP_U:
    MOV AL, [SI]
    CMP AL, 0
    JE U_END_CK
    CMP AL, [DI]
    JNE U_NO_M
    INC SI
    INC DI
    LOOP CMP_U
    JMP U_MTCH
U_END_CK:
    CMP BYTE PTR [DI], 0
    JE U_MTCH
U_NO_M:
    INC BL
    POP CX
    LOOP CK_NXT_U
    JMP CRED_FL
U_MTCH:
    MOV AL, BL
    MOV AH, 10
    MUL AH
    LEA SI, temp_buffer
    LEA DI, user_passes
    ADD DI, AX
    MOV CX, 10
CMP_P:
    MOV AL, [SI]
    CMP AL, 0
    JE P_END_CK
    CMP AL, [DI]
    JNE P_NO_M
    INC SI
    INC DI
    LOOP CMP_P
    JMP P_MTCH
P_END_CK:
    CMP BYTE PTR [DI], 0
    JE P_MTCH
P_NO_M:
    INC BL
    POP CX
    LOOP CK_NXT_U
    JMP CRED_FL
P_MTCH:
    CMP BL, 0
    JE SET_ADM
    MOV is_admin, 0
    POP CX
    MOV AL, 1
    RET
SET_ADM:
    MOV is_admin, 1
    POP CX
    MOV AL, 1
    RET
CRED_FL:
    MOV AL, 0
    RET
CHK_CRED ENDP

; ========== DISPLAY ROUTES ==========
DISP_RT PROC NEAR
    LEA DX, msg_routes
    MOV AH, 9
    INT 21H
    MOV CL, total_routes
    MOV CH, 0
    MOV BL, 1
    LEA SI, route_sources
DISP_RT_LP:
    PUSH CX
    CMP service_filter, 0
    JE CK_TYP_F
    PUSH SI
    LEA SI, route_services
    MOV AL, BL
    DEC AL
    MOV AH, 5
    MUL AH
    ADD SI, AX
    MOV AL, [SI]
    POP SI
    CMP service_filter, 1
    JNE CK_TRN
    CMP AL, 'B'
    JNE SKP_RT
    JMP CK_TYP_F
CK_TRN:
    CMP AL, 'T'
    JNE SKP_RT
CK_TYP_F:
    CMP type_filter, 0
    JE PRT_RT
    PUSH SI
    LEA SI, route_types
    MOV AL, BL
    DEC AL
    MOV AH, 5
    MUL AH
    ADD SI, AX
    MOV AL, [SI]
    POP SI
    CMP type_filter, 1
    JNE CK_NAC
    CMP AL, 'A'
    JNE SKP_RT
    JMP PRT_RT
CK_NAC:
    CMP AL, 'N'
    JNE SKP_RT
PRT_RT:
    LEA DX, msg_route
    MOV AH, 9
    INT 21H
    MOV AL, BL
    CMP AL, 10
    JL PRT_1D
    MOV DL, '1'
    MOV AH, 2
    INT 21H
    MOV DL, '0'
    MOV AH, 2
    INT 21H
    JMP AFT_NUM
PRT_1D:
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 2
    INT 21H
AFT_NUM:
    LEA DX, msg_from
    MOV AH, 9
    INT 21H
    PUSH BX
    MOV CX, 9
PRT_SRC:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_SRC
    POP BX
    LEA DX, msg_to
    MOV AH, 9
    INT 21H
    PUSH SI
    LEA SI, route_dests
    MOV AL, BL
    DEC AL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    PUSH BX
    MOV CX, 9
PRT_DST:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_DST
    POP BX
    POP SI
    LEA DX, msg_service
    MOV AH, 9
    INT 21H
    PUSH SI
    LEA SI, route_services
    MOV AL, BL
    DEC AL
    MOV AH, 5
    MUL AH
    ADD SI, AX
    PUSH BX
    MOV CX, 5
PRT_SVC:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_SVC
    POP BX
    POP SI
    LEA DX, msg_type
    MOV AH, 9
    INT 21H
    PUSH SI
    LEA SI, route_types
    MOV AL, BL
    DEC AL
    MOV AH, 5
    MUL AH
    ADD SI, AX
    PUSH BX
    MOV CX, 5
PRT_TYP:
    MOV DL, [SI]
    CMP DL, ' '
    JE SKP_TS
    MOV AH, 2
    INT 21H
SKP_TS:
    INC SI
    LOOP PRT_TYP
    POP BX
    POP SI
    LEA DX, msg_fare
    MOV AH, 9
    INT 21H
    PUSH SI
    LEA SI, route_fares
    MOV AL, BL
    DEC AL
    MOV AH, 2
    MUL AH
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    POP SI
    LEA DX, msg_seats
    MOV AH, 9
    INT 21H
    PUSH SI
    LEA SI, route_available_seats
    MOV AL, BL
    DEC AL
    MOV AH, 0
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    POP SI
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    JMP NXT_RT
SKP_RT:
    ADD SI, 9
NXT_RT:
    INC BL
    POP CX
    LOOP DISP_RT_LP
    RET
DISP_RT ENDP

; ========== SEARCH AND BOOK WITH SEAT SELECTION ==========
SEARCH_BOOK_PROC PROC NEAR
    LEA DX, msg_service_menu
    MOV AH, 9
    INT 21H
    LEA DX, msg_service1
    MOV AH, 9
    INT 21H
    LEA DX, msg_service2
    MOV AH, 9
    INT 21H
    LEA DX, msg_choice
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    CMP AL, '1'
    JE SB_BUS
    CMP AL, '2'
    JE SB_TRN
    JMP SB_END
SB_BUS:
    MOV service_filter, 1
    JMP SB_TYP
SB_TRN:
    MOV service_filter, 2
SB_TYP:
    LEA DX, msg_type_menu
    MOV AH, 9
    INT 21H
    LEA DX, msg_type1
    MOV AH, 9
    INT 21H
    LEA DX, msg_type2
    MOV AH, 9
    INT 21H
    LEA DX, msg_choice
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    CMP AL, '1'
    JE SB_AC
    CMP AL, '2'
    JE SB_NAC
    JMP SB_END
SB_AC:
    MOV type_filter, 1
    JMP SB_RTS
SB_NAC:
    MOV type_filter, 2
SB_RTS:
    CALL DISP_RT
    LEA DX, msg_select
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    CMP AX, 1
    JL SB_END
    CMP AX, 10
    JG SB_END
    MOV route_choice, AL
    
    ; Set current seat array based on selected route
    CALL SET_SEAT_ARRAY
    
    ; Select seats based on AC/Non-AC
    CMP type_filter, 1
    JE DO_AC_SEL
    JMP DO_NAC_SEL
DO_AC_SEL:
    CALL SELECT_AC_SEATS
    MOV seats_to_book, AL
    JMP CK_SEL
DO_NAC_SEL:
    CALL SELECT_NONAC_SEATS
    MOV seats_to_book, AL
CK_SEL:
    CMP seats_to_book, 0
    JE NO_SEL
    
    LEA SI, route_available_seats
    MOV AL, route_choice
    DEC AL
    MOV AH, 0
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, seats_to_book
    JL SB_END
    SUB AL, seats_to_book
    MOV [SI], AL
    
    MOV AL, booking_count
    MOV AH, 0
    MOV BL, 2
    MUL BL
    LEA SI, booking_pnr
    ADD SI, AX
    MOV AX, 1001
    MOV BL, booking_count
    MOV BH, 0
    ADD AX, BX
    MOV [SI], AX
    
    MOV AL, booking_count
    MOV AH, 0
    LEA SI, booking_route
    ADD SI, AX
    MOV BL, route_choice
    MOV [SI], BL
    
    LEA SI, booking_seats
    ADD SI, AX
    MOV BL, seats_to_book
    MOV [SI], BL
    
    ; Save individual seat numbers
    MOV AL, booking_count
    MOV AH, 5
    MUL AH
    LEA DI, booking_seat_nums
    ADD DI, AX
    LEA SI, selected_seats
    MOV CL, seats_to_book
    MOV CH, 0
CPY_SN:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP CPY_SN
    
    LEA SI, booking_status
    MOV AL, booking_count
    MOV AH, 0
    ADD SI, AX
    MOV BYTE PTR [SI], 'A'
    
    MOV AL, booking_count
    MOV AH, 10
    MUL AH
    LEA SI, booking_user
    ADD SI, AX
    LEA DI, current_user
    MOV CX, 10
CPY_BU:
    MOV AL, [DI]
    MOV [SI], AL
    INC SI
    INC DI
    LOOP CPY_BU
    
    LEA DX, msg_confirm
    MOV AH, 9
    INT 21H
    LEA DX, msg_pnr_text
    MOV AH, 9
    INT 21H
    MOV AL, booking_count
    MOV AH, 0
    MOV BL, 2
    MUL BL
    LEA SI, booking_pnr
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    INC booking_count
    JMP SB_END
NO_SEL:
    LEA DX, msg_no_sel
    MOV AH, 9
    INT 21H
SB_END:
    MOV service_filter, 0
    MOV type_filter, 0
    RET
SEARCH_BOOK_PROC ENDP

; ========== SET CURRENT SEAT ARRAY ==========
SET_SEAT_ARRAY PROC NEAR
    ; Map route number to correct seat array address
    MOV AL, route_choice
    
    ; Check each route and set appropriate array
    CMP AL, 1
    JE SET_R1
    CMP AL, 2
    JE SET_R2
    CMP AL, 3
    JE SET_R3
    CMP AL, 4
    JE SET_R4
    CMP AL, 5
    JE SET_R5
    CMP AL, 6
    JE SET_R6
    CMP AL, 7
    JE SET_R7
    CMP AL, 8
    JE SET_R8
    CMP AL, 9
    JE SET_R9
    CMP AL, 10
    JE SET_R10
    RET
    
SET_R1:
    LEA SI, route1_ac_seats
    MOV current_seat_array, SI
    RET
SET_R2:
    LEA SI, route2_ac_seats
    MOV current_seat_array, SI
    RET
SET_R3:
    LEA SI, route3_nonac_seats
    MOV current_seat_array, SI
    RET
SET_R4:
    LEA SI, route4_nonac_seats
    MOV current_seat_array, SI
    RET
SET_R5:
    LEA SI, route5_ac_seats
    MOV current_seat_array, SI
    RET
SET_R6:
    LEA SI, route6_ac_seats
    MOV current_seat_array, SI
    RET
SET_R7:
    LEA SI, route7_nonac_seats
    MOV current_seat_array, SI
    RET
SET_R8:
    LEA SI, route8_nonac_seats
    MOV current_seat_array, SI
    RET
SET_R9:
    LEA SI, route9_ac_seats
    MOV current_seat_array, SI
    RET
SET_R10:
    LEA SI, route10_ac_seats
    MOV current_seat_array, SI
    RET
SET_SEAT_ARRAY ENDP

; ========== DISPLAY AC SEATS ==========
DISP_AC_SEATS PROC NEAR
    LEA DX, msg_seat_hdr
    MOV AH, 9
    INT 21H
    LEA DX, msg_seat_ac
    MOV AH, 9
    INT 21H
    LEA DX, msg_driver
    MOV AH, 9
    INT 21H
    MOV BL, 1
    MOV CL, 10
AC_ROW:
    PUSH CX
    ; Print single seat on left
    CALL PRT_AC_SEAT
    INC BL
    ; Print aisle
    LEA DX, msg_aisle
    MOV AH, 9
    INT 21H
    ; Print 2 seats on right
    MOV CH, 2
AC_R:
    PUSH CX
    CALL PRT_AC_SEAT
    INC BL
    POP CX
    DEC CH
    CMP CH, 0
    JG AC_R
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    POP CX
    LOOP AC_ROW
    LEA DX, msg_legend
    MOV AH, 9
    INT 21H
    RET
DISP_AC_SEATS ENDP

; ========== PRINT AC SEAT ==========
PRT_AC_SEAT PROC NEAR
    MOV AL, BL
    DEC AL
    MOV AH, 0
    MOV SI, current_seat_array
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, 0
    JE AC_FR
    CMP AL, 1
    JE AC_BK
    JMP AC_SL
AC_FR:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV AL, BL
    CMP AL, 10
    JL AC_1D
    PUSH BX
    MOV AH, 0
    MOV BH, 10
    DIV BH
    PUSH AX
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    POP AX
    MOV AL, AH
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    POP BX
    JMP AC_CB
AC_1D:
    MOV DL, '0'
    MOV AH, 2
    INT 21H
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 2
    INT 21H
AC_CB:
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
AC_BK:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
AC_SL:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV DL, '*'
    MOV AH, 2
    INT 21H
    MOV DL, '*'
    MOV AH, 2
    INT 21H
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
PRT_AC_SEAT ENDP

; ========== DISPLAY NON-AC SEATS ==========
DISP_NONAC_SEATS PROC NEAR
    LEA DX, msg_seat_hdr
    MOV AH, 9
    INT 21H
    LEA DX, msg_seat_nac
    MOV AH, 9
    INT 21H
    LEA DX, msg_driver
    MOV AH, 9
    INT 21H
    MOV BL, 1
    MOV CL, 10
NAC_ROW:
    PUSH CX
    MOV CH, 2
NAC_L:
    PUSH CX
    CALL PRT_NAC_SEAT
    INC BL
    POP CX
    DEC CH
    CMP CH, 0
    JG NAC_L
    LEA DX, msg_aisle
    MOV AH, 9
    INT 21H
    MOV CH, 2
NAC_R:
    PUSH CX
    CALL PRT_NAC_SEAT
    INC BL
    POP CX
    DEC CH
    CMP CH, 0
    JG NAC_R
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    POP CX
    LOOP NAC_ROW
    LEA DX, msg_legend
    MOV AH, 9
    INT 21H
    RET
DISP_NONAC_SEATS ENDP

; ========== PRINT NON-AC SEAT ==========
PRT_NAC_SEAT PROC NEAR
    MOV AL, BL
    DEC AL
    MOV AH, 0
    MOV SI, current_seat_array
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, 0
    JE NAC_FR
    CMP AL, 1
    JE NAC_BK
    JMP NAC_SL
NAC_FR:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV AL, BL
    CMP AL, 10
    JL NAC_1D
    PUSH BX
    MOV AH, 0
    MOV BH, 10
    DIV BH
    PUSH AX
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    POP AX
    MOV AL, AH
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 2
    INT 21H
    POP BX
    JMP NAC_CB
NAC_1D:
    MOV DL, '0'
    MOV AH, 2
    INT 21H
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 2
    INT 21H
NAC_CB:
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
NAC_BK:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
NAC_SL:
    MOV DL, '['
    MOV AH, 2
    INT 21H
    MOV DL, '*'
    MOV AH, 2
    INT 21H
    MOV DL, '*'
    MOV AH, 2
    INT 21H
    MOV DL, ']'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    RET
PRT_NAC_SEAT ENDP

; ========== SELECT AC SEATS ==========
SELECT_AC_SEATS PROC NEAR
    ; Clear selected seats array
    MOV selected_count, 0
    MOV CX, 5
    LEA SI, selected_seats
CLR_SA:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_SA
    
    ; Ask how many seats needed
    LEA DX, msg_how_many
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    
    ; Validate seat count (1-5)
    CMP AX, 1
    JL SA_INVALID
    CMP AX, 5
    JG SA_INVALID
    MOV seats_needed, AL
    JMP SA_START
    
SA_INVALID:
    MOV seats_needed, 0
    JMP SA_FN
    
SA_START:
    MOV selected_count, 0
    
    ; Display seat layout ONCE at the beginning
    CALL DISP_AC_SEATS
    
SA_LP:
    ; Check if we've selected enough seats
    MOV AL, selected_count
    CMP AL, seats_needed
    JGE SA_DN
    
    ; Prompt: "What is your Xth seat number? (0=done)"
    LEA DX, msg_what_is
    MOV AH, 9
    INT 21H
    
    ; Print seat position number (1st, 2nd, 3rd, etc.)
    MOV AL, selected_count
    INC AL
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print ordinal suffix (st, nd, rd, th)
    MOV AL, selected_count
    INC AL
    CMP AL, 1
    JE SA_1ST
    CMP AL, 2
    JE SA_2ND
    CMP AL, 3
    JE SA_3RD
    JMP SA_TH
SA_1ST:
    LEA DX, msg_st
    JMP SA_PRINT_ORD
SA_2ND:
    LEA DX, msg_nd
    JMP SA_PRINT_ORD
SA_3RD:
    LEA DX, msg_rd
    JMP SA_PRINT_ORD
SA_TH:
    LEA DX, msg_th
SA_PRINT_ORD:
    MOV AH, 9
    INT 21H
    
    ; Print " seat number? (0=done): "
    LEA DX, msg_seat_num
    MOV AH, 9
    INT 21H
    
    ; Read seat number
    CALL READ_NUM
    
    ; Check if user wants to exit (entered 0)
    CMP AX, 0
    JE SA_CHK_EXIT
    
    ; Validate seat number (1-30 for AC)
    CMP AX, 1
    JL SA_BD
    CMP AX, 30
    JG SA_BD
    
    ; Check if seat is available
    MOV BX, AX
    DEC BX
    MOV SI, current_seat_array
    ADD SI, BX
    MOV AL, [SI]
    CMP AL, 0
    JNE SA_TK
    
    ; Mark seat as selected (2 = temporarily selected)
    MOV BYTE PTR [SI], 2
    
    ; Store seat number
    MOV AL, selected_count
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    INC BL
    MOV [SI], BL
    INC selected_count
    
    LEA DX, msg_seat_ok
    MOV AH, 9
    INT 21H
    JMP SA_LP
    
SA_CHK_EXIT:
    ; User entered 0 - check if at least 1 seat selected
    CMP selected_count, 0
    JG SA_DN
    LEA DX, msg_no_sel
    MOV AH, 9
    INT 21H
    JMP SA_FN
    
SA_BD:
    LEA DX, msg_seat_bad
    MOV AH, 9
    INT 21H
    JMP SA_LP
    
SA_TK:
    LEA DX, msg_seat_taken
    MOV AH, 9
    INT 21H
    JMP SA_LP
    
SA_DN:
    ; Display selected seats summary
    CMP selected_count, 0
    JE SA_NS
    LEA DX, msg_your_seats
    MOV AH, 9
    INT 21H
    MOV BL, 0
SA_PL:
    MOV AL, BL
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    INC BL
    CMP BL, selected_count
    JGE SA_PE
    LEA DX, msg_comma
    MOV AH, 9
    INT 21H
    JMP SA_PL
SA_PE:
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
SA_NS:
    ; Mark all selected seats as booked (1 = booked)
    MOV CL, selected_count
    MOV BL, 0
SA_MK:
    CMP CL, 0
    JE SA_FN
    MOV AL, BL
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    MOV AH, 0
    MOV SI, current_seat_array
    ADD SI, AX
    MOV BYTE PTR [SI], 1
    INC BL
    DEC CL
    JMP SA_MK
SA_FN:
    MOV AL, selected_count
    RET
SELECT_AC_SEATS ENDP

; ========== SELECT NON-AC SEATS ==========
SELECT_NONAC_SEATS PROC NEAR
    ; Clear selected seats array
    MOV selected_count, 0
    MOV CX, 5
    LEA SI, selected_seats
CLR_SN:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_SN
    
    ; Ask how many seats needed
    LEA DX, msg_how_many
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    
    ; Validate seat count (1-5)
    CMP AX, 1
    JL SN_INVALID
    CMP AX, 5
    JG SN_INVALID
    MOV seats_needed, AL
    JMP SN_START
    
SN_INVALID:
    MOV seats_needed, 0
    JMP SN_FN
    
SN_START:
    MOV selected_count, 0
    
    ; Display seat layout ONCE at the beginning
    CALL DISP_NONAC_SEATS
    
SN_LP:
    ; Check if we've selected enough seats
    MOV AL, selected_count
    CMP AL, seats_needed
    JGE SN_DN
    
    ; Prompt: "What is your Xth seat number? (0=done)"
    LEA DX, msg_what_is
    MOV AH, 9
    INT 21H
    
    ; Print seat position number (1st, 2nd, 3rd, etc.)
    MOV AL, selected_count
    INC AL
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print ordinal suffix (st, nd, rd, th)
    MOV AL, selected_count
    INC AL
    CMP AL, 1
    JE SN_1ST
    CMP AL, 2
    JE SN_2ND
    CMP AL, 3
    JE SN_3RD
    JMP SN_TH
SN_1ST:
    LEA DX, msg_st
    JMP SN_PRINT_ORD
SN_2ND:
    LEA DX, msg_nd
    JMP SN_PRINT_ORD
SN_3RD:
    LEA DX, msg_rd
    JMP SN_PRINT_ORD
SN_TH:
    LEA DX, msg_th
SN_PRINT_ORD:
    MOV AH, 9
    INT 21H
    
    ; Print " seat number? (0=done): "
    LEA DX, msg_seat_num
    MOV AH, 9
    INT 21H
    
    ; Read seat number
    CALL READ_NUM
    
    ; Check if user wants to exit (entered 0)
    CMP AX, 0
    JE SN_CHK_EXIT
    
    ; Validate seat number (1-40 for Non-AC)
    CMP AX, 1
    JL SN_BD
    CMP AX, 40
    JG SN_BD
    
    ; Check if seat is available
    MOV BX, AX
    DEC BX
    MOV SI, current_seat_array
    ADD SI, BX
    MOV AL, [SI]
    CMP AL, 0
    JNE SN_TK
    
    ; Mark seat as selected (2 = temporarily selected)
    MOV BYTE PTR [SI], 2
    
    ; Store seat number
    MOV AL, selected_count
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    INC BL
    MOV [SI], BL
    INC selected_count
    
    LEA DX, msg_seat_ok
    MOV AH, 9
    INT 21H
    JMP SN_LP
    
SN_CHK_EXIT:
    ; User entered 0 - check if at least 1 seat selected
    CMP selected_count, 0
    JG SN_DN
    LEA DX, msg_no_sel
    MOV AH, 9
    INT 21H
    JMP SN_FN
    
SN_BD:
    LEA DX, msg_seat_bad
    MOV AH, 9
    INT 21H
    JMP SN_LP
    
SN_TK:
    LEA DX, msg_seat_taken
    MOV AH, 9
    INT 21H
    JMP SN_LP
    
SN_DN:
    ; Display selected seats summary
    CMP selected_count, 0
    JE SN_NS
    LEA DX, msg_your_seats
    MOV AH, 9
    INT 21H
    MOV BL, 0
SN_PL:
    MOV AL, BL
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    INC BL
    CMP BL, selected_count
    JGE SN_PE
    LEA DX, msg_comma
    MOV AH, 9
    INT 21H
    JMP SN_PL
SN_PE:
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
SN_NS:
    ; Mark all selected seats as booked (1 = booked)
    MOV CL, selected_count
    MOV BL, 0
SN_MK:
    CMP CL, 0
    JE SN_FN
    MOV AL, BL
    MOV AH, 0
    LEA SI, selected_seats
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    MOV AH, 0
    MOV SI, current_seat_array
    ADD SI, AX
    MOV BYTE PTR [SI], 1
    INC BL
    DEC CL
    JMP SN_MK
SN_FN:
    MOV AL, selected_count
    RET
SELECT_NONAC_SEATS ENDP

; ========== MY BOOKINGS ========== KRISTINA
DISP_MY_BOOK PROC NEAR
    LEA DX, msg_mybookings
    MOV AH, 9
    INT 21H
    MOV CX, 10 ;MAX 10 times BOOKING
    MOV BL, 0
CK_MB:;match booking condition(wrost fst)
    PUSH CX
    MOV AL, BL
    CMP AL, booking_count
    JGE MB_END ;Stops if booking indext>=total bookings
    
    MOV AH, 0
    LEA SI, booking_status
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, 'A'
    JNE SKP_MB
    MOV AL, BL
    MOV AH, 10
    MUL AH ;10 byte for 1 name
    LEA SI, booking_user
    ADD SI, AX
    LEA DI, current_user
    MOV CX, 10
CK_BU:
    MOV AL, [SI];booking user
    CMP AL, [DI] ;current user
    JNE SKP_MB
    CMP AL, 0
    JE USR_MT
    INC SI
    INC DI
    LOOP CK_BU
USR_MT:
    LEA DX, msg_pnr_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    MOV CL, 2
    MUL CL
    LEA SI, booking_pnr ;SI = base + index*2
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_route
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    PUSH BX
    MOV BL, AL
    LEA DX, msg_from
    MOV AH, 9
    INT 21H
    LEA SI, route_sources
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_MS:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_MS
    LEA DX, msg_to
    MOV AH, 9
    INT 21H
    LEA SI, route_dests
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_MD:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_MD
    POP BX
    LEA DX, msg_seats_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print seat numbers
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    MOV DL, '('
    MOV AH, 2
    INT 21H
    CALL PRINT_SEAT_NUMS
    MOV DL, ')'
    MOV AH, 2
    INT 21H
    
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
SKP_MB:
    INC BL
    POP CX
    LOOP CK_MB
MB_END:
    POP CX
    RET
DISP_MY_BOOK ENDP

; ========== CANCEL ==========
CANCEL_PROC PROC NEAR
    LEA DX, msg_enterpnr
    MOV AH, 9
    INT 21H
    CALL READ_NUM
    MOV BX, AX
    MOV CX, 10
    MOV SI, 0
SR_PNR:
    PUSH CX
    MOV AX, SI
    CMP AL, booking_count
    JGE PNR_NF
    MOV AX, SI
    MOV CL, 2
    MUL CL
    LEA DI, booking_pnr
    ADD DI, AX
    MOV AX, [DI]
    CMP AX, BX
    JE PNR_FD
    INC SI
    POP CX
    LOOP SR_PNR
PNR_NF:
    POP CX
    LEA DX, msg_notfound
    MOV AH, 9
    INT 21H
    RET
PNR_FD:
    POP CX
    
    ; Display booking details before cancelling
    PUSH SI
    MOV BX, SI
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    LEA DX, msg_pnr_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    MOV CL, 2
    MUL CL
    LEA SI, booking_pnr
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    
    ; Show route
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_route
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    PUSH BX
    MOV BL, AL
    LEA DX, msg_from
    MOV AH, 9
    INT 21H
    LEA SI, route_sources
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_CS:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_CS
    LEA DX, msg_to
    MOV AH, 9
    INT 21H
    LEA SI, route_dests
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_CD:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_CD
    POP BX
    
    ; Show seats with numbers
    LEA DX, msg_seats_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print seat numbers
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    MOV DL, '('
    MOV AH, 2
    INT 21H
    CALL PRINT_SEAT_NUMS
    MOV DL, ')'
    MOV AH, 2
    INT 21H
    
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    POP SI
    
    ; Now cancel the booking
    MOV AX, SI
    LEA DI, booking_status
    ADD DI, AX
    MOV BYTE PTR [DI], 'C'
    LEA DI, booking_route
    ADD DI, AX
    MOV AL, [DI]
    DEC AL
    MOV AH, 0
    LEA DI, route_available_seats
    ADD DI, AX
    MOV AX, SI
    PUSH SI
    LEA SI, booking_seats
    ADD SI, AX
    MOV AL, [SI]
    POP SI
    ADD [DI], AL
    LEA DX, msg_cancelled
    MOV AH, 9
    INT 21H
    RET
CANCEL_PROC ENDP

; ========== ALL BOOKINGS ==========
DISP_ALL_BOOK PROC NEAR
    LEA DX, msg_allbook
    MOV AH, 9
    INT 21H
    MOV CX, 10
    MOV BL, 0
CK_AB:
    PUSH CX
    MOV AL, BL
    CMP AL, booking_count
    JGE AB_END
    MOV AH, 0
    LEA SI, booking_status
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, 'A'
    JNE SKP_AB
    LEA DX, msg_pnr_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    MOV CL, 2
    MUL CL
    LEA SI, booking_pnr
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    LEA DX, msg_pipe
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_route
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    PUSH BX
    MOV BL, AL
    LEA DX, msg_from
    MOV AH, 9
    INT 21H
    LEA SI, route_sources
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_AS:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_AS
    LEA DX, msg_to
    MOV AH, 9
    INT 21H
    LEA SI, route_dests
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_AD:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_AD
    POP BX
    LEA DX, msg_seats_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print seat numbers
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    MOV DL, '('
    MOV AH, 2
    INT 21H
    CALL PRINT_SEAT_NUMS
    MOV DL, ')'
    MOV AH, 2
    INT 21H
    
    LEA DX, msg_passenger
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 10
    MUL AH
    LEA SI, booking_user
    ADD SI, AX
    PUSH BX
    MOV CX, 10
PRT_PN:
    MOV DL, [SI]
    CMP DL, 0
    JE PN_DN
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_PN
PN_DN:
    POP BX
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
SKP_AB:
    INC BL
    POP CX
    LOOP CK_AB
AB_END:
    POP CX
    RET
DISP_ALL_BOOK ENDP

; ========== SEARCH PASSENGER ==========
SEARCH_PASSENGER_PROC PROC NEAR
    LEA DX, msg_search_pass
    MOV AH, 9
    INT 21H
    
    ; Clear input buffer
    MOV CX, 20
    LEA SI, input_buffer
CLR_SP:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP CLR_SP
    
    ; Prompt for passenger name
    LEA DX, msg_enter_pass
    MOV AH, 9
    INT 21H
    
    ; Read passenger name
    MOV CX, 10
    LEA SI, input_buffer
RD_SP:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE SP_DN
    MOV [SI], AL
    INC SI
    LOOP RD_SP
SP_DN:
    ; Search and display bookings for this passenger
    MOV CX, 10
    MOV BL, 0
    MOV DH, 0  ; Counter for found bookings
CK_SP:
    PUSH CX
    MOV AL, BL
    CMP AL, booking_count
    JGE SP_END
    MOV AH, 0
    LEA SI, booking_status
    ADD SI, AX
    MOV AL, [SI]
    CMP AL, 'A'
    JNE SKP_SP
    
    ; Check if passenger name matches
    MOV AL, BL
    MOV AH, 10
    MUL AH
    LEA SI, booking_user
    ADD SI, AX
    LEA DI, input_buffer
    PUSH BX
    MOV CX, 10
CK_SP_NAME:
    MOV AL, [SI]
    CMP AL, [DI]
    JNE SKP_SP_NM
    CMP AL, 0
    JE SP_NM_MT
    INC SI
    INC DI
    LOOP CK_SP_NAME
SP_NM_MT:
    POP BX
    INC DH  ; Increment found counter
    
    ; Display this booking
    LEA DX, msg_pnr_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    MOV CL, 2
    MUL CL
    LEA SI, booking_pnr
    ADD SI, AX
    MOV AX, [SI]
    CALL PRINT_NUM
    LEA DX, msg_pipe
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_route
    ADD SI, AX
    MOV AL, [SI]
    DEC AL
    PUSH BX
    MOV BL, AL
    LEA DX, msg_from
    MOV AH, 9
    INT 21H
    LEA SI, route_sources
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_SP_SRC:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_SP_SRC
    LEA DX, msg_to
    MOV AH, 9
    INT 21H
    LEA SI, route_dests
    MOV AL, BL
    MOV AH, 9
    MUL AH
    ADD SI, AX
    MOV CX, 9
PRT_SP_DST:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRT_SP_DST
    POP BX
    LEA DX, msg_seats_text
    MOV AH, 9
    INT 21H
    MOV AL, BL
    MOV AH, 0
    LEA SI, booking_seats
    ADD SI, AX
    MOV AL, [SI]
    MOV AH, 0
    CALL PRINT_NUM
    
    ; Print seat numbers
    MOV DL, ' '
    MOV AH, 2
    INT 21H
    MOV DL, '('
    MOV AH, 2
    INT 21H
    CALL PRINT_SEAT_NUMS
    MOV DL, ')'
    MOV AH, 2
    INT 21H
    
    LEA DX, msg_newline
    MOV AH, 9
    INT 21H
    JMP NXT_SP
SKP_SP_NM:
    POP BX
SKP_SP:
NXT_SP:
    INC BL
    POP CX
    LOOP CK_SP
SP_END:
    POP CX
    ; Check if any booking was found
    CMP DH, 0
    JNE SP_RET
    LEA DX, msg_pass_not_found
    MOV AH, 9
    INT 21H
SP_RET:
    RET
SEARCH_PASSENGER_PROC ENDP
 
; ========== PRINT NUM ==========
PRINT_NUM PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 0
    MOV BX, 10
DIV_LP:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIV_LP
PRT_LP:
    POP DX
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    LOOP PRT_LP
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP

; ========== READ NUM ==========
READ_NUM PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    MOV BX, 0
    MOV CX, 0
RD_DG:
    MOV AH, 1
    INT 21H
    CMP AL, 13
    JE RD_DN
    SUB AL, 30H
    MOV CL, AL
    MOV AX, BX
    MOV DX, 10
    MUL DX
    MOV BX, AX
    ADD BX, CX
    JMP RD_DG
RD_DN:
    MOV AX, BX
    POP DX
    POP CX
    POP BX
    RET
READ_NUM ENDP

; ========== PRINT SEAT NUMBERS ==========
PRINT_SEAT_NUMS PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    ; Calculate offset in booking_seat_nums (booking_index × 5)
    MOV AL, BL
    MOV AH, 5
    MUL AH
    LEA SI, booking_seat_nums
    ADD SI, AX
    
    ; Get seat count for this booking
    MOV AL, BL
    MOV AH, 0
    PUSH SI
    LEA SI, booking_seats
    ADD SI, AX
    MOV CL, [SI]
    POP SI
    MOV CH, 0
    
    ; Check if there are seats to print
    CMP CX, 0
    JE PSN_END
    
PSN_LP:
    ; Print seat number
    MOV AL, [SI]
    MOV AH, 0
    PUSH CX
    PUSH SI
    CALL PRINT_NUM
    POP SI
    POP CX
    
    ; Move to next seat
    INC SI
    DEC CX
    
    ; Print comma if more seats remain
    CMP CX, 0
    JE PSN_END
    
    PUSH CX
    PUSH SI
    LEA DX, msg_comma
    MOV AH, 9
    INT 21H
    POP SI
    POP CX
    
    JMP PSN_LP
    
PSN_END:
    POP SI
    POP CX
    POP BX
    POP AX
    RET
PRINT_SEAT_NUMS ENDP

END MAIN
















