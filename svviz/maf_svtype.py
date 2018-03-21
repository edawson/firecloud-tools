from __future__ import print_function
import sys

def classify_sv(line):

    tokens = line.strip().split(",")
    if tokens[2] == "1":
        tokens[2] = "-"
    elif tokens[2] == "0":
        tokens[2] = "+"
    if tokens[5] == "1":
        tokens[5] = "-"
    elif tokens[5] == "0":
        tokens[5] = "+"

    sz = abs( int(tokens[4]) - int(tokens[1]) )
    if (tokens[0] != tokens[3]):
        return "tra"
    elif (sz > 2000):
        return "bend"
    elif (tokens[2] == "+" and tokens[5] == "+"):
        return "del"
    elif (tokens[2] == "+" and tokens[5] == "-") or \
        (tokens[2] == "-" and tokens[5] == "+"):
        return "inv"
    else:
        return "bend"

if __name__ == "__main__":
    
    print(classify_sv(sys.argv[1]))
