SET SERVEROUTPUT ON;

CREATE PROCEDURE
    print_empl_left_count
    (
        test_chunk_offset IN NUMBER,
        test_chunk_size IN NUMBER
    )
    AS
        total_count NUMBER;
        marked_count NUMBER;
        empl_leave_status VARCHAR2(30) := 'Leave of Absence';
    BEGIN
        SELECT
            COUNT(*)
        INTO
            total_count
        FROM
            Empl
        WHERE
            Human_human_id > test_chunk_offset AND Human_human_id <= test_chunk_offset + test_chunk_size;
        
        SELECT
            COUNT(*)
        INTO
            marked_count
        FROM
            Empl
            JOIN EmplStatus
                ON Empl.EmplStatus_estatus_id = EmplStatus.estatus_id
        WHERE
            Human_human_id > test_chunk_offset AND Human_human_id <= test_chunk_offset + test_chunk_size
            AND TRIM(EmplStatus.status) = empl_leave_status;
        DBMS_OUTPUT.put_line('We now have ' || total_count || ' test record(s), marked as left: ' || marked_count);
    END;
/
DECLARE
    test_chunk_size   NUMBER       := 100;
    test_chunk_offset NUMBER       := 100000;
BEGIN
    DBMS_OUTPUT.enable();
    print_empl_left_count(test_chunk_offset, test_chunk_size);
    
    DBMS_OUTPUT.put_line('Inserting test data (' || test_chunk_size || ' record(s))...');
    FOR i IN 1..test_chunk_size LOOP
        INSERT INTO Human VALUES (test_chunk_offset + i, 'Bob#' || i, 1);
        INSERT INTO Empl VALUES (test_chunk_offset + i, 1, 1, 1, 1, MOD(i, 3) + 1, 5);
    END LOOP;
    
    print_empl_left_count(test_chunk_offset, test_chunk_size);
    
    DBMS_OUTPUT.put_line('Enabling trigger and trying to delete first half of the records...');
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_Empl_leave_del ENABLE';
    DELETE FROM
        Empl
    WHERE
        Human_human_id > test_chunk_offset AND Human_human_id <= test_chunk_offset + FLOOR(test_chunk_size / 2);
    
    print_empl_left_count(test_chunk_offset, test_chunk_size);
    
    DBMS_OUTPUT.put_line('Deleting test data (under disabled trigger)...');
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_Empl_leave_del DISABLE';
    FOR i IN 1..test_chunk_size LOOP
        DELETE FROM Empl WHERE Human_human_id = test_chunk_offset + i;
        DELETE FROM Human WHERE human_id = test_chunk_offset + i;
    END LOOP;
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_Empl_leave_del ENABLE';
    
    print_empl_left_count(test_chunk_offset, test_chunk_size);
END;
/
DROP PROCEDURE print_empl_left_count;

DELETE FROM Empl WHERE Human_human_id = 100001;
--DELETE FROM Human WHERE human_id = 100001;