/*
DROP FUNCTION tf_get_comp_dep_satisf_Empl;
DROP TYPE t_tf_Employee_name_pos_tbl;
DROP TYPE t_tf_Employee_name_pos_row;
DROP VIEW ActiveEmployee;
*/

CREATE OR REPLACE VIEW
	ActiveEmployee
AS
SELECT
    Human_human_id AS human_id,
    Company_company_id AS company_id,
    Department_department_id AS department_id,
    EmplPos_position_id AS position_id,
    PerfScore_pscore_id AS pscore_id,
    empl_satisfaction
FROM
	Empl
    JOIN EmplStatus
        ON Empl.EmplStatus_estatus_id = EmplStatus.estatus_id
WHERE
    TRIM(EmplStatus.status) = 'Active';

CREATE OR REPLACE TYPE
    t_tf_Employee_name_pos_row
IS OBJECT
(
    name     VARCHAR2(100),
    position VARCHAR2(100)
);
/

CREATE OR REPLACE TYPE
    t_tf_Employee_name_pos_tbl
IS TABLE OF
    t_tf_Employee_name_pos_row;
/

CREATE OR REPLACE FUNCTION
    tf_get_comp_dep_satisf_Empl
(
    company_name Company.name % TYPE,
    department_name Department.name %TYPE
)
RETURN
    t_tf_Employee_name_pos_tbl
PIPELINED AS
    employee_name         VARCHAR2(100);
    employee_position     VARCHAR2(100);
    employee_satisfaction NUMBER(1,0);
    CURSOR
        employee_cursor
    IS
        SELECT
            TRIM(Human.name) AS name,
            TRIM(EmplPos.name) AS position,
            ActiveEmployee.empl_satisfaction AS satisfaction
        FROM
            ActiveEmployee
            JOIN Company
                ON ActiveEmployee.company_id = Company.company_id
            JOIN Department
                ON ActiveEmployee.department_id = Department.department_id
            JOIN Human
                ON ActiveEmployee.human_id = Human.human_id
            JOIN EmplPos
                ON ActiveEmployee.position_id = EmplPos.position_id
            WHERE
                TRIM(Company.name) = TRIM(company_name)
                AND TRIM(Department.name) = TRIM(department_name);
    BEGIN
        OPEN
            employee_cursor;
        LOOP
            FETCH
                employee_cursor
            INTO
                employee_name, employee_position, employee_satisfaction;
            EXIT WHEN
                employee_cursor % NOTFOUND;
            IF employee_satisfaction = 5
            THEN
                PIPE ROW(
                    t_tf_Employee_name_pos_row(
                        employee_name,
                        employee_position
                    )
                );
            END IF;
        END LOOP;    
END tf_get_comp_dep_satisf_Empl;
/