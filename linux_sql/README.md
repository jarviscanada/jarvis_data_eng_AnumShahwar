# Introduction
Jarvis has a Linux Cluster Administrative team (LCA). The LCA team needs to be able to get the hardware specifications so they can monitor each node. For this project, there will be multiple technologies used to meet the project requirements such as PSQL, Docker, Git and Bash. This project will consist of a product for the LCA so that they can meet their business requirements. To ensure the LCA team can do this, the project is designed to collect the data into its RDBMS. This will help ensure that the LCA team will have access to the data and can use the data provided to create reports based on business needs.

# Quick Start
**Start a psql instance using psql_docker.sh**
./scripts/psql_docker.sh start|stop|create [username][password]

**Create tables using ddl.sql**
psql -h [local host] -U [username] -d host_agent -f sql/ddl.sql

**Insert hardware specs data into the DB using host_info.sh**
./scripts/host_info.sh [host] [port] [username] [user] [password]

**Insert hardware usage data into the DB using host_usage.sh**
./scripts/host_usage.sh [host] [port] [username] [user] [password]

**Crontab setup**
Crontab -e

# Implementation
To implement this project, there will be a minimal viable product created to ensure the LCA is able to use the product to meet business needs. This product will be implemented by using PSQL, Linux commands, docker and bash scripts. The bash scripts will hold two different functions such as hardware information and host usage information.

# Architecture
![my image](./assets/Architecture.jpg)

# Scripts

```bash
psql_docker.sh: A psql docker instance is created including a docker volume to store the database even if the container is removed.**
./scripts/psql_docker.sh start|stop|create [username][password]

host_info.sh: A bash script for this will be created to make sure all hardware information for the host is collected and pushed into the database. 
./scripts/host_info.sh [host] [port] [name] [user] [password]

host_usage.sh: A bash script for this will be created to make sure all host usage information is collected and pushed into the database. It will be running on a schedule of collecting data every minute.
./scripts/host_usage.sh [host] [port] [name] [user] [password]

crontab: This will be used to run commands on a running schedule while managing it. For this project, it will run the host_usage every minute. 
* * * * *bash /full/path/to/linux_sql/host_agent/scripts/host_usage.sh [host] [port] host_agent [username] [password]

Logged into:
/tmp/host_usage.log
```
queries.sql: This was used to get information from the host_info and host_usage tables.

# Database Modeling
Host_info table

| Field            |
|------------------|
| id               |
| hostname         |
| cpu_number       |
| cpu_architecture |
| cpu_model        |
| cpu_mhz          |
| l2_cache         |
| timestamp        |
| total_mem        |


Host_usage table

| Field          |
|----------------|
| host_id        |
| memory_free    |
| cpu_idle       |
| cpu_kernal     |
| disk_io        |
| disk available |
| timestamp      |

# Test
Bash scripts DDL were tested by creating a table and inserting data on PSQL. Once the test data was inserted, a host_info.sh and host_usage.sh bash scripts were created to pull out certain data such as memory data or cpu model etc. This made sure that the test data was verified against the test data. 

# Deployment
During the deployment phase, Cron has been used to make sure that both bash scripts are running on a managed schedule. Cron was used to test the minimal viable product at 1-minute intervals to show the average memory usage. The MVP consisted of a test database that was provisioned by docker to help with the deployment process. A final test was conducted to verify the MVP was functioning.

# Improvements
1. Receiving notifications if a CPU's memory is almost full or has exceeded.
2. Have a health dashboard that will display any alerts that need to be looked over.
