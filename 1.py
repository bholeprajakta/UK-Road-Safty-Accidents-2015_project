import pymysql
myConnection = pymysql.connect(
    host ='localhost', user='root',password='cdac',database='accidents'
)
my_cursor=myConnection.cursor()

my_cursor.execute("delete from accidents_median where vehicle_types='Motorcycle';")
cycle_list = my_cursor.fetchall()
print(cycle_list)
myConnection.commit()
myConnection.close()
print("successfully installed")