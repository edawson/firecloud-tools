from __future__ import print_function
import sys

if __name__ == "__main__":

    tokens = sys.argv[1].strip().split(",")
    if tokens[2] == "1":
        tokens[2] = "-"
    elif tokens[2] == "0":
        tokens[2] = "+"
    if tokens[5] == "1":
        tokens[5] = "-"
    elif tokens[5] == "0":
        tokens[5] = "+"
    if (tokens[0] == tokens[3]) and \
        (abs(int(tokens[4]) - int(tokens[1])) < 2000):
        print(tokens[0], tokens[1], tokens[4])
    elif (tokens[0] != tokens[3]):
        direction = "+" if ((tokens[2] == "+" and tokens[5] == "+") or (tokens[2] == "-" and tokens[5] == "-")) else "-"
        print(" ".join([tokens[0], tokens[1], tokens[3], tokens[4], direction]))
    else:
        print (" ".join(tokens))
