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

    - tfm-uoc-crawling-system-app: the TFM UOC Crawling APP with Bovespa Crawler.       
    - tfm-uoc-crawling-system-producer: The TFM UOC Producer APP for Bovespa Crawler.
    - tfm-uoc-crawling-system-consumer: The TFM UOC Consumer APP for Bovespa Crawler.
    - tfm-uoc-spark: The TFM Processing Service with Jupiter Notebooks and Spark.
    
## Start the TFM UOC Crawling APP

The following instruction will start the TFM UOC Application with Bovespa
endpoints. 

```shell script
docker-compose up -d tfm-uoc-crawling-system-app
```

Along with the application the postgres, redis, DSE services will
be started.

## Steps needed to setup the services for the Crawling APP

Once the TFM UOC Application have been started, we will need to do its setup.

The following steps should be executed.

- Migrate databases:
``` bash
mkdir -p ./data/postgres
mkdir -p ./data/cassandra
docker-compose exec tfm-uoc-crawling-system-app python manage.py migrate
docker-compose exec tfm-uoc-crawling-system-app python manage.py sync_cassandra
docker-compose exec tfm-uoc-crawling-system-app python manage.py sync_indexes
```

## Initial data

Now we are ready to import the initial data, which is basically the admin user
 that we are going to use for development.

First, we need to define the environmental variable `BGDS_USER_EMAIL`,
 with your own email.  

```shell script
export TFM_UOC_USER_EMAIL=<YOUR OWN EMAIL HERE>
``` 

Instruction to import initial data in postgres database for Gatherer
```
cat initial_data/admin_user.sql | sed -e 's/@TFM_UOC_USER_EMAIL@/'"$TFM_UOC_USER_EMAIL"'/g' | docker exec -i tfm_uoc_postgres psql -U tfm_uoc
```

## Start the TFM UOC Crawling Consumer

The consumer process is a daemon process responsible for listening for new
crawling tasks. In this case, the process is listening for new Bovespa files
to download, cache, and process. 

```shell script
docker-compose up -d tfm-uoc-crawling-system-consume
```

## Start the TFM UOC Crawling Producer

When we were ready, we can start the producer process in order to detect new
files to process in Bovespa.

```shell script
docker-compose up -d tfm-uoc-crawling-system-producer
```

When the process ends of checking all the companies for new financial reports,
the process also ends. We should be executing this process periodically, maybe
using a CRON solution. An option could be process files once a month.

## F.A.Q

- [My build is not working, why?](#my-build-is-not-working--why)

### My build is not working, why?

Probably you're missing a required step to build our images, we need to specify our private ssh keys to be able to have access to BGDS private repos. Your build command should be something like this:

```bash
docker-compose build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"
```

If your key is not in `id_rsa` remember to change this on the script.

