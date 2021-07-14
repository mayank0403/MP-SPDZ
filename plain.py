# no of conditions
c = 5
# no of records in DB
R = (1 << 16)
# no of features in DB
# assuming = c now
ftrs = c + 1

# cleartext
db_c = [[0 for i in range(ftrs)] for j in range(R)]
intervals_c = [[0 for i in range(2)] for j in range(c)]
agg_c = 0

# for i in range(R):
    # print(db_c[i])

for i in range(R):
    for j in range(ftrs):
        # print(((i) % 64) + j)
        # print(i, j)
        db_c[i][j] = ((i) % 65) + j
        # print(db_c[i][j])

# for i in range(R):
    # print(db_c[i])

for i in range(c):
    intervals_c[i][0] = 63
    intervals_c[i][1] = 126

for i in range(R):
    flag = 1
    # print(flag, db_c[i])
    for j in range(ftrs - 1):
        if not ((intervals_c[j][0] < db_c[i][j]) and (intervals_c[j][1] > db_c[i][j])):
            flag = 0
    agg_c = agg_c + flag * db_c[i][ftrs - 1]



print(agg_c)
print(agg_c % 256)

