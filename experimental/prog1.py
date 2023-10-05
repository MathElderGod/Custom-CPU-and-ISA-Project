def solve(bits):
    
    # Store the bits in a list
    data = [(bits >> i) & 1 for i in range(10, -1, -1)]
    
    # Calculate p8
    p8 = 0
    for i in [10,9,8,7,6,5,4]: 
        p8^=data[i]
    
    # Calculate p4
    p4 = 0
    for i in [10,9,8,7,3,2,1]: 
        p4^=data[i]
    
    # Calculate p2
    p2 = 0
    for i in [10,9,6,5,3,2,0]: 
        p2^=data[i]
    
    # Calculate p1
    p1 = 0
    for i in [10,8,6,4,3,1,0]: 
        p1^=data[i]
    
    # Calculate p0
    p0 = p4 ^ p2 ^ p1
    for bit in data: 
        p0^=bit
    
    # Return encoded message
    return [data[10], data[9], data[8], data[7], data[6], data[5], data[4], p8, data[3], data[2], data[1], p4, data[0], p2, p1, p0]
    
    
    

        