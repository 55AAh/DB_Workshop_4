CREATE OR REPLACE PACKAGE
    workshop_4_proc_func
AS
    PROCEDURE
        RemoveCompanyManager
        (
            company_name IN Company.name % TYPE,
            manager_name IN Human.name   % TYPE
        );

    FUNCTION
        tf_get_comp_dep_satisf_Empl
    (
        company_name Company.name % TYPE,
        department_name Department.name %TYPE
    )
    RETURN
        t_tf_Employee_name_pos_tbl
    PIPELINED;
END workshop_4_proc_func;
/

CREATE OR REPLACE PACKAGE
BODY
    workshop_4_proc_func
AS
    PROCEDURE
        RemoveCompanyManager
    (
        company_name IN Company.name % TYPE,
        manager_name IN Human.name   % TYPE
    )
    AS
        company_id Company.company_id % TYPE;
        human_id   Human.human_id     % TYPE;
        BEGIN
            DBMS_OUTPUT.enable;
            SELECT
                Company.company_id,
                Human.human_id
                INTO
                    company_id,
                    human_id
            FROM
                Manager_Company
                JOIN Company
                    ON Manager_Company.Company_company_id = Company.company_id
                JOIN Human
                    ON Manager_Company.Human_human_id = Human.human_id
            WHERE
                TRIM(Company.name) = TRIM(company_name)
                AND TRIM(Human.name) = TRIM(manager_name);
            
            DELETE FROM
                Manager_Company
            WHERE
                Company_company_id = company_id
                AND Human_human_id = human_id;
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.put_line('Error - more than one manager matches specified criteria!');
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.put_line('Error - none of the managers are matching specified criteria!');
            WHEN OTHERS THEN                     
                DBMS_OUTPUT.PUT_LINE('Unknown exception with code ' || SQLCODE ||' occured: ' || SQLERRM);
    END RemoveCompanyManager;
    
    FUNCTION
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
END workshop_4_proc_func;