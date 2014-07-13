CREATE TABLE [dbo].[ApiRequestToken] (
    [ApiRequestTokenID] INT              IDENTITY (1, 1) NOT NULL,
    [ApiConsumerAppID]  INT              NOT NULL,
    [Token]             UNIQUEIDENTIFIER NOT NULL,
    [TokenSecret]       UNIQUEIDENTIFIER NOT NULL,
    [IsEnabled]         BIT              NOT NULL,
    [ExpirationDate]    DATETIME         NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF_ApiRequestToken_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         INT              NOT NULL,
    [LastUpdatedDate]   DATETIME         NULL,
    [LastUpdatedBy]     INT              NULL,
    CONSTRAINT [PK_ApiRequestToken] PRIMARY KEY CLUSTERED ([ApiRequestTokenID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ApiRequestToken_ApiConsumerApp] FOREIGN KEY ([ApiConsumerAppID]) REFERENCES [dbo].[ApiConsumerApp] ([ApiConsumerAppID])
);

