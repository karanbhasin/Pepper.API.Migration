CREATE TABLE [dbo].[ApiNonce] (
    [ApiNonceID]       INT           IDENTITY (1, 1) NOT NULL,
    [ApiConsumerAppID] INT           NOT NULL,
    [ApiAccessTokenID] INT           NOT NULL,
    [NonceHash]        VARCHAR (50)  NOT NULL,
    [RequestURI]       VARCHAR (500) NOT NULL,
    [CreatedDate]      DATETIME      CONSTRAINT [DF_ApiNonce_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        INT           CONSTRAINT [DF_ApiNonce_CreatedBy] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ApiNonce] PRIMARY KEY CLUSTERED ([ApiNonceID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ApiNonce_ApiAccessToken] FOREIGN KEY ([ApiAccessTokenID]) REFERENCES [dbo].[ApiAccessToken] ([ApiAccessTokenID]),
    CONSTRAINT [FK_ApiNonce_ApiConsumerApp] FOREIGN KEY ([ApiConsumerAppID]) REFERENCES [dbo].[ApiConsumerApp] ([ApiConsumerAppID]),
    CONSTRAINT [IX_NonceHash] UNIQUE NONCLUSTERED ([NonceHash] ASC, [ApiConsumerAppID] ASC) WITH (FILLFACTOR = 90)
);

