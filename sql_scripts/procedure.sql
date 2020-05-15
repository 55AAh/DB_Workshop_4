/*
DROP PROCEDURE RemoveCompanyManager;
*/

CREATE OR REPLACE PROCEDURE
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