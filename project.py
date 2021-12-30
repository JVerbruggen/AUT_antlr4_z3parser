import sys
from antlr4 import *
from antlr_python.nfaLexer import nfaLexer
from antlr_python.nfaParser import nfaParser

from src.nfaVisitorJurjen import nfaVisitorJurjen
from src.graphvizgenerator import GraphVizGenerator
from src.graphvizexecutor import GraphVizExecutor

def main(argv):
    input_stream = FileStream(argv[1])
    lexer = nfaLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = nfaParser(stream)
    tree = parser.startRule()
    
    visitor = nfaVisitorJurjen()
    visitor.visit(tree)

    result = visitor.state

    filename = "jurjen_output.dot"
    graphvizgenerator = GraphVizGenerator(result)
    graphvizgenerator.write(filename)

    graphvizexecutor = GraphVizExecutor()
    graphvizexecutor.run(filename)

if __name__ == '__main__':
    main(sys.argv)