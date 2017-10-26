import csv
import numpy as np
def run(data_name):
    i = 0
    with open(data_name, 'r') as file:
        tmp = csv.reader(file, delimiter = ',')
        for line in tmp:
            if i == 0:
                data = line
                data = np.array(data)
            elif line != []:
                data = np.vstack((data,line))
            i += 1
    return data.astype(np.float)
