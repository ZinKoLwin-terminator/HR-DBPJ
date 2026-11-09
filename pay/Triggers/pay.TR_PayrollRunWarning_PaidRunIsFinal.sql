-- Processing warnings of a paid run cannot be added, changed or removed.
CREATE TRIGGER [pay].[TR_PayrollRunWarning_PaidRunIsFinal]
ON [pay].[PayrollRunWarning]
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
        THROW 51004, N'Warnings of a paid payroll run are final.', 1;
END;
