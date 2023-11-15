X: 0b0 
Q: 		0b01110100 ; Multiplicador
Q-1: 		0b0
M: 		0b01100011 ; Multiplicando
Count: 		0x8
M_P:		0x6
M_N:		0x7
inicio:	
ENTER_COUNT:
 MOV ACC, 0b1000	; Introducimos 8 a ACC
		MOV A, ACC		; Muevo 8 a A
		MOV ACC, Count	; Introducimos Count a ACC
		MOV DPTR, ACC	; Muevo Count a DPTR
		MOV ACC, A		; Muevo 8 a ACC
		MOV [DPTR], ACC	; Introducimos 8 a Count
CHECK_M:	
MOV ACC, M		;Introducimos M a ACC
		MOV DPTR, ACC	; Muevo M a DPTR
		MOV ACC, [DPTR]	; Muevo contenido de M a ACC
MOV A, ACC		; Muevo M a A
		MOV ACC, 0b10000000 ; Introducimos 10000000 a ACC
		AND ACC, A		; Revisamos si M es positivo o negativo
		JZ POS_M		; Si es positivo salta a donde se indica
NEG_M:
		MOV ACC, 0b10000000 ; Introducimos 10000000 a ACC
		MOV A, ACC		; Muevo 10000000 a A
		MOV ACC, M	; Introducimos M a ACC
		MOV DPTR, ACC	; Muevo M a DPTR
		MOV ACC, [DPTR]	; Muevo contenido de M a ACC
		ADD ACC, A		; Cambio el signo de M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, M_N	; Introducimos M_N a ACC
		MOV DPTR, ACC 	; Muevo M_N a DPTR
		MOV ACC, A		; Muevo M con el signo cambiado a ACC
		MOV [DPTR], ACC	; Introduzco M en M_N
CHANGE_M:
		MOV ACC, M		; Introducimos M a ACC
		MOV DPTR, ACC	; Muevo M a DPTR
		MOV ACC, [DPTR]	; Muevo contenido de M a ACC
		INV ACC		; Hace complemento a 1 a M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, 0b1 	; Introducimos 1 a ACC
		ADD ACC, A		; Hace complemento a 2 con M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, 0b10000000 ; Introducimos 10000000 a ACC
		ADD ACC, A		; Deja el signo igual al de M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, M_P	; Introducimos M_P
		MOV DPTR, ACC	; Muevo M_P a DPTR
		MOV ACC, A		; Muevo resultado a ACC
		MOV [DPTR], ACC	; Introduzco el resultado del procedimiento a M_P
		JMP START_LOOP	; Salta a donde se indica
POS_M:
		MOV ACC, M		; Introducimos M
		MOV DPTR, ACC	; Muevo la direccion a DPTR
		MOV ACC, [DPTR]	; Muevo contenido de M al ACC
		MOV A, ACC		; Muevo ACC a A
		MOV ACC, M_P	; Introducimos M_P
		MOV DPTR, ACC	; Muevo la dirección a DPTR
		MOV ACC, A		; Muevo contenido de M a ACC
		MOV [DPTR], ACC	; Introduzco el contenido de M en M_P
		INV ACC		; Hace complemento a 1 del contenido de M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, 0b1		; Introducimos 1 a ACC
		ADD ACC, A		; Hace complemento a 2 con M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, M_N	; Introducimos M_N
		MOV DPTR, ACC	; Muevo la direccion a DPTR
		MOV ACC, A		; Muevo complemento a 2 de M a ACC
		MOV [DPTR], ACC	; Introduzco el resultado en M_N
START_LOOP:
	MOV ACC, Count	; Introducimos Count
MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de Count a ACC
	JZ START_MULT	; Salta a donde se indica
	JMP END_LOOP	; Salta al final del código
START_MULT:
MOV ACC, Q		; Introducimos Q
MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de Q a ACC
MOV A, ACC		; Muevo ACC a A
MOV ACC, 0b1		; Introducimos 1 a ACC
AND ACC, A		; Realiza AND entre Q y 1, para ver el valor del LSB
JZ CASOS_0		; Salta si el LSB es 0
MOV ACC, Q-1		; Introducimos Q-1
MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de Q-1 a ACC
JZ SUB			; Salta al proceso de restar pues es el caso 10
JMP RUN		; Salta a donde se indica
CASOS_0:
MOV ACC, Q-1		; Introducimos Q-1
MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de Q-1 a ACC
JZ RUN			; Salta al proceso de corrimiento pues es 00
JMP ADD		; Salta al proceso de suma, pues es el caso 01
SUB:
		MOV ACC, M_N	; Introducimos M_N
		MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de M_N a ACC
