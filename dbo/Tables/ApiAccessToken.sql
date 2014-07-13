CREATE TABLE [dbo].[ApiAccessToken] (
    [ApiAccessTokenID]  INT              IDENTITY (1, 1) NOT NULL,
    [MultiTenantID]     INT              NULL,
    [MultiTenantUserID] INT              NULL,
    [ApiRequestTokenID] INT              NOT NULL,
    [ApiConsumerAppID]  INT              NOT NULL,
    [Token]             UNIQUEIDENTIFIER NOT NULL,
    [TokenSecret]       UNIQUEIDENTIFIER NOT NULL,
    [IsEnabled]         BIT              NOT NULL,
    [ExpirationDate]    DATETIME         NOT NULL,
    [CreatedDate]       DATETIME         CONSTRAINT [DF_ApiAccessToken_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         INT              CONSTRAINT [DF_ApiAccessToken_CreatedBy] DEFAULT ((0)) NULL,
    [LastUpdatedDate]   DATETIME         NULL,
    [LastUpdatedBy]     INT              NULL,
    CONSTRAINT [PK_ApiAccessToken] PRIMARY KEY CLUSTERED ([ApiAccessTokenID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ApiAccessToken_ApiConsumerApp] FOREIGN KEY ([ApiConsumerAppID]) REFERENCES [dbo].[ApiConsumerApp] ([ApiConsumerAppID]),
    CONSTRAINT [FK_ApiAccessToken_ApiRequestToken] FOREIGN KEY ([ApiRequestTokenID]) REFERENCES [dbo].[ApiRequestToken] ([ApiRequestTokenID])
);

