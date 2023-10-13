import prog2

# print( prog2.solve(0b1010_1010_0101_1011) )

# # Changed last bit p0
# result = prog2.solve(0b1010_1010_0101_1011)
# expected = [0,1,0,0,0,1,0,1,0,1,0,1,0,1,0,1]

# # No issue
# result = prog2.solve(0b0011_0000_0101_1001)
# expected = [0,0,0,0,0,1,0,1,0,0,0,0,1,1,0,0]

# First bit b11 0 to 1
result = prog2.solve(0b1011_0000_0101_1001)
expected = [0,1,0,0,0,1,0,1,0,0,0,0,1,1,0,0]


print('result is ' + str(result))
print(result == expected)