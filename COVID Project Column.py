import pandas as pd
csv_file = '/Users/lilly/Desktop/work/portfolio/covid project/CovidDeaths.csv'
df = pd.read_csv(csv_file)
table_name = 'CovidDeaths'
type_mapping = {
    'object': 'VARCHAR(255)',  
    'int64': 'INTEGER',        
    'float64': 'FLOAT',        
    'datetime64[ns]': 'TIMESTAMP',  
    'bool': 'BOOLEAN'          
}
create_table_sql = f"CREATE TABLE {table_name} (\n"
for column in df.columns:
    col_type = type_mapping.get(str(df[column].dtype), 'VARCHAR(255)')
    create_table_sql += f"    {column} {col_type},\n"

print(create_table_sql)

import pandas as pd
csv_file = '/Users/lilly/Desktop/work/portfolio/covid project/CovidVaccinations.csv'
df = pd.read_csv(csv_file)
table_name = 'CovidVaccinations'
type_mapping = {
    'object': 'VARCHAR(255)',  
    'int64': 'INTEGER',        
    'float64': 'FLOAT',        
    'datetime64[ns]': 'TIMESTAMP',  
    'bool': 'BOOLEAN'          
}
create_table_sql = f"CREATE TABLE {table_name} (\n"
for column in df.columns:
    col_type = type_mapping.get(str(df[column].dtype), 'VARCHAR(255)')
    create_table_sql += f"    {column} {col_type},\n"

print(create_table_sql)


