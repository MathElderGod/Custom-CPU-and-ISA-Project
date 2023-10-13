def solve(bits):

    # Extract the bits
    data = [(bits >> i) & 1 for i in range(15, -1, -1)]

    data.reverse()

    # Compute expected parities
    p8 = 0
    for i in [15, 14, 13, 12, 11, 10, 9]:
        p8 ^= data[i]
    
    p4 = 0
    for i in [15, 14, 13, 12, 7, 6, 5]:
        p4 ^= data[i]
    
    p2 = 0
    for i in [15, 14, 11, 10, 7, 6, 3]:
        p2 ^= data[i]

    p1 = 0
    for i in [15, 13, 11, 9, 7, 5, 3]:
        p1 ^= data[i]

    p0 = p8 ^ p4 ^ p2 ^ p1
    for i in [15, 14, 13, 12, 11, 10, 9, 7, 6 , 5, 3]:
        p0 ^= data[i]

    # Check discrepancy
    p8 = 1 if p8 != data[8] else 0
    p4 = 1 if p4 != data[4] else 0
    p2 = 1 if p2 != data[2] else 0
    p1 = 1 if p1 != data[1] else 0
    p0 = 1 if p0 != data[0] else 0

    # print('p8 p4 p2 p1 p0 ' + str(p8) + str(p4) + str(p2) + str(p1) + str(p0))
    parity_issue = (p8 << 3) | (p4 << 2) | (p2 << 1) | p1
    
    if parity_issue == 0 and p0 == 0:
        flag = [0, 0]  # No errors
    elif parity_issue == 0 and p0 == 1:
        flag = [0, 1]  # One error
        data[parity_issue] ^= 1
    elif p0 == 0:
        flag = [1, 0] #Two errors
    else:
        flag = [0, 1]  # One error
        data[parity_issue] ^= 1 # Fix error

    # Extract the original 11-bit message
    message = [data[3], data[5], data[6], data[7], data[9], data[10], data[11], data[12], data[13], data[14], data[15]]
    
    return flag + [0, 0, 0] + message