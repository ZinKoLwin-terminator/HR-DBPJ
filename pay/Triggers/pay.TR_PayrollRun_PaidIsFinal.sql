-- A paid payroll run is final: it cannot be changed or deleted.
CREATE TRIGGER [pay].[TR_PayrollRun_PaidIsFinal]
ON [pay].[PayrollRun]
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM deleted WHERE [Status] = 'Paid')
        THROW 51001, N'A paid payroll run is final and cannot be changed or deleted.', 1;
END;
