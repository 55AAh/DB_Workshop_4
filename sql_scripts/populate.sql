/*
DELETE FROM Empl_TermReason;
DELETE FROM TermReason;
DELETE FROM Empl_Manager;
DELETE FROM Empl;
DELETE FROM EmplStatus;
DELETE FROM PerfScore;
DELETE FROM EmplPos;
DELETE FROM Department;
DELETE FROM Manager_Company;
DELETE FROM Company;
DELETE FROM Human_ZipCode;
DELETE FROM ZipCode;
DELETE FROM StateInfo;
DELETE FROM Human;
DELETE FROM MrtStatus;
*/

INSERT INTO MrtStatus (mstatus_id, status) VALUES (1, 'Single');
INSERT INTO MrtStatus (mstatus_id, status) VALUES (2, 'Married');
INSERT INTO MrtStatus (mstatus_id, status) VALUES (3, 'Divorced');

INSERT INTO Human (human_id, name, MrtStatus_mstatus_id) VALUES (1, 'Bob', 1);
INSERT INTO Human (human_id, name, MrtStatus_mstatus_id) VALUES (2, 'Boba', 2);
INSERT INTO Human (human_id, name, MrtStatus_mstatus_id) VALUES (3, 'Boban', 3);

INSERT INTO StateInfo (state_id, name) VALUES (1, 'MA');
INSERT INTO StateInfo (state_id, name) VALUES (2, 'VA');
INSERT INTO StateInfo (state_id, name) VALUES (3, 'VT');

INSERT INTO ZipCode (zipcode, StateInfo_state_id) VALUES (01013, 1);
INSERT INTO ZipCode (zipcode, StateInfo_state_id) VALUES (01040, 1);
INSERT INTO ZipCode (zipcode, StateInfo_state_id) VALUES (21851, 2);

INSERT INTO Human_ZipCode(Human_human_id, ZipCode_zipcode) VALUES (1, 01013);
INSERT INTO Human_ZipCode(Human_human_id, ZipCode_zipcode) VALUES (2, 01013);
INSERT INTO Human_ZipCode(Human_human_id, ZipCode_zipcode) VALUES (3, 21851);

INSERT INTO Company(company_id, name) VALUES (1, 'Diversity Job Fair');
INSERT INTO Company(company_id, name) VALUES (2, 'Website Banner Ads');
INSERT INTO Company(company_id, name) VALUES (3, 'Internet Search');

INSERT INTO Manager_Company(Human_human_id, Company_company_id) VALUES (1, 1);
INSERT INTO Manager_Company(Human_human_id, Company_company_id) VALUES (2, 2);
INSERT INTO Manager_Company(Human_human_id, Company_company_id) VALUES (3, 3);

INSERT INTO Department (department_id, name) VALUES (1, 'Admin Offices');
INSERT INTO Department (department_id, name) VALUES (2, 'Executive Office');
INSERT INTO Department (department_id, name) VALUES (3, 'IT/IS');

INSERT INTO EmplPos (position_id, name) VALUES (1, 'Accountant I');
INSERT INTO EmplPos (position_id, name) VALUES (2, 'Administrative Assistant');
INSERT INTO EmplPos (position_id, name) VALUES (3, 'Area Sales Manager');

INSERT INTO PerfScore (pscore_id, score) VALUES (1, 'PIP');
INSERT INTO PerfScore (pscore_id, score) VALUES (2, 'Needs Improvement');
INSERT INTO PerfScore (pscore_id, score) VALUES (3, 'Fully Meets');

INSERT INTO EmplStatus (estatus_id, status) VALUES (1, 'Active');
INSERT INTO EmplStatus (estatus_id, status) VALUES (2, 'Future Start');
INSERT INTO EmplStatus (estatus_id, status) VALUES (3, 'Leave of Absence');

INSERT INTO Empl (Human_human_id, Company_company_id, Department_department_id, EmplPos_position_id, EmplStatus_estatus_id, PerfScore_pscore_id, empl_satisfaction)
    VALUES (1, 1, 1, 2, 3, 1, 5);
INSERT INTO Empl (Human_human_id, Company_company_id, Department_department_id, EmplPos_position_id, EmplStatus_estatus_id, PerfScore_pscore_id, empl_satisfaction)
    VALUES (2, 1, 2, 3, 3, 2, 4);
INSERT INTO Empl (Human_human_id, Company_company_id, Department_department_id, EmplPos_position_id, EmplStatus_estatus_id, PerfScore_pscore_id, empl_satisfaction)
    VALUES (3, 1, 3, 1, 3, 3, 3);

INSERT INTO Empl_Manager(Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Human_human_id)
    VALUES (2, 1, 2, 3, 1);
INSERT INTO Empl_Manager(Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Human_human_id)
    VALUES (3, 1, 3, 1, 1);
INSERT INTO Empl_Manager(Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Human_human_id)
    VALUES (3, 1, 3, 1, 2);

INSERT INTO TermReason (treason_id, reason) VALUES (1, 'unknown');
INSERT INTO TermReason (treason_id, reason) VALUES (2, 'career change');
INSERT INTO TermReason (treason_id, reason) VALUES (3, 'Another position');

INSERT INTO Empl_TermReason (Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Termreason_treason_id)
    VALUES (2, 1, 2, 3, 1);
INSERT INTO Empl_TermReason (Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Termreason_treason_id)
    VALUES (3, 1, 3, 1, 2);
INSERT INTO Empl_TermReason (Empl_Human_human_id, Empl_Company_company_id, Empl_Department_department_id, Empl_EmplPos_position_id, Termreason_treason_id)
    VALUES (3, 1, 3, 1, 3);