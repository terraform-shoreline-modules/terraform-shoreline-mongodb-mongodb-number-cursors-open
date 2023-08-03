
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB number cursors open incident.
---

A MongoDB number cursors open incident occurs when there are too many cursors opened by MongoDB for clients, usually exceeding 10,000, which can cause performance issues and impact the overall stability of the system. This incident needs to be addressed promptly to ensure that the number of cursors is reduced to a manageable level, and that the issue does not recur.

### Parameters
```shell
# Environment Variables

export MONGODB_OWNER="PLACEHOLDER"

export MONGODB_USER="PLACEHOLDER"

export MONGODB_PASSWORD="PLACEHOLDER"

export MONGODB_INSTANCE="PLACEHOLDER"

export POOL_SIZE="PLACEHOLDER"

```

## Debug

### 1. Check MongoDB version
```shell
mongo --version
```

### 2. Check number of open cursors for each database
```shell
mongo --eval "db._adminCommand( { serverStatus: 1 } ).cursors"
```

### 3. Check the number of clients and connections for MongoDB
```shell
netstat -an | grep 27017 | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
```

### 4. Check the current open file limit for the MongoDB process
```shell
cat /proc/$(pidof mongod)/limits | grep "open files"
```

### 5. Check the ulimit settings for the MongoDB process owner
```shell
sudo su - ${MONGODB_OWNER} -c "ulimit -a"
```

### 6. Check the MongoDB logs for any errors related to open cursors
```shell
tail -n 1000 /var/log/mongodb/mongod.log | grep "Too many open cursors"
```

### 7. Check the MongoDB configuration file for cursor-related settings
```shell
cat /etc/mongod.conf | grep cursor
```

## Repair

### Reduce the number of open cursors in MongoDB

```shell


#!/bin/bash



# Step 1: Identify the MongoDB instance and connect to it

MONGODB_INSTANCE=${MONGODB_INSTANCE}

MONGODB_USER=${MONGODB_USER}

MONGODB_PASSWORD=${MONGODB_PASSWORD}

mongo -u $MONGODB_USER -p $MONGODB_PASSWORD $MONGODB_INSTANCE



# Step 2: Check the number of open cursors and identify idle or long-running ones

db.serverStatus().cursors



# Step 3: Terminate idle or long-running cursors
CURSOR_ID="PLACEHOLDER"

db.killCursors(${CURSOR_ID})



# Step 4: Implement connection pooling to manage the number of open connections

# Add the following line to the MongoDB driver configuration file

connectionPoolSize=${POOL_SIZE}



# Step 5: Monitor and analyze the MongoDB logs to identify any recurring issues

tail -f /var/log/mongodb/mongodb.log


```