CREATE TABLE [dbo].[ApiConsumerApp] (
    [ApiConsumerAppID]            INT              IDENTITY (1, 1) NOT NULL,
    [ApiConsumerAppMultiTenantID] INT              NULL,
    [ApiConsumerSecret]           UNIQUEIDENTIFIER CONSTRAINT [DF_ApiConsumerApp_ApiConsumerSecret] DEFAULT (newid()) NOT NULL,
    [AppName]                     VARCHAR (200)    NOT NULL,
    [AppVersion]                  VARCHAR (50)     NULL,
    [HomePageURI]                 VARCHAR (255)    NULL,
    [DownloadURI]                 VARCHAR (255)    NULL,
    [ContactEmail]                VARCHAR (100)    NOT NULL,
    [IntendedUse]                 VARCHAR (2000)   NULL,
    [IsEnabled]                   BIT              CONSTRAINT [DF_ApiConsumerApp_IsEnabled] DEFAULT ((1)) NOT NULL,
    [CreatedDate]                 DATETIME         CONSTRAINT [DF_ApiConsumerApp_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                   INT              CONSTRAINT [DF_ApiConsumerApp_CreatedBy] DEFAULT ((0)) NOT NULL,
    [LastUpdatedDate]             DATETIME         NULL,
    [LastUpdatedBy]               INT              NULL,
    CONSTRAINT [PK_ApiConsumerApp] PRIMARY KEY CLUSTERED ([ApiConsumerAppID] ASC) WITH (FILLFACTOR = 90)
);