MOV A, ACC		; Muevo contenido de M_N a A
		MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de X a ACC
		ADD ACC, A		; Realiza la resta X - M
		MOV [DPTR], ACC	; Actualiza el valor de X tras la resta
		JMP RUN		; Salta al corrimiento de bits
ADD:
		MOV ACC, M_P	; Introducimos M_P
		MOV DPTR, ACC	; Muevo la direccion a DPTR
MOV ACC, [DPTR]	; Muevo contenido de M_P a ACC
		MOV A, ACC		; Muevo ACC a A
		MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de X a ACC
		ADD ACC, A		; Realiza la suma X + M
		MOV [DPTR], ACC	; Actualiza el valor de X
		JMP RUN		; Salta al corrimiento de bits
RUN:
Q_Q-1:	
		MOV ACC, Q		; Introducimos Q
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de Q a ACC
		MOV A, ACC		; Muevo ACC a A
		MOV ACC, 0B1	; Introducimos 1 a ACC
		AND ACC, A		; Realiza AND para saber el valor del LSB de Q
		MOV A, ACC		; Muevo LSB a A
MOV ACC, Q-1		; Introducimos Q-1
MOV DPTR, ACC	; Muevo la direccion a DPTR
 		MOV ACC, A		; Muevo LSB de Q a ACC
		MOV [DPTR], ACC	; Introduzco el LSB de Q a en Q-1
A_Q:
		MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de X a ACC
		MOV A, ACC		; Muevo ACC a A
		MOV ACC, 0B1	; Introducimos 1 a ACC
		AND ACC, A		; Realiza AND para obtener el valor del LSB de X
		JZ RUN_Q0	; Si el LSB es 0, salta al corrimiento de bits para ese caso
RUN_Q1:
MOV ACC, Q		; Introducimos Q
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de Q a ACC 
RSH ACC 0B1		; Muevo los bits una posición hacia la derecha
MOV A, ACC		; Muevo resultado a A
MOV ACC, 0B10000000 ; Introducimos 10000000 en ACC
ADD ACC, A		; Del resultado del corrimiento, cambia el MSB a 1 
MOV [DPTR], ACC	; Introduzco el resultado del corrimiento en Q 
JMP RUN_A		; Salta al corrimiento de A
RUN_Q0:
		MOV ACC, Q		; Introducimos Q
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de Q a ACC 
RSH ACC 0B1		; Realiza el corrimiento de bits una posición a la derecha
MOV [DPTR], ACC	; Introduzco el resultado del corrimiento en Q 
JMP RUN_A		; Salta al corrimiento de A
RUN_A:
		MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de X a ACC 
		MOV A, ACC		; Muevo ACC a A
		MOV ACC, 0B10000000 ; Introducimos 10000000 a ACC
		AND ACC, A	; Realiza AND para consultar el valor del MSB de X
		JZ COR_A0	; Si es 0, salta al corrimiento para ese caso
COR_A1:	
MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de X a ACC 
		RSH ACC 0B1		; Muevo los bits una posición a la derecha
MOV A, ACC		; Muevo resultado del corrimiento a A
MOV ACC, 0B10000000 ; Introducimos 10000000 a ACC
ADD ACC, A		; Al resultado del corrimiento le cambia el MSB a 1
MOV [DPTR], ACC	; Introduzco el resultado final en X
JMP ACTU_CO		; Salta a la actualización del valor de Count
COR_A0:	
MOV ACC, X		; Introducimos X
		MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de X a ACC 
		RSH ACC 0B1		; Muevo los bits una posición a la derecha
MOV [DPTR], ACC	; Introduzco el resultado final en X
JMP ACTU_CO		; Salta a la actualización del valor de Count
ACTU_CO:
		MOV ACC, 0b1		; Introducimos  1 a ACC
		INV ACC		; Hace complemento a 1 a M
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, 0b1 	; Introducimos 1 a ACC
		ADD ACC, A		; Hace complemento a 2 con 1
		MOV A, ACC		; Muevo resultado a A
		MOV ACC, Count	; Introducimos Count 
MOV DPTR, ACC	; Muevo la direccion a DPTR 
MOV ACC, [DPTR]	; Muevo contenido de Count a ACC 
ADD ACC, A		; Hace la resta Count -1
MOV [DPTR], ACC	; Introduzco el resultado de la resta en Count otra vez
JMP START_LOOP	; Salta al inicio del loop
END_LOOP:
		hlt			; Fin del código