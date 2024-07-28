-- Package of ALU Operation enum type

library work;

package type_package is
  
  type operation_enum is (
    ADDWF,
    ADDLW,
    ANDWF,
    ANDLW,
    CLRF,
    CLRW,
    COMF,
    DECF,
    INCF,
    IORWF,
    IORLW,
    MOVF,
    MOVWF,
    MOVLW,
    RLF,
    RRF,
    SUBWF,
    SUBLW,
    SWAPF,
    XORWF,
    XORLW,
    NOP,
    BCF,
    RETLW,
    CALL,
    GOTO,
    BSF
    );
  
end package type_package;
