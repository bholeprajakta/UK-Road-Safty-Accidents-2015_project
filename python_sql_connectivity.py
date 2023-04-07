import pymysql
myConnection = pymysql.connect(
    host ='localhost', user='root',password='cdac',database='accidents'
)
my_cursor=myConnection.cursor()

my_cursor.execute("SELECT vehicle_type FROM vehicle_types WHERE vehicle_type LIKE '%car%';")
cycle_list = my_cursor.fetchall()


selectSQL = ('''
SELECT vt.vehicle_type, a.accident_severity
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE %s
ORDER BY a.accident_severity;
''')

insert_SQL = ('''INSERT INTO accidents_median
VALUES(%s, %s);''')

for cycle in cycle_list:
    my_cursor.execute(selectSQL, cycle[0])
    accidents = my_cursor.fetchall()

    # calculate median severity
    # divide the length of accidents /2 to find the median of accdients list
    quotient, remainder = divmod(len(accidents), 2)

    if remainder:
        # meaning odds number of items in accidents list
        median_severity = accidents[quotient][1]
    else:
        # even numbers of items in accidents list
        median_severity = (accidents[quotient]
                           [1] + accidents[quotient + 2][1]) / 2

    print("finding Median Severity for ", cycle[0])

    # insert the calculated median severity into table
    my_cursor.execute(insert_SQL, (cycle[0], median_severity))

myConnection.commit()
myConnection.close()
print("successfully installed")