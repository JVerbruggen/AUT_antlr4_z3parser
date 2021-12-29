cd java
del *.class
call javac -g *.java
call java org.antlr.v4.gui.TestRig nfa startRule -gui ../input.txt
