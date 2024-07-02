         BR      main
         
;--------DATA-----------------------|
nextOp:  .ASCII  "\n--------\n\x00"
equal:   .ASCII  " = \x00"
space:   .ASCII  " \x00" 
errMsg:  .ASCII  " error\x00"

;--------MAIN-----------------------|

;--------Store operator-----|
main:    LDBA    0xFC15,d    ; Load value (OPERATOR) from input.
        
         CPBA    32,i        ; Check for spaces.
         BREQ    main,i
         CPBA    81,i        ; Check for Q.
         BREQ    done,i      
         CPBA    113,i       ; Check for q.
         BREQ    done,i

         ADDSP   -1,i        ; Store in stack.
         STBA    0,s
         
;--------Store op values---|
         ADDSP   -2,i        ; Store First decimal value into stack.
         DECI    0,s
         ADDSP   -2,i        ; Store Second decimal value into stack.
         DECI    0,s

;--------Operation Checks--|        
         LDBA    0xFB8E,d    
         CPBA    43,i        ; Check for sum.
         BREQ    sum,i 
         CPBA    45,i        ; Check for substraction.
         BREQ    sub,i 
         CPBA    42,i        ; Check for multiplication.
         BREQ    mult,i 
         CPBA    47,i        ; Check for division.
         BREQ    div,i 

;--------SUM VALUES---------|
sum:     LDWA    2,s         ; Load first value and add second value.
         ADDA    0,s         
         BRV     error,i     ; Check for overfow.
         ADDSP   -2,i        ; Push result to stack.
         STWA    0,s
         BR      callSub
         
;--------SUBSTRACT VALUES--|     
sub:     LDWA    2,s         ; Load first value and substract second value.
         SUBA    0,s
         BRV     error,i     ; Check for overflow.
         ADDSP   -2,i        ; Push result to stack.
         STWA    0,s  
         BR      callSub   

;--------MULTIPLY VALUES---|  
mult:    LDWX    2,s         ; Check if first or second operator is negative.
         BRLT    neg,i
         LDWA    0,s
         BRLT    neg,i
;Case: both operands are positive.
loopP:   ADDX    -1,i        ; Iterate n amount of times (n = operator).
         BRLE    pResult,i
         ADDA    0,s         ; Add m to register A (m = second operator).
         BRV     error,i     ; Check for overflow.
         BR      loopP
         
;Case: one operands is negative.
neg:     NEGX                ; Make operator positive to perform operation.
         LDWA    0,s         
         BRLT    doubleN,i
loopN:   ADDX    -1,i        ; Iterate n amount of times.
         BRLE    nResult,i 
         ADDA    0,s         ; Add m to register A.
         BRV     error,i     ; Check for overflow.
         BR      loopN
                    
;Case: both operands are negative.
doubleN: NEGA                ; Make second operator positive to perfrom operation.
loopDN:  ADDX    -1,i        ; Iterate n amount of times.
         BRLE    pResult,i 
         SUBA    0,s         ; Add m to register A.
         BRV     error,i     ; Check for overflow.
         BR      loopDN

;Print if result positive.
pResult: ADDSP   -2,i        ; Push positive result to stack.
         STWA    0,s
         BR      callSub
         
;Print if result negative.       
nResult: NEGA                ; Negate result.
         ADDSP   -2,i        ; Push negative result to stack.
         STWA    0,s
         BR      callSub

;--------DIVIDE VALUES-----| 
div:     LDWA    2,s         ; Check if first or second opeartor is negative.
         BRLT    negDiv,i
         LDWA    0,s
         BRLT    negDiv2,i
         LDWA    2,s

;Case: both operands are positive.
pDLoop:  SUBA    0,s         ; Substract second operator from first until smaller than 0.
         BRLT    dResult,i     
         ADDX    1,i         ; Use register X to count number of substractions.
         BR      pDLoop 

;Check if second operand is also negative and branch to.
negDiv:  LDWA    0,s
         BRLT    dNDiv,i
 
;Case: First operand is negative.             
negDiv1: LDWA    2,s         
nDLoop1: ADDA    0,s         ; Add positive operand to negative untill greater than 0.
         BRGT    dResult,i
         ADDX    -1,i        ; Use register X to count (negative) number of substractions.
         BR      nDLoop1      

;Case: Second operand is negative.
negDiv2: LDWA    2,s         
nDLoop2: ADDA    0,s         ; Add negative operand to positive until smaller than 0.
         BRLT    dResult,i
         ADDX    -1,i        ; Use register X to count (negative) number of substractions.
         BR      nDLoop2 
         
;Case: both operands are negative.       
dNDiv:   LDWA    2,s
         NEGA                ; Make first operand positive.
dNDLoop: ADDA    0,s         ; Add negative operand until smaller than 0.
         BRLT    dResult,i
         ADDX    1,i         ; Use register X to count number of substractions.
         BR      dNDLoop
         
;Print Result.                               
dResult: ADDSP   -2,i
         STWX    0,s
         BR      callSub
       
;--------Call Subroutine---|
callSub: CALL    mySub,i     ; Call subroutine to print all of the values in the stack.
         ADDSP   7,i         ; Clean up stack.
         BR      main   

error:   CALL    myErr,i  
         ADDSP   5,i         ; Different clean up because result does not get pushed to stack.
         BR      main       
  
;--------Print Operation---|       
mySub:   LDBA    0xFB8E,d    ; Pop and print all values in the stack in order.
         STBA    0xFC16,d
         STRO    space,d
         DECO    0xFB8C,d
         STRO    space,d
         DECO    0xFB8A,d
         STRO    equal,d
         DECO    0xFB88,d    ; Print result.
         STRO    nextOp,d
         RET
;--------Print Op and Error-| 
myErr:   LDBA    0xFB8E,d    ; Pop and print all values in stack in order.
         STBA    0xFC16,d
         STRO    space,d
         DECO    0xFB8C,d
         STRO    space,d
         DECO    0xFB8A,d
         STRO    equal,d
         STRO    errMsg,d    ; Print error message.
         STRO    nextOp,d
         RET
         
;--------END PROGRAM------------
done:    STBA    0xFC16,d
         STOP
         .end
