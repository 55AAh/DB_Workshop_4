SET SERVEROUTPUT ON;


BEGIN
    DBMS_OUTPUT.enable();
    DBMS_OUTPUT.put_line('PROCEDURE TEST');
    DBMS_OUTPUT.put_line('Adding test data...');
    INSERT INTO Human VALUES (100001, 'Manager Bob', 1);
    INSERT INTO Human VALUES (100002, 'Manager Boba', 1);
    INSERT INTO Human VALUES (100003, 'Manager Biba', 1);
    INSERT INTO Human VALUES (100004, 'Manager Boban', 1);
    INSERT INTO Human VALUES (100005, 'Manager Boban', 1);
    INSERT INTO Company VALUES (100001, 'Google');
    INSERT INTO Company VALUES (100002, 'Apple');
    INSERT INTO Company VALUES (100003, 'Amazon');
    INSERT INTO Company VALUES (100004, 'Amazon');
    INSERT INTO Company VALUES (100005, 'Microsoft');
    INSERT INTO Manager_Company VALUES (100001, 100001);
    INSERT INTO Manager_Company VALUES (100002, 100002);
    INSERT INTO Manager_Company VALUES (100003, 100003);
    INSERT INTO Manager_Company VALUES (100003, 100004);
    INSERT INTO Manager_Company VALUES (100004, 100005);
    INSERT INTO Manager_Company VALUES (100005, 100005);
    DBMS_OUTPUT.put_line('Trying to delete from unexisting company...');
    RemoveCompanyManager('Samsung', 'Manager Bob');
    DBMS_OUTPUT.put_line('Trying to delete unexisting manager...');
    RemoveCompanyManager('Google', 'Manager Beba');
    DBMS_OUTPUT.put_line('Trying to delete existing manager from existing, but mismatching company...');
    RemoveCompanyManager('Google', 'Boban');
    DBMS_OUTPUT.put_line('Trying to delete valid manager from controversial (duplicate) company...');
    RemoveCompanyManager('Amazon', 'Manager Biba');
    DBMS_OUTPUT.put_line('Trying to delete controversial (duplicate) manager from valid company...');
    RemoveCompanyManager('Microsoft', 'Manager Boban');
    DBMS_OUTPUT.put_line('Finally, trying to remove two valid managers...');
    RemoveCompanyManager('Google', 'Manager Bob');
    RemoveCompanyManager('Apple', 'Manager Boba');
    DBMS_OUTPUT.put_line('No errors, as expected');
    DBMS_OUTPUT.put_line('Deleting test data...');
    DELETE FROM Manager_Company WHERE
        Human_human_id = 100003 OR Human_human_id = 100004 OR Human_human_id = 100005;
    DELETE FROM Company WHERE
        company_id >= 100001 AND company_id <= 100005;
    DELETE FROM Human WHERE
        human_id >= 100001 AND human_id <= 100005;
    DBMS_OUTPUT.put_line('Test data deleted');
END;
/

DECLARE
    test_chunk_size      NUMBER        := 100;
    test_chunk_offset    NUMBER        := 100000;
    test_company_name    VARCHAR2(100) := 'Diversity Job Fair';
    test_department_name VARCHAR2(100) := 'Admin Offices';
BEGIN
    DBMS_OUTPUT.enable();
    
    DBMS_OUTPUT.put_line('PIPELINED FUNCTION TEST');
    DBMS_OUTPUT.put_line('Inserting test data (' || test_chunk_size || ' row(s))...');
    FOR i IN 1..test_chunk_size LOOP
        INSERT INTO Human VALUES(test_chunk_offset + i, 'Bob#' || i, 1);
        INSERT INTO Empl VALUES(test_chunk_offset + i, 
            MOD(FLOOR((i-1)/(SELECT COUNT(*) FROM Department)), (SELECT COUNT(*) FROM Company)) + 1,
            MOD(i-1, (SELECT COUNT(*) FROM Department)) + 1,
            MOD(FLOOR(i/10), (SELECT COUNT(*) FROM EmplPos)) + 1,
            1, 3, 5);    
    END LOOP;
    DBMS_OUTPUT.put_line('Test data inserted');

    DBMS_OUTPUT.put_line('Performing query with pipelined function...');
    DBMS_OUTPUT.put_line('Here are the list of all satisfied active employee working in ' ||
        TRIM(test_company_name) || ', ' || TRIM(test_department_name) || ':');
    DECLARE
        employee_name VARCHAR2(100);
        employee_position VARCHAR2(100);
        CURSOR employee_cursor IS
        SELECT 
            name,
            position
        FROM
            TABLE(
                tf_get_comp_dep_satisf_Empl(TRIM(test_company_name),  TRIM(test_department_name))
            );
    BEGIN
        OPEN
            employee_cursor;
        LOOP
            FETCH
                employee_cursor
            INTO
                employee_name, employee_position;
            EXIT WHEN
                employee_cursor % NOTFOUND;
            DBMS_OUTPUT.put_line(employee_name || ' (' || employee_position || ')');
        END LOOP;
        CLOSE
            employee_cursor;
    END;
    DBMS_OUTPUT.put_line('Query finished');
    
    DBMS_OUTPUT.put_line('Deleting test data...');
    FOR i IN 1..test_chunk_size LOOP
        DELETE FROM Empl WHERE Human_human_id = test_chunk_offset + i;
        DELETE FROM Human WHERE human_id = test_chunk_offset + i;
    END LOOP;
    DBMS_OUTPUT.put_line('Test data deleted');
END;