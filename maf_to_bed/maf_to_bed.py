import sys

if __name__ == "__main__":
    
    slop = 200
    for line in sys.stdin:
        if line .startswith ("#") or line.startswith("individual") or line.startswith("Hugo_Symbol"):
            continue
        tokens = line.strip().split("\t")
        chr_1 = tokens[2]
        start = int(tokens[4])
        chr_2 = tokens[5]
        end = int(tokens[7])
        line_one = "\t".join([ chr_1, str(start - slop), str(start + slop), ";".join(tokens)])
        line_two = "\t".join([chr_2, str(start - slop), str(start + slop), ";".join(tokens)])
        print(line_one)
        print(line_two)
