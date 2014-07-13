CREATE TABLE [dbo].[ApiLog] (
    [ApiLogID]        INT              IDENTITY (1, 1) NOT NULL,
    [TraceID]         UNIQUEIDENTIFIER NOT NULL,
    [HttpMethod]      VARCHAR (10)     NOT NULL,
    [RequestUri]      VARCHAR (50)     NOT NULL,
    [IPAddress]       VARCHAR (50)     NULL,
    [RequestBody]     VARCHAR (500)    NULL,
    [RequestHeaders]  VARCHAR (500)    NULL,
    [StatusCode]      INT              NULL,
    [ResponseMessage] VARCHAR (250)    NULL,
    [ResponseHeaders] VARCHAR (500)    NULL,
    [EntityID]        INT              NULL,
    [UserID]          INT              NULL,
    [ConsumerKey]     INT              NULL,
    [CreatedDate]     DATETIME         CONSTRAINT [DF_ApiLog_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [EndDate]         DATETIME         NULL,
    [RequestTime]     INT              CONSTRAINT [DF_ApiLog_RequestTime] DEFAULT ((0)) NULL,
    [Success]         BIT              CONSTRAINT [DF_ApiLog_Success] DEFAULT ((1)) NOT NULL,
    [ErrorLogID]      UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_ApiLog] PRIMARY KEY CLUSTERED ([ApiLogID] ASC)
);

