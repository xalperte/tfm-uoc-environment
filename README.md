# TFM Infrastructure

This files shows the steps we need to do in order to start our crawling
environment in local using docker-compose.

The first we need to do is to build the docker image of the project.


When building images you need to add two build arguments that will add 
your ssh keys into the image so we can clone the private dependencies
while installing requirements for python.

You can find an example below (change id_rsa with the name of your ssh key):

```bash
docker-compose build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
```
If your key is not in `id_rsa` remember to change this on the script.

Your build is not working? Probably you're missing a required step to build
 our images, we need to specify our private ssh keys to be able to have access
 to BGDS private repos. Your build command should be something like this:

Follow [this instructions](https://help.github.com/en/enterprise/2.17/user/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account) 
in order to setup your GitHub account with a valid key. 

## Containers

The following are the containers we have available for development in the backend:

    - tfm-uoc-crawling-system_app: the TFM UOC Crawling APP with Bovespa Crawler.       
    - tfm-uoc-crawling-system_consumer: The TFM UOC Consumer APP for Bovespa Crawler.
    - tfm-uoc-spark: The TFM Processing Service with Jupiter Notebooks
    
## Start the TFM UOC Crawling APP

The following instruction will start the TFM UOC Application with Bovespa
endpoints. Along with the application the postgres, redis, DSE services will
be started.

```shell script
docker-compose up -d tfm-uoc-crawling-system-app
```

## Steps needed to setup the services

Once the TFM UOC Application have been started, we will need to do its setup.

The following steps should be executed.

- Migrate databases:
``` bash
docker-compose exec tfm-uoc-crawling-system-app python manage.py migrate
docker-compose exec tfm-uoc-crawling-system-app python manage.py sync_cassandra
docker-compose exec tfm-uoc-crawling-system-app python manage.py sync_indexes
```

- If we are working with a DaVinci container or any of its crawlers, we'll need to
 synchronize the topics, streams, and sources:

```bash
docker-compose exec {container_name} sync_davinci_kafka
```

## Initial data

Now we are ready to import the initial data, which is basically the organizations
 and users that we are going to use for development.

First, we need to define the environmental variable `BGDS_USER_NAME`,
 with your username in BuildGroup Data Services (<BGDS_USER_NAME>@buildgroupai.com).
 We will use that variable to assign variations of your email for all the imported users. 

__NOTE__: we only need the username without not the domain, as the domain always
 will be `@buildgroupai.com`.

```shell script
export BGDS_USER_NAME=xalperte
``` 

Instruction to import initial data in postgres database for Gatherer
```
cat initial_data/gatherer.sql | sed -e 's/@BGDS_USER_NAME/'"$BGDS_USER_NAME"'/g' | docker exec -i postgres_backend psql -U gatherer
```

### Details about the available users in Gatherer

The default client:

- BuildGroup Data Services Inc. (BGDS Apps). Contact email @BGDS_USER_NAME@buildgroupai.com

The Organizations

- BuildGroup LLC. Contact email @BGDS_USER_NAME+01@buildgroupai.com 
- Intelligent Startup Consulting LLC. Contact emaikl @BGDS_USER_NAME+02@buildgroupai.com

Super users:

- Global: BGDS IT, __Email:__ @BGDS_USER_NAME+11@buildgroupai.com. __Token__: cb31a1546c70841f43512df1435b24f4ccbcbc67
- BGDS Client: BGDS Apps, __Email:__ BGDS_USER_NAME+1@buildgroupai.com. __Token__: 0c6f9dd239fea87d23bf090daac8b5e1006bfb07

BuildGroup LLC users:

- Flavia (owner). __Email:__ @BGDS_USER_NAME+16@buildgroupai.com. __Token__: bb751d56f29ea9445c57e62a0d18b8ceb508424c
- Tanner (member). __Email:__ @BGDS_USER_NAME+15@buildgroupai.com. __Token__: 8714bbb24b7bd097b922cee0cc2e073b2447e1b5
- Dice (member). __Email:__ @BGDS_USER_NAME+13@buildgroupai.com. __Token__: fa757fd772938ca25b5eead5fb6fa574b5b2c84e
- Jim (administrator). __Email:__ @BGDS_USER_NAME+14@buildgroupai.com. __Token__: 67544d4f260f8def11da2d351ce887ca03a5eedf
- Gray (administrator). __Email:__ @BGDS_USER_NAME+12@buildgroupai.com. __Token__: 36498bb6a37089352538635a638c059bed8dcbae
- Lanham (member). __Email:__ @BGDS_USER_NAME+17@buildgroupai.com. __Token__: 27acbe092a028d711cf2b7757b7f0d31a03b7c47
- Klee (member). __Email:__ @BGDS_USER_NAME+18@buildgroupai.com. __Token__: 0936a1546b1debfafe66b6bdd3e8224cc6be9618

Intelligent Startup Consulting LLC users:

- Javier (owner). __Email:__ @BGDS_USER_NAME+21@buildgroupai.com. __Token__: be73aeae794694567acb31d7db7df6b67ef3391f
- Xavier (member). __Email:__ @BGDS_USER_NAME+22@buildgroupai.com. __Token__: 10890528e75718a81cf447dc46ffd838e450833c


## Gatherer. Generate Development data.

In gatherer, for development purposes, we can generate development data that comes from PreSeries.

The development data is divided into two:

- Companies data (company-snapshot): contains the processed information about companies in 3 different months.
- Backlog and Lead: for an organization we can generate a backlog and leads based on an specified Investment Theses (preferences). 

### Companies Snapshot

We have uploaded a dump of PreSeries data into Google Storage. In order to
have access to that file, you will need to request the IT Team the Google
Service Account file and copy the file into the 
`bgds_infrastructure/dev-local/backend/initial_data` folder.

*NOTE*: the file can be found in Google Drive, in the following folder: 
`BGDS Private/Technology/Infrastructure/GCP Service Account/`

__Companies data (Endpoint: company-snapshot)__

The process of generating the data is made in three steps that are executed in order:

1. Import the data we had in PreSeries about the company snapshots. This step is known as "snapshots". 

2. Import the company logo. This step is known as "search".

3. Import the stages and rounds information. This step is known as "stages".

The process of generate all this data can take some hours to finish.
 The recommendation is to execute this process at night. 

Import command:

```shell script
docker-compose exec gatherer python manage.py load_preseries_data --cache-dir /initial_data
```

The parameter `--cache-dir /initial_data` is very important. This folder is 
 inside the container is directly connected to our host folder 
 `bgds_infrastructure/dev-local/backend/initial_data`
 making possible the access to downloaded files between restarts.

The import process is a long process (between 8-12 hours), and it can crash at
any time for diverse reasons: the DSE node goes down, etc.

Fortunately, the process informs about the latest block of companies processed
 in each of the three steps (snapshots, search, stages), being able to continue
 the process since the last block.

Examples:

- If the process crash during the generation of the snapshots (1st step):

```shell script
docker-compose exec gatherer python manage.py load_preseries_data --cache-dir /initial_data --from 100000 
```

- If the process crash during the import of the search data (2nd step):
    
```shell script
docker-compose exec gatherer python manage.py load_preseries_data --cache-dir /initial_data --skip-snapshots --from-search 50000
```
      
- If the process crash during the import of the stages data (3rd step):
    
```shell script
docker-compose exec gatherer python manage.py load_preseries_data --cache-dir /initial_data --skip-snapshots --skip-search  --from-stages 750000
```

### Backlog and Leads

There is a Django command in Gatherer that will allow us to generate a backlog
 of leads based on a defined Investor Thesis Preferences.

The command will use the previously imported data (Companies Snapshot), and
 will it apply the filter to generate the Investor Universe.

Pre-requisites:

- __Organization ID__: we are going to need the ID of the Organization
 (BuildGroup, aka BG, or Intelligent Startup Company, aka ISC) that will
  own the Backlog.

- __Snapshot Date__: we also need to know the date of one of the snapshots
 available in the system (imported in the previous step). If everything went well, the snapshot date should be “2019-06-01”, that it’s the default value for the command.

- __Preferences File__: the command accepts a reference to a JSON file where our investment preferences could be defined. By default, the command uses a predefined file that comes with the project and that mimics the current BG Thesis Preferences.

    For `BG` (ID: `ba290647-bbcd-46bf-9e7a-776d14537326`) we are going to use `initial_data/BG_thesis.json`.
    
    For `ISC` (ID: `f02759c2-6dd4-48e8-b287-41f345529b29`) we are going to use `initial_data/ISC_thesis.json`.

Let's create the Backlog for BG:

```shell script
docker-compose exec gatherer python manage.py generate_backlog \
  --organization ba290647-bbcd-46bf-9e7a-776d14537326 \
  --preferences-file /initial_data/BG_investment_thesis.json
```

And another for ISC:

```shell script
docker-compose exec gatherer python manage.py generate_backlog \
  --organization f02759c2-6dd4-48e8-b287-41f345529b29 \
  --preferences-file /initial_data/ISC_investment_thesis.json
```

## Update containers when something change

If we do changes on the project dependencies of any of the Django services , we will need to setup dependencies again.  

- If we made changes on the setup.py file: 
```bash
docker-compose exec {container_name} python setup.py develop
```

- If we made change on the project requirements.
```bash
docker-compose exec {container_name} pip install -r requirements.txt
docker-compose exec {container_name} pip install -r requirements_tests.txt
```

## F.A.Q

- [My build is not working, why?](#my-build-is-not-working--why)
- [Why I need a ssh key to build the images?](#why-i-need-a-ssh-key-to-build-the-images)
- [How to start the rest server?](#how-to-start-the-rest-server)
- [How to run a test?](#how-to-run-a-test)
- [How we manage the server ports?](#how-we-manage-the-server-ports)
- [How I can create a new Dockerfile for a new project?](#how-i-can-create-a-new-dockerfile-for-a-new-project)
- [Why the container does nothing when starts?](#why-the-container-does-nothing-when-starts)
- [How to debug using PyCharm?](#how-to-debug-using-pycharm)
- [What is this host.docker.internal thing?](#what-is-this-hostdockerinternal-thing)
- [How we change code inside docker container?](#how-we-change-code-inside-docker-container)

### My build is not working, why?

Probably you're missing a required step to build our images, we need to specify our private ssh keys to be able to have access to BGDS private repos. Your build command should be something like this:

```bash
docker-compose build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
```

If your key is not in `id_rsa` remember to change this on the script.

