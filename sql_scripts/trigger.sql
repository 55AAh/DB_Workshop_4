/*
DROP TRIGGER trg_Empl_leave_del;
*/

CREATE OR REPLACE TRIGGER
    trg_Empl_leave_del
FOR DELETE ON
    Empl
COMPOUND TRIGGER
    TYPE t_empl_leave_row IS RECORD (
        human_id          NUMBER,
        company_id        Empl.Company_company_id % TYPE,
        department_id     Empl.Department_department_id % TYPE,
        position_id       Empl.EmplPos_position_id % TYPE,
        pscore_id         Empl.PerfScore_pscore_id % TYPE,
        empl_satisfaction Empl.empl_satisfaction % TYPE
    );
    
    TYPE t_empl_leave_tbl IS TABLE OF t_empl_leave_row INDEX BY PLS_INTEGER;
    
    empl_leave_tbl t_empl_leave_tbl;
    
    empl_leave_status VARCHAR2(30) := 'Leave of Absence';
    
    empl_leave_estatus_id EmplStatus.estatus_id % TYPE;
    
    BEFORE STATEMENT IS
    BEGIN
        SELECT
            estatus_id
        INTO
            empl_leave_estatus_id
        FROM
            EmplStatus
        WHERE
            TRIM(status) = empl_leave_status;
    END BEFORE STATEMENT;
    
    AFTER EACH ROW IS
    BEGIN
        empl_leave_tbl (empl_leave_tbl.COUNT + 1).human_id := :OLD.Human_human_id;
        empl_leave_tbl (empl_leave_tbl.COUNT).company_id := :OLD.Company_company_id;
        empl_leave_tbl (empl_leave_tbl.COUNT).department_id := :OLD.Department_department_id;
        empl_leave_tbl (empl_leave_tbl.COUNT).position_id := :OLD.EmplPos_position_id;
        empl_leave_tbl (empl_leave_tbl.COUNT).pscore_id := :OLD.PerfScore_pscore_id;
        empl_leave_tbl (empl_leave_tbl.COUNT).empl_satisfaction := :OLD.empl_satisfaction;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. empl_leave_tbl.COUNT
        LOOP
            INSERT INTO Empl
            (
                Human_human_id,
                Company_company_id,
                Department_department_id,
                EmplPos_position_id,
                EmplStatus_estatus_id,
                PerfScore_pscore_id,
                empl_satisfaction
            )
            VALUES
            (
                empl_leave_tbl(i).human_id,
                empl_leave_tbl(i).company_id,
                empl_leave_tbl(i).department_id,
                empl_leave_tbl(i).position_id,
                empl_leave_estatus_id,
                empl_leave_tbl(i).pscore_id,
                empl_leave_tbl(i).empl_satisfaction
            );
        END LOOP;
    END AFTER STATEMENT;
END trg_Empl_leave_del;