-- Payslips of a paid run cannot be added, changed or removed.
CREATE TRIGGER [pay].[TR_Payslip_PaidRunIsFinal]
ON [pay].[Payslip]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM (SELECT [PayrollRunId] FROM inserted
              UNION
              SELECT [PayrollRunId] FROM deleted) AS c
        JOIN [pay].[PayrollRun] AS r ON r.[Id] = c.[PayrollRunId]
        WHERE r.[Status] = 'Paid')
        THROW 51002, N'Payslips of a paid payroll run are final.', 1;
END;
