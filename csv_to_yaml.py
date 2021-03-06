#!/usr/bin/env python

import csv
import sys
import yaml

csv_data = []
with open(sys.argv[1]) as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        csv_data.append(row)

with open(sys.argv[1] + '.yml', 'w') as outfile:
    outfile.write(yaml.dump(csv_data))

with open(sys.argv[1] + '.yml', 'rU') as f:
    data = yaml.safe_load(f)
    counter = 0
    for line in data:
        for i in line.keys():
            NewKey = i.replace(" ", "_")
	    line[NewKey+str(counter)] = line[i]
            del line[i]
            counter = counter + 1

with open(sys.argv[1] + '.yml', 'w') as f:
    yaml.dump(data, f)
