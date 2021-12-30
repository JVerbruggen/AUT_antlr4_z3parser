from antlr4 import *
from antlr_python.nfaVisitor import nfaVisitor
from antlr_python.nfaParser import nfaParser

from src.graphstate import GraphState

class nfaVisitorJurjen(nfaVisitor):
    def __init__(self):
        self.state = GraphState()

    def visitDefine_fun(self, ctx:nfaParser.Define_funContext):
        fun_name = str(ctx.getChild(2))

        if fun_name == "A":
            vals = self.visit(ctx.getChild(5))

            self.state.connections = vals
            print(vals)

        elif fun_name == "FinalStates":
            final_states_str = self.visit(ctx.getChild(5))
            final_states = final_states_str.split(":")[:-1]
            final_states = [int(x) for x in final_states]

            self.state.final_states = final_states
            print(final_states)

        elif fun_name == "InitState":
            init_state = int(self.visit(ctx.getChild(5)))

            self.state.init_state = init_state
            print(init_state)

        return None



    def visitBool_expr_inner_ite(self, ctx:nfaParser.Bool_expr_inner_iteContext):
        vals = [self.visit(ctx.getChild(1))] # [int]

        ite_chain = self.visit(ctx.getChild(3))
        if ite_chain is not None:
            vals += ite_chain

        return vals
        
    def visitBool_expr_inner_and(self, ctx:nfaParser.Bool_expr_inner_andContext):
        vals = []
        for (i, child) in enumerate(ctx.getChildren()):
            if i == 0: continue
            vals += [self.visit(child)]
        return tuple(vals)

    def visitBool_expr_nonliteral(self, ctx:nfaParser.Bool_expr_nonliteralContext):
        return self.visit(ctx.getChild(1))

    def visitBool_expr_inner_equals(self, ctx:nfaParser.Bool_expr_inner_equalsContext):
        return self.visit(ctx.getChild(2))

    def visitInteger(self, ctx:nfaParser.IntegerContext):
        return int(str(ctx.getChild(0)))

    def visitStr_expr(self, ctx:nfaParser.Str_exprContext):
        return str(ctx.getChild(0))[1:-1]