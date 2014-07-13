CREATE TABLE [dbo].[ApiConsumerAppAccessForEntity] (
    [ApiConsumerAppAccessForEntityID] INT      IDENTITY (1, 1) NOT NULL,
    [MultiTenantID]                   INT      NOT NULL,
    [ApiConsumerAppID]                INT      NOT NULL,
    [IsEnabled]                       BIT      NOT NULL,
    [AppLastUsedDate]                 DATETIME NULL,
    [CreatedDate]                     DATETIME CONSTRAINT [DF_ApiConsumerAppAccessForEntity_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                       INT      CONSTRAINT [DF_ApiConsumerAppAccessForEntity_CreatedBy] DEFAULT ((0)) NOT NULL,
    [LastUpdatedDate]                 DATETIME NULL,
    [LastUpdatedBy]                   INT      NULL,
    CONSTRAINT [PK_ApiConsumerAppAccessForEntity] PRIMARY KEY CLUSTERED ([ApiConsumerAppAccessForEntityID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ApiConsumerAppAccessForEntity_ApiConsumerApp] FOREIGN KEY ([ApiConsumerAppID]) REFERENCES [dbo].[ApiConsumerApp] ([ApiConsumerAppID])
);

