# Snakefile 
# Monthly Visit Counts
# Convert Outputs of Kyoto Visit Locations to Aggregated Monthly Totals 
# James Todd - Jan '24 

import glob 
import os 

# Environment Variables
envvars: 
    "visits_path"

# Parameters
files = glob.glob(f"{os.environ['visits_path']}/OutputData_Visits/*/*.csv")
yearmonths = list(set(re.search(r'(\d{6})_\w+_d\d+_t\d+.csv', file).group(1) for file in files))


rule all: 
    input: 
        "all_months.txt"

rule done_all:  
    input: 
        expand(f"{os.environ['visits_path']}//Monthly_Totals/{yearmonth}_mesh6_totals.csv", yearmonth = yearmonths)
    output: 
        "all_months.txt"
    shell: 
        "touch {output}"

for yearmonth in yearmonths: 
    rule: 
        name: 
            f"{yearmonth}_monthly_totals"
        input: 
            expand(f"{os.environ['visits_path']}/OutputData_Visits/{yearmonth}_{uuid}_d200_t300.csv")
        output: 
            f"{os.environ['visits_path']}/Monthly_Totals/{yearmonth}_mesh6_totals.csv"
        shell: 
            "python process_month.py {output} {input}"

