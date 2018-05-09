# Introduction 

Demo VSTS project that starts a MySQL container, waits for the container to start, waits for MySQL to be ready to accept clients and configures MySQL to allow access from the build agent and then runs a query against the new MySQL instance.

This uses the VSTS build as YAML feature, it is still in preview so you need to enable it for your account.

# Steps

## Step 1

`- task: CmdLine@1
  displayName: 'install mysql client'
  inputs:
    filename: sh
    arguments: '-c "apt-get install mysql-client"'
`

We will need the MySQL tools on the host

## Step 2

`- task: ShellScript@2
  displayName: 'run MySQL'
  inputs:
    scriptPath: 'deploy/prepare-mysql.sh'`

Run the MySQL container and wait for it to be ready, when it has started allow root to connect from the host

## Step 3

- task: ShellScript@2
  displayName: 'create empty database'  
  inputs:
    scriptPath: 'deploy/runscript.sh'
    args: 'sql/db.sql $(MySQLIp)'

Create an empty database

## Step 4

- task: ShellScript@2
  displayName: 'check empty database'  
  inputs:
    scriptPath: 'deploy/runscript.sh'
    args: 'sql/check.sql $(MySQLIp)'
  
Run some cool script

For more details see:

https://the.agilesql.club/blogs/ed-elliott/2018-05-09/mysql-on-a-vsts-agent
