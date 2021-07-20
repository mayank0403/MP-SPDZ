import sys

if len(sys.argv) < 7:
    exit(0)

# print(len(sys.argv))
# for i in range(len(sys.argv)):
    # print("At", i, "we have", sys.argv[i])

# new file path
refpath = sys.argv[1]
# template file path
flpath = sys.argv[2]
# records
R = sys.argv[3]
# bucket size
B = sys.argv[4]
# conditions
C = sys.argv[5]
# threads
T = sys.argv[6]

print(refpath, flpath, R, B, C, T)

flnew = open(flpath, 'w+')
flnew.truncate(0)

flref = open(refpath, 'r')
linesref = flref.readlines()
flref.close()

linesnew = '''
# no of conditions
c = ''' + C + '''
# no of records in DB
logR = ''' + R + '''
# bucket size / bitwidth for comparison
bucket_sz = ''' + B + '''
# no of threads if used by program
threads = ''' + T + '''

'''

# write preamble
flnew.write(linesnew)

# write rest of code template
for i in range(len(linesref)):
    flnew.write(linesref[i])

flnew.close()





