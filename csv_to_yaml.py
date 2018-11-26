#!/usr/bin/env python

import csv
import sys
import yaml

csv_data = []
with open(sys.argv[1]) as csvfile:
    reader = csv.DictReader(csvfile)
    print(reader[0])
    for row in reader:
        csv_data.append(row)

with open(sys.argv[1] + '.yml', 'w') as outfile:
    outfile.write(yaml.dump({'csv_data': csv_data}))

