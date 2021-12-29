grammar nfa ;
startRule: SAT_KW model EOF  ;

model   : PAR_OPEN MODEL_KW model_contents PAR_CLOSE    ;
model_contents  : define_fun*   ;

define_fun      : PAR_OPEN DEFINE_FUN_KW IDENTIFIER fun_params any_type fun_contents PAR_CLOSE  ;
fun_params      : PAR_OPEN fun_params_inner PAR_CLOSE       ;
fun_params_inner: fun_param*                                ;
fun_param       : PAR_OPEN IDENTIFIER any_type PAR_CLOSE    ;
fun_contents    : statement*                                ;

statement       : (let | expr)      ;
any_type        : (TYPE_INT_KW | TYPE_BOOL_KW | TYPE_STRING_KW)     ;

let             : PAR_OPEN LET_KW assignments statement PAR_CLOSE   ;
expr            : (bool_expr | int_expr | str_expr | func_call | IDENTIFIER)     ;

func_call       : PAR_OPEN func_name expr* PAR_CLOSE
                ;

func_name       : IDENTIFIER (DOT (IDENTIFIER | SPECIAL_FUNC_IDENTIFIER))*
                ;

bool_expr       : PAR_OPEN bool_expr_inner PAR_CLOSE        # bool_expr_nonliteral
                | func_call                                 # bool_expr_function
                | (TRUE_KW | FALSE_KW)                      # bool_expr_literal
                | IDENTIFIER                                # bool_expr_var
                ;

bool_expr_inner : AND_KW bool_expr bool_expr+               # bool_expr_inner_and
                | OR_KW bool_expr bool_expr+                # bool_expr_inner_or
                | NOT_KW bool_expr                          # bool_expr_inner_not
                | EQUALS_KW expr expr+                      # bool_expr_inner_equals
                | ITE_KW bool_expr expr expr                # bool_expr_inner_ite
                | (LE_KW | GE_KW | LT_KW | GT_KW) int_expr int_expr+    # bool_expr_inner_numerical
                ;

int_expr        : PAR_OPEN int_expr_inner PAR_CLOSE     # int_expr_nonliteral
                | integer                               # int_expr_literal
                | func_call                             # int_expr_function
                | IDENTIFIER                            # int_expr_var
                ;

int_expr_inner  : SYMB_MINUS int_expr*      # int_expr_inner_plus
                | SYMB_PLUS int_expr+       # int_expr_inner_minus
                ;

assignments         : PAR_OPEN assignments_inner PAR_CLOSE  ;
assignments_inner   : assignment+   ;
assignment          : PAR_OPEN IDENTIFIER expr PAR_CLOSE    ;

integer         : NUMBERS       ;

str_expr        : STR_CONTENT   ;

NUMBERS : DIGIT+    ;

TYPE_INT_KW     : 'Int'         ;
TYPE_BOOL_KW    : 'Bool'        ;
TYPE_STRING_KW  : 'String'      ;

DEFINE_FUN_KW   : 'define-fun'  ;
SAT_KW          : 'sat'         ;
MODEL_KW        : 'model'       ;
ITE_KW          : 'ite'         ;
LET_KW          : 'let'         ;

TRUE_KW         : 'true'        ;
FALSE_KW        : 'false'       ;

AND_KW          : 'and'         ;
OR_KW           : 'or'          ;
NOT_KW          : 'not'         ;

LE_KW           : '<='          ;
GE_KW           : '>='          ;
LT_KW           : '<'           ;
GT_KW           : '>'           ;
EQUALS_KW       : '='           ;

SYMB_MINUS      : '-'           ;
SYMB_PLUS       : '+'           ;

PAR_OPEN        : '('   ;
PAR_CLOSE       : ')'   ;
DOT             : '.'   ;

IDENTIFIER      : ('a' .. 'z' | 'A' .. 'Z') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '!')*     ;
STR_CONTENT     : '"' ( ESC_SEQ | ~('\\'|'"') )* '"'    ;
SPECIAL_FUNC_IDENTIFIER : ('++')                        ;
WS              : [ \t\r\n]+ -> skip    ;

fragment ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'"'|'\''|'\\')
    ;

fragment DIGIT  : '0' .. '9'    ;