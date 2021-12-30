class GraphState:
    def __init__(self, init_state: int = None, final_states: [int] = None, connections: [tuple] = None):
        self.init_state = init_state
        self.final_states = final_states
        self.connections = connections