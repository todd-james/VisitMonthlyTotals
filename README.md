# Visit Monthly Totals

This repo is a simple Snakemake process that aggregates GPS Visit locations that are created in [GPStoVisits](https://github.com/todd-james/GPStoVisits) and counts the total number of visits in 125m grid cells. 

# Requirements 

- Environment Variable: 
    - Vists data filepath (visits_path)

This should be set up in a local .env file, that may look something like this:
```
visits_path="<PATH>"
```

and can be initialised by running `export $(cat .env | xargs)`

# Execution

To execute this pipline, run `snakemake -j<No. cores>`

## General Summary
The Snakefiles does through a simple process:
1. Gathering all files (containing visit locations) from the same month 
2. Counting the number of visits per grid cell in [process_month.py](process_month.py)
3. Output total number of visits for that month in each grid cell 

This pipeline was created to conduct some spatial syntax analysis of activity patterns in Kyoto, Japan.