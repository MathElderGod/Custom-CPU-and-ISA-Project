def solve(bits):

    # Extract the bits
    original_data = [(bits >> i) & 1 for i in range(15, -1, -1)]
    data = [(bits >> i) & 1 for i in range(15, -1, -1)]
    
    # Compute expected parities
    p8 = sum(data[i] for i in [7, 9, 10, 11, 12, 13, 14]) % 2
    p4 = sum(data[i] for i in [7, 8, 11, 12, 13]) % 2
    p2 = sum(data[i] for i in [7, 8, 9, 14, 15]) % 2
    p1 = sum(data[i] for i in [7, 9, 11, 13, 15]) % 2
    p0 = (sum(data[7:]) + p4 + p2 + p1) % 2

    # Calculate parity issue
    parity_issue = (p8 << 3) | (p4 << 2) | (p2 << 1) | p1
    
    # If parity issue is not zero, it points to the error bit
    if parity_issue != 0:
        # Correct the error
        data[parity_issue-1] = 1 - data[parity_issue-1]
    
    # Check if error is corrected or still there (two errors)
    corrected_p0 = (sum(data[7:]) + p4 + p2 + p1) % 2
    if corrected_p0 == data[0]:
        if parity_issue == 0:
            flag = [0, 0]  # No errors
        else:
            flag = [0, 1]  # One error
    else:
        flag = [1, 0]  # Two errors
    
    # Extract the original 11-bit message
    message = [original_data[0], original_data[1], original_data[2], original_data[3], original_data[4], original_data[5], original_data[6], original_data[8], original_data[9], original_data[10], original_data[12]]
    
    return flag + [0, 0, 0] + message