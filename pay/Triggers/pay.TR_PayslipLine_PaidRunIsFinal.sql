-- Payslip lines of a paid run cannot be added, changed or removed.
CREATE TRIGGER [pay].[TR_PayslipLine_PaidRunIsFinal]
ON [pay].[PayslipLine]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM (SELECT [PayslipId] FROM inserted
              UNION
              SELECT [PayslipId] FROM deleted) AS c
        JOIN [pay].[Payslip] AS p ON p.[Id] = c.[PayslipId]
        JOIN [pay].[PayrollRun] AS r ON r.[Id] = p.[PayrollRunId]
        WHERE r.[Status] = 'Paid')
        THROW 51003, N'Payslip lines of a paid payroll run are final.', 1;
END;
