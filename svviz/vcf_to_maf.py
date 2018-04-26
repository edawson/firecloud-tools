from __future__ import print_function
import sys

if __name__ == "__main__":

    with open(sys.argv[1], "r") as ifi:
        for line in ifi:
            if not line.startswith("#") and "SVLEN" in line:
                i_d = {}
                tokens = line.strip().split()
                itoks = tokens[7].split(";")
                for i in itoks:
                    s = i.split("=")
                    if len(s) > 1:
                        i_d[s[0]] = s[1]
                strands = itoks[1].split("=")[1][0:2]
                svtype = itoks[0].split("=")[1]
                l = abs(int(i_d["SVLEN"]))
                if svtype == "DEL":
                    strands = "00"
                elif svtype == "INV":
                    strands = "01"
                else:
                    continue
                #print ("\t".join([tokens[0], tokens[1], strands[0], tokens[0], str(int(tokens[1]) + l), strands[1]]))
                print ("\t".join([".", ".", tokens[0], strands[0], tokens[1], tokens[0], strands[1], str(int(tokens[1]) + l)]))
