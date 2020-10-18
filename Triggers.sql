#DOCTORS table

DELIMITER $$
DROP TRIGGER IF EXISTS insert_on_doctors;
create trigger insert_on_doctors
after insert on doctors 
for each row
begin
	call fyd_audit_table('doctors',new.d_id,new.doctor_name,'Insert',now(),current_user());
end $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS update_on_doctors;
create trigger update_on_doctors
after update on doctors 
for each row
begin
	call fyd_audit_table('doctors',new.d_id,new.doctor_name,'Update',now(),current_user());
end $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS delete_on_doctors;
create trigger delete_on_doctors
after delete on doctors 
for each row
begin
	call fyd_audit_table('doctors',old.d_id,old.doctor_name,'Delete',now(),current_user());
end $$
DELIMITER ;

#hospitals table

DELIMITER $$
DROP TRIGGER IF EXISTS insert_on_hospitals;
create trigger insert_on_hospitals
after insert on hospitals 
for each row
begin
	call fyd_audit_table('hospitals',new.h_id,new.hospital_name,'Insert',now(),current_user());
end $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS update_on_hospitals;
create trigger update_on_hospitals
after update on hospitals 
for each row
begin
	call fyd_audit_table('hospitals',new.h_id,new.hospital_name,'Update',now(),current_user());
end $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS delete_on_hospitals;
create trigger delete_on_hospitals
after delete on hospitals 
for each row
begin
	call fyd_audit_table('hospitals',old.h_id,old.hospital_name,'Delete',now(),current_user());
end $$
DELIMITER ;

#specialists table

DELIMITER $$
DROP TRIGGER IF EXISTS insert_on_specialists;
create trigger insert_on_specialists
after insert on specialists 
for each row
begin
	call fyd_audit_table('specialists',new.sp_id,new.specialist_name,'Insert',now(),current_user());
end $$
DELIMITER;

DELIMITER $$
DROP TRIGGER IF EXISTS update_on_specialists;
create trigger update_on_specialists
after update on specialists 
for each row
begin
	call fyd_audit_table('specialists',new.sp_id,new.specialist_name,'Update',now(),current_user());
end $$
DELIMITER;

DELIMITER $$
DROP TRIGGER IF EXISTS delete_on_specialists;
create trigger delete_on_specialists
after delete on specialists 
for each row
begin
	call fyd_audit_table('specialists',old.sp_id,old.specialist_name,'Delete',now(),current_user());
end $$
DELIMITER ;

#symptoms table

DELIMITER $$
DROP TRIGGER IF EXISTS insert_on_symptoms;
create trigger insert_on_symptoms
after insert on symptoms 
for each row
begin
	call fyd_audit_table('symptoms',new.sm_id,new.symptom,'Insert',now(),current_user());
end $$
DELIMITER;

DELIMITER $$
DROP TRIGGER IF EXISTS update_on_symptoms;
create trigger update_on_symptoms
after update on symptoms 
for each row
begin
	call fyd_audit_table('symptoms',new.sm_id,new.symptom,'Update',now(),current_user());
end $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS delete_on_symptoms;
create trigger delete_on_symptoms
after delete on symptoms 
for each row
begin
	call fyd_audit_table('symptoms',old.sm_id,old.symptom,'Delete',now(),current_user());
end $$
DELIMITER ;