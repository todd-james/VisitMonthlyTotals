# Monthly Mesh6 Visit Counts
# Aggregate to total visits per month 
# James Todd - Jan '24 

import sys 
import pandas as pd 
import geopandas as gpd
from shapely.geometry import Point

def sum_visits(input_files, output_file): 
    # Initialize an empty DataFrame
    monthly_totals = pd.DataFrame(columns=['year', 'momth' 'mesh6_id', 'total_visits'])

    for input_file in input_files: 
        # Load in file 
        data = pd.read_csv(input_file)

        # Pull year and month for later
        year = input_file.split('/')[-1][:4]
        month = input_file.split('/')[-1][4:6]

        # Convert to geometry 
        data = gpd.GeoDataFrame(data, crs='EPSG:4326', geometry=[Point(xy) for xy in zip(data['long'], data['lat'])])

        # Do point in polygon for each point and append mesh6 id 
        data = gpd.sjoin(data, grid6, how = 'left', op = 'within')

        # Remove unnecesary columns and visits outside of the grid area
        data = data.drop(['geometry',  'index_right',  'OBJECTID',  'GRID_LEVEL', 'Shape_Leng', 'Shape_Area', 'mesh6'], axis = 1).dropna(subset=['GRID_CODE'])

        # Count number of visits per grid cell
        data = data.groupby('GRID_CODE').size().reset_index(name='count')

        # Add and rename columns to match monthly_totals 
        data.insert(0, 'year', year)
        data.insert(1, 'month', month)
        data.columns = ['year', 'month', 'mesh6_id', 'total_visits']

        # Append and sum up total visits per grid cell
        monthly_totals = pd.concat([monthly_totals, data])
        monthly_totals = monthly_totals.groupby(['year', 'month', 'mesh6_id'], as_index=False)['total_visits'].sum()
    
    monthly_totals.to_csv(output_file, header=True, index=False)


if __name__ == "__main__":
    if len(sys.argv) < 3: 
        print("Useage: python process_month.py output_file input_file1 input_file2 ... input_fileN")
        sys.exit(1)

    grid6 = gpd.read_file("/Volumes/kyotogps-db/meshall/GRID6.shp").to_crs('EPSG:4326')

    output_file = sys.argv[1]
    input_files = sys.argv[2:]
    sum_visits(input_files, output_file)