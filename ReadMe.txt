Initial schema created using Pepper.API.Migration database. we can treat this database as our PROD db
Initial snapshot(snapshot 1) created Pepper.API.Migration_20140711_11-23-20.dacpac

Then we probably would like to move this prod database to DEV environment. NOTE that the DEV database is not created yet. After running the following command, the database is created on the target machine
deploysqldac.exe /t:"Data Source=(local);Integrated Security=SSPI;Trusted_Connection=True;" /d:Pepper.API.Migration.DEV /f:"C:\DummyProjects\SSDT\Pepper.API.Migration\Snapshots\Pepper.API.Migration_20140711_11-23-20.dacpac" /o:5

At this point the PROD and the DEV databases are in sync.

Now lets assume that we want to make some changes to the DEV database. How do we move those changes to PROD.
There a couple of options
a) Modify the Schema in the project(that will make it out of sync with snapshot 1), then take a snapshot(snapshot 2) Pepper.API.Migration_20140711_12-52-23.dacpac. You can also just build the project that will generate a dacpac inside the bin folder, which you can then
move to the snapshots folder. Now the schema is in sync with snapshot 2.
Deploy that snapshot to DEV(because you have not yet made changes to the server, just the schema) and PROD
NOTE: If you compare snapshot 1 and snapshot 2, you should see the changes that you are about to make.
deploysqldac.exe /t:"Data Source=(local);Integrated Security=SSPI;Trusted_Connection=True;" /d:Pepper.API.Migration.DEV /f:"C:\DummyProjects\SSDT\Pepper.API.Migration\Snapshots\Pepper.API.Migration_20140711_12-52-23.dacpac" /o:5
When you deploy the dacpac, SSDT compares the target database schema to the dacpac schema being deployed, and it generates the upgrade scripts internally to update the target database.

T0 Rollback: If you need to rollback, you can run the previous snapshot to revert the database. Example, you can run
SNAPSHOT2 is "C:\DummyProjects\SSDT\Pepper.API.Migration\Snapshots\Pepper.API.Migration_20140711_11-23-20.dacpac"
deploysqldac.exe /t:"Data Source=(local);Integrated Security=SSPI;Trusted_Connection=True;" /d:Pepper.API.Migration.DEV /f:SNAPSHOT2 /o:5
Possible concerns: 
You have to account for data loss. Eg: If a column was NOT NULL in Snapshot 1. You made it NULL in Snapshot 2. Then you inserted some data with NULL entries 
in the column. If you try to revert back to Snapshot1, since snapshop1 requires the column to be not null, you will run into issues.

NOTE: In this case, the schema in the project matches the last snapshot that you have taken

b) Option a) means that you probably will have to change the schema in the project and then deploy it to DEV. Most of the times, people
like to make changes in DEV Sql server directly, and when everyting is kosher, they like to generate the update scripts.
You can achieve this by first generating a .dacpac file from the DEV environment. You can generate it using the deploysqldac.exe tool
deploysqldac.exe /s:"Data Source=(local);Integrated Security=SSPI;Trusted_Connection=True;" /sd:Pepper.API.Migration.DEV /f:Pepper.API.Migration.DEV.dacpac /o:1
Or you can generate from your DEV database using Sql Server Management Studio.
To generate a DACPAC from your DEV database, right click your database->Tools->Extract Data-Tier Application.
Enter the application name, version, and description.
The application name, version, and description are displayed in SQL Server management Studio after the DAC has been deployed
After the dacpac is generated, you can store that dacpac in the snapshots folder.
NOTE: note that in this case you are not updating the schema in the project. Hence the project schema will always match Snapshot 1. Snapshots folder
will contain all the dacpac files representing the changes that you have made.

Process:(This probably will work in case of moving the database to a QA environment, and up)
-- use a utility like deploysqldac or sqlpackage to generate a dacpac from the DEV environment
-- copy that dacpac to the snapshots folder
-- Optionally generate a upgrade script by comparing the previous version of the dacpac with the DEV environment. 
This step is optional, and provides flexibility in terms of how we need to upgrade the database.
Another benefit of this approach is that we can also specify the rollback scripts with this. The convention used
in this case would be:
--All the scripts will be stored in the Migration folder.
--
The upgrade script will be named as <name_of_dacpac>.sql
the rollback script will be named as <name_of_dacpac>_rollback.sql
Eg: Pepper.API.Migration_20140711_12-52-23.dacpac will have the following 2 scripts in 
the Migration folder
Pepper.API.Migration_20140711_12-52-23.sql
Pepper.API.Migration_20140711_12-52-23_rollback.sql
-- Whenever a dacpac, (or the upgrade script) is deployed, the DeploymentHistory.xml file is updated.
If the environment you are deploying to doesnt have a corresponding entry in the DeploymentHistory.xml file, then create one useing tghe DeploymentHistoryTemplate
Create a deployment entry.
<deployment packageName="Pepper.API.Migration_20140711_12-52-23.sql or Pepper.API.Migration_20140711_12-52-23.dacpac" timeStamp ="{current_time}" deploymentId="{environment.nextDeploymentId}" status ="deployed"/>
the environment.nextDeploymentId is incremented by 1

In addition to these, there may be times when you would like to execute a pre-deployment script, and then after the deployment
a post deployment script.
The Scripts/PostDeploy and Scripts/PreDeploy folders contains all the related scripts.
For example: 
Scripts/PostDeploy/Pepper.API.Migration_20140711_12-52-23_preDeploy.sql contains commands to be executed before deploying the dacpac Pepper.API.Migration_20140711_12-52-23.dacpac, or Pepper.API.Migration_20140711_12-52-23.sql
Pepper.API.Migration_20140711_12-52-23_postDeploy.sql contains scripts to be executed after the related dacpac/sql script is deployed.

Pepper.API.Migration_20140711_12-52-23_rollback_preDeploy.sql and Pepper.API.Migration_20140711_12-52-23_rollback_postDeploy.sql contains scripts to be executed before and after the rollback.


--------------------------------------------------------------------------
Jenkins build job. This job updates a target environment with same schema as the source environment (DEV)
Environment to build to: QA/STAGE/PROD
Connection String of the DEV Database:
When you build the job, the following happens:
-- a dacpac/update sql script is generated from the DEV database.
-- dacpac should be compared with the previous version to see if anything changed. 
-- dacpac/update sql should be added to the visual studio solution and then pushed to git.
-- the deploymenthistory xml should be updated.



ReleaseManagement:
------------------

---------------------------------------------------------------------------------------------------------------
COMPARE & GENERATE the Delta script sqlpackage.exe /a:Script /sf:%DriveSpec%\%DacPath%\%AspBaselineDB%_baseline.dacpac /tf:%DriveSpec%\%DacPath%\AspNetDb\%AspTargetDB%.dacpac /tdn:aspTargetdb /op:%DriveSpec%\%SqlPath%\AspNetDb\AspDbUpdate.sql

EXECUTE the script sqlcmd.exe -S %Server%\aspnetdbAmexDev -i %DriveSpec%\%SqlPath%\AspNetDb\AspDbUpdate.sql



http://www.anujchaudhary.com/2012/08/sqlpackageexe-automating-ssdt-deployment.html
    To Publish, run the command: C:\SSDT\SqlPackage.exe /Action:Publish /SourceFile:"C:\Build\MyDatabase.dacpac" /TargetConnectionString:"connStr"
    To Generate Scripts, run the command: C:\SSDT\SqlPackage.exe /Action:Script /SourceFile:"C:\Build\MyDatabase.dacpac" /TargetConnectionString:"connStr" /OutPutPath:"C:\Build\MyDatabase.sql"
