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
    BSF
    );
  
end package type_package;
