create schema accidents;

use accidents;

CREATE TABLE accident(
accident_index VARCHAR(13),
accident_severity INT
);

CREATE TABLE vehicles(
	accident_index VARCHAR(13),
    vehicle_type VARCHAR(50)
);

CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\bhole\\OneDrive\\Desktop\\New Volume\\dataset_project\\Accidents_2015.csv'
 INTO TABLE accident
 FIELDS TERMINATED BY ','
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
 SET accident_index=@col1, accident_severity=@col2;

LOAD DATA LOCAL INFILE 'C:\\Users\\bhole\\OneDrive\\Desktop\\New Volume\\dataset_project\\Vehicles_2015.csv'
 INTO TABLE vehicles
 FIELDS TERMINATED BY ','
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
 SET accident_index=@col1, vehicle_type=@col2;
 
LOAD DATA LOCAL INFILE 'C:\\Users\\bhole\\OneDrive\\Desktop\\New Volume\\dataset_project\\vehicle_type.csv'
 INTO TABLE vehicle_types
 FIELDS TERMINATED BY ','
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
 
 CREATE TABLE accidents_median(
vehicle_types VARCHAR(100),
severity INT
);

#get Accident Severity and Total Accidents per Vehicle Type 
SELECT vt.vehicle_type AS 'Vehicle Type', a.accident_severity AS 'Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 3 desc;

/* Average Severity by vehicle type */
SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;


/* Average Severity and Total Accidents by Motorcyle */
SELECT vt.vehicle_type AS 'Vehicle Type', AVG(a.accident_severity) AS 'Average Severity', COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.vehicle_code
WHERE vt.vehicle_type LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 2,3;