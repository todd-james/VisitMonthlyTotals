# Snakefile 
# Monthly Visit Counts
# Convert Outputs of Kyoto Visit Locations to Aggregated Monthly Totals 
# James Todd - Jan '24 

import glob 
import os 
import re

# Environment Variables
envvars: 
    "visits_path"

# Parameters
yearmonths = list(set(re.search(r'(\d{6})_\w+_d\d+_t\d+.csv', x).group(1) for x in glob.glob(f"{os.environ['visits_path']}/OutputData_Visits_Clean/*.csv")))

def get_files_for_yearmonth(yearmonth):
    pattern = f"{os.environ['visits_path']}/OutputData_Visits_Clean/{yearmonth}_*_d200_t300.csv"
    return glob.glob(pattern)

rule all: 
    input: 
        "all_months.txt"

rule done_all:  
    input: 
        [f"{os.environ['visits_path']}/Monthly_Totals/{yearmonth}_mesh6_totals.csv" for yearmonth in yearmonths]
    output: 
        "all_months.txt"
    shell: 
        "touch {output}"

for yearmonth in yearmonths: 
    files_for_yearmonth = get_files_for_yearmonth(yearmonth)

    rule: 
        name: 
            f"{yearmonth}_monthly_totals"
        input: 
            files_for_yearmonth
        output: 
            f"{os.environ['visits_path']}/Monthly_Totals/{yearmonth}_mesh6_totals.csv"
        shell: 
            "python process_month.py {output} {input}"

