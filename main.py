import prog2

# print( prog2.solve(0b1010_1010_0101_1011) )

result = prog2.solve(0b1010_1010_0101_1011)
expected = [0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1]

print(result == expected)