def solve(bits):
    
    # Store the bits in a list
    data = [(bits >> i) & 1 for i in range(15, -1, -1)]

    # recompute parity bits based on data bits
    p8 = sum(data[i] for i in [0, 1, 2, 3, 4, 5, 6]) % 2
    p4 = sum(data[i] for i in [0, 1, 2, 3, 8, 9, 10]) % 2
    p2 = sum(data[i] for i in [0, 1, 4, 5, 8, 9, 12]) % 2
    p1 = sum(data[i] for i in [0, 2, 4, 6, 8, 10, 12]) % 2
    p0 = sum(data[i] for i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11]) % 2
    
    # Calculate error position
    error_position = 0
    if p8 != data[7]: error_position += 7
    if p4 != data[11]: error_position += 11
    if p2 != data[13]: error_position += 13
    if p1 != data[14]: error_position += 14
    if p0 != data[15]: error_position+=15
    
    # Check for errors
    if error_position == 0 and p0 == data[15]: 
        print("No errors")
        flag = [0, 0] # no error flag
    
    elif error_position == 0:
        print("Detected two-bit error, cannot correct.")
        flag = [1, 0] # two-bit error flag
    
    else:
        print(f"Detected error at bit position {error_position}. Correcting...")
        data[error_position] ^= 1
        flag = [0, 1] # one-bit error flag
    
    return flag + [0, 0, 0] + [data[i] for i in [0,1,2,3,4,5,6,8,9,10,12]]
