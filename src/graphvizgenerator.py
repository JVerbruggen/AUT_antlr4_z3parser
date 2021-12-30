from src.graphstate import GraphState

class GraphVizGenerator:
    def __init__(self, state: GraphState):
        self.state = state

    def write(self, filename):
        init_arrow = f"  dummy -> {self.state.init_state%10}"
        double_circles = f"\n".join([f"  {n%10} [shape = doublecircle]" for n in self.state.final_states])
        connections = f"\n".join([f"  {a%10} -> {b%10} [label = \"{label}\"]" for (a,b,label) in self.state.connections])

        output = ''.join(["digraph nfa {" 
        , f"\n  rankdir = LR"
        , f"\n  node [shape = circle, style = filled, fillcolor = white, fontname = Arial]"
        , f"\n  edge [fontname = Arial]"
        , f"\n  dummy [style = filled, fontcolor = white, color = white]\n"
        , f"\n" + init_arrow + f"\n"
        , double_circles + f"\n"
        , connections
        , f"\n" + "}"])

        with open(filename, 'w') as f:
            f.write(output)