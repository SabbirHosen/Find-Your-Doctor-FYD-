CREATE VIEW doctors_full_information AS
    SELECT 
        d.d_id,
        d.doctor_name,
        d.qualification,
        d.designation,
        s.specialist_name,
        h.hospital_name,
        h.address,
        h.contact,
        w.Consulting_hour_start,
        w.Consulting_hour_end,
        w.Consulting_fees,
        w.Consulting_days
    FROM
        doctors d
            JOIN
        works w USING (d_id)
            JOIN
        hospitals h USING (h_id)
            JOIN
        specialists s USING (sp_id);
        
#1 Find doctors specialist is ENT
SELECT 
    d.doctor_name, d.qualification, d.designation
FROM
    doctors d
WHERE
    sp_id in (SELECT 
            sp_id
        FROM
            specialists
        WHERE
            specialist_name REGEXP '^Cardiology');
            
#2 Find doctors all information specialist is ENT:
SELECT 
    *
FROM
    doctors_full_information
WHERE
    d_id IN (SELECT 
            d_id
        FROM
            doctors
        WHERE
            sp_id = (SELECT 
                    sp_id
                FROM
                    specialists
                WHERE
                    specialist_name REGEXP '^ENT'));

#3 Find doctor by hospital name 
SELECT 
    *
FROM
    doctors
WHERE
    d_id IN (SELECT 
            d_id
        FROM
            works
        WHERE
            h_id IN (SELECT 
                    h_id
                FROM
                    hospitals
                WHERE
                    hospital_name REGEXP 'LabAid'));
#4. Find doctor using location and specific specialist name:

SELECT 
    doctor_name,
    qualification,
    specialist_name,
    hospital_name,
    address,
    contact,
    Consulting_hour_start,
    Consulting_hour_end,
    Consulting_fees,
    Consulting_days
FROM
    doctors_full_information
WHERE
    specialist_name REGEXP '^Dermatology'
        AND d_id IN (SELECT 
            d_id
        FROM
            doctors
                JOIN
            works USING (d_id)
                JOIN
            hospitals USING (h_id)
        WHERE
            h_id IN (SELECT 
                    h_id
                FROM
                    hospitals
                WHERE
                    hospital_name REGEXP 'Dhanmondi'));
                    
#5. Search doctor by hospital and Specialist. Like Cardiology (Heart) specialist from popular hospital

SELECT 
    d.doctor_name,
    d.qualification,
    d.designation,
    w.Consulting_hour_start,
    w.Consulting_hour_end,
    w.Consulting_fees,
    w.Consulting_days
FROM
    doctors d
        JOIN
    works w USING (d_id)
WHERE
    sp_id = (SELECT 
            sp_id
        FROM
            specialists s
        WHERE
            specialist_name REGEXP '^Cardiology')
        AND h_id IN (SELECT 
            h_id
        FROM
            hospitals h
        WHERE
            hospital_name REGEXP 'popular');
            
#Find symptoms of specific specialist sector. Like cardiologist, ENT
SELECT 
    symptom
FROM
    symptoms
WHERE
    sp_id IN (SELECT 
            sp_id
        FROM
            specialists
        WHERE
            specialist_name REGEXP '^Cardiology');
            
#7. Search doctors by name. Ex. Details of Dr. A.K.M. Nazmus Saquib 

SELECT 
    *
FROM
    doctors_full_information
WHERE
    d_id IN (SELECT 
            d_id
        FROM
            doctors
        WHERE
            doctor_name REGEXP 'Dr. A.K.M. Nazmus Saquib'
                AND sp_id = (SELECT 
                    sp_id
                FROM
                    specialists
                WHERE
                    specialist_name REGEXP '^Eye'));
                    
#8 Is a doctor available or not  available on the specific days in hospital search by doctor name and hospital name.
#Ex: “Professor Dr. M. Nazrul Islam” in “Popular Diagnostic Centre” Hospital is available today.

SELECT 
    IF((SELECT 
                d_id
            FROM
                doctors_full_information
            WHERE
                doctor_name REGEXP 'Professor Dr. M. Nazrul Islam'
                    AND hospital_name REGEXP 'Popular Diagnostic Centre'
                    AND Consulting_days REGEXP (SELECT DAYNAME(CURDATE()))) IS NULL,
        'Not Available today',
        'Available today') AS Status;

#9. Get doctors information on specific specialist and consulting fees low to high. Ex: Specialist “Medicine”
SELECT 
    *
FROM
    doctors_full_information
WHERE
    d_id IN (SELECT 
            d_id
        FROM
            doctors
        WHERE
            sp_id = (SELECT 
                    sp_id
                FROM
                    specialists
                WHERE
                    specialist_name REGEXP '^Medicine'))
ORDER BY Consulting_fees;

#10. Search Which doctors don't work in any hospital.
select *
from doctors
where d_id not in(select d_id from works);

select *
from doctors
right join works using(d_id)
where h_id is null;

#11. Number of doctor’s work in each hospital.

SELECT 
    h.hospital_name, COUNT(w.d_id) AS 'Number Of Doctors'
FROM
    hospitals h
        JOIN
    works w USING (h_id)
GROUP BY h_id;

#12. Find doctors information using “specialist name”, “week days name” and “location”.

SELECT 
    *
FROM
    doctors
WHERE
    sp_id = (SELECT 
            sp_id
        FROM
            specialists
        WHERE
            specialist_name REGEXP '^Cardiology')
        AND d_id IN (SELECT 
            d_id
        FROM
            hospitals
                JOIN
            works USING (h_id)
        WHERE
            address REGEXP 'Dhanmondi'
                AND Consulting_days REGEXP 'Sunday');
                
#13. Find a doctor whose consulting fees low in a specific specialist.

SELECT 
    *
FROM
    doctors_full_information
WHERE
    specialist_name REGEXP '^Cardiology'
        AND Consulting_fees = (SELECT 
            MIN(consulting_fees)
        FROM
            doctors_full_information
        WHERE
            specialist_name REGEXP '^Cardiology');
            
#14. Find top 5 hospital where maximum number of doctor’s work in hospital.
select 
row_number() over(ORDER BY t.Number_of_Doctors DESC) as 'Row Number',
t.hospital_name,
t.Number_of_Doctors
from (
SELECT 
    hospital_name, COUNT(d_id) AS Number_of_Doctors
FROM
    hospitals h
        JOIN
    works w USING (h_id)
GROUP BY h_id
ORDER BY Number_of_Doctors DESC
LIMIT 5) as t;

#15. Find doctors on basis of given symptoms. If symptoms are not match with any specialist name then show  medicine specialist doctors
SELECT 
    *
FROM
    doctors
WHERE
    sp_id = (SELECT 
            IFNULL((SELECT 
                                x.sp_id
                            FROM
                                (SELECT 
                                    sp_id, COUNT(sp_id) AS c
                                FROM
                                    symptoms
                                WHERE
                                    symptom REGEXP 'Bose bleed|Sculling on ulcer in the mouth|Coughing|Headaches|Irregular periods|A fast heart beat'
                                GROUP BY sp_id
                                ORDER BY c DESC
                                LIMIT 1) AS x),
                        'sp_010')
        );