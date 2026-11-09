-- Application account. Holds no credentials: authentication is designed separately.
CREATE TABLE [sec].[AppUser]
(
    [Id]               int            IDENTITY (1, 1) NOT NULL,
    -- NULL only for the built-in administrator account, which is linked to no employee.
    [EmployeeId]       int            NULL,
    -- Copied from the linked employee on save.
    [DisplayName]      nvarchar(130)  NOT NULL,
    [Email]            nvarchar(120)  NOT NULL,
    [RoleId]           int            NOT NULL,
    [Status]           varchar(30)    NOT NULL CONSTRAINT [DF_AppUser_Status] DEFAULT ('Active'),
    [LastLoginAtUtc]   datetime2(3)   NULL,
    [CreatedAtUtc]     datetime2(3)   NOT NULL CONSTRAINT [DF_AppUser_CreatedAtUtc] DEFAULT (SYSUTCDATETIME()),
    [CreatedByUserId]  int            NULL,
    [ModifiedAtUtc]    datetime2(3)   NOT NULL CONSTRAINT [DF_AppUser_ModifiedAtUtc] DEFAULT (SYSUTCDATETIME()),
    [ModifiedByUserId] int            NULL,
    [RowVersion]       rowversion     NOT NULL,
    CONSTRAINT [PK_AppUser] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_AppUser_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [hr].[Employee] ([Id]),
    CONSTRAINT [FK_AppUser_Role] FOREIGN KEY ([RoleId]) REFERENCES [sec].[Role] ([Id]),
    CONSTRAINT [CK_AppUser_Status] CHECK ([Status] IN ('Active', 'Inactive', 'Locked'))
);
GO

-- One user account per employee; the built-in administrator (EmployeeId NULL) is exempt.
CREATE UNIQUE NONCLUSTERED INDEX [UQ_AppUser_EmployeeId]
    ON [sec].[AppUser] ([EmployeeId])
    WHERE [EmployeeId] IS NOT NULL;
GO

CREATE NONCLUSTERED INDEX [IX_AppUser_RoleId] ON [sec].[AppUser] ([RoleId]) INCLUDE ([Status]);
