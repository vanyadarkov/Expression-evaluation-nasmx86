global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        mov     eax, 0              ; result

        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]          ;   * (p + *i)
        cmp     cl, 40              ; if this is a "(" 
        je      paran
factor_loop:
        cmp     cl, 48     ; check if at current pos is a digit
        jl      exit_factor
        cmp     cl, 57
        jg      exit_factor
        mov     ebx, 10     ; if yes -> extract number
        mul     ebx         ; result * 10
        add     eax, ecx    ; result * 10 + *(p + *i)
        sub     eax, 48     ; result * 10 + *(p + *i) - '0'
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]
        inc     ecx
        mov     ebx, [ebp + 12]
        mov     DWORD [ebx], ecx    ; *i += 1 (go to next char)
        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]      ; * (p + *i) (get the char at i pos in string
        jmp     factor_loop

paran:
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]
        inc     ecx
        mov     ebx, [ebp + 12]
        mov     DWORD [ebx], ecx ; *i += 1 (go to next position)
        mov     esi, [ebp + 8]
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    expression ; expression(p,i)
        add     esp, 8
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]
        inc     ecx
        mov     ebx, [ebp + 12]
        mov     DWORD [ebx], ecx ; *i += 1

exit_factor:
        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp
        
        mov     esi, [ebp + 8]
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    factor     ; factor(p,i)
        add     esp, 8

        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]          ;   * (p + *i)

term_loop:
        cmp     cl, 42      ; if current char is "*"
        je      multip    
        cmp     cl, 47      ; if current char is "/"
        je      divis
        jne     exit_term

multip:
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]
        inc     ecx
        mov     ebx, [ebp + 12]
        mov     DWORD [ebx], ecx ; *i += 1
        push    eax        ; save the previous result from factor
        
        mov     esi, [ebp + 8]
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    factor     ; factor(p,i)
        
        add     esp, 8
        pop     ecx         ; extract the previous result

        imul    eax, ecx   ; previous *= curent

        jmp     term_continue

divis:
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]
        inc     ecx
        mov     ebx, [ebp + 12]
        mov     DWORD [ebx], ecx ; *i += 1
        push    eax                ; save the previous result
        mov     esi, [ebp + 8]
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    factor     ; factor(p,i)
        add     esp, 8
        pop     ecx         ; extract the previous result
        push    eax        ; save current result
        mov     eax, ecx    ; place previous to eax
        pop     ecx         ; and current now is ecx

        cdq
        idiv    ecx        ; previous / current

        jmp     term_continue

term_continue:
        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]          ;   * (p + *i)
        jmp     term_loop

exit_term:        

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp
        
        mov     esi, [ebp + 8]
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    term       ; term(p,i)
        add     esp, 8

        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]      ;   * (p + *i)

expr_loop:
        cmp     cl, 43  ; if current char is "+"
        je      addition ; do +
        cmp     cl, 45  ; if "-"
        je      subtraction ; do - 
        jne     exit_expr ; exit

addition:
        mov     ecx, [ebp + 12] ;
        mov     ecx, [ecx]      ;
        inc     ecx             ;
        mov     ebx, [ebp + 12] ;
        mov     DWORD [ebx], ecx ; *i += 1
        push    eax             ; save previous result from term
        mov     esi, [ebp + 8]  
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    term            ; term(p,i)
        add     esp, 8
        pop     ecx             ; extract previous
        add     eax, ecx        ; previous += current
        jmp     expr_continue


subtraction:
        mov     ecx, [ebp + 12] ;
        mov     ecx, [ecx]      ;
        inc     ecx             ;
        mov     ebx, [ebp + 12] ;
        mov     DWORD [ebx], ecx ; *i += 1
        push    eax             ; save previous result from term
        mov     esi, [ebp + 8]  
        mov     ecx, [ebp + 12]
        push    ecx
        push    esi
        call    term            ; term(p,i)
        add     esp, 8
        pop     ecx             ; extract previous
        sub     ecx, eax        ; previous -= current
        mov     eax, ecx        
        jmp     expr_continue

expr_continue:
        mov     ecx, [ebp + 12]     ;
        mov     ecx, [ecx]          ;        
        mov     esi, [ebp + 8]      ;
        lea     esi, [esi + ecx]    ;
        xor     ecx, ecx
        mov     cl, BYTE [esi]      ;   * (p + *i)
        jmp     expr_loop

exit_expr:

        leave
        ret
