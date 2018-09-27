# MongoDB backup to Minio object storage

## How to run Minio object storage

```bash
docker run -d -v /home/ubuntu/minio-data:/data -p 80:9000 minio/minio server /data
```

## How to get Minio API connection info

```bash
docker logs <minio-container-name-OR-id>
```

## How to add object storage host to mc (minio client)

```bash
./mc config host add minio-qa http://10.0.0.2 <Minio Access Key> <Minio Secret Key>
```

## How to add script to crontab

edit /etc/crontab and add this;

MongoDB

```bash
39 *    * * *   ubuntu    cd /home/ubuntu/mongo-backup && ./mongo-backup.sh qa localhost 27017 <mongodb_root> <mongodb_password>
```

Than reload crontab

```bash
sudo service cron reload
```

## MONGODB

### How to backup mongodb

```bash
mongodump -h localhost -p 27017 -u <mongodb_root> -p <mongodb_password> --archive --gzip | ./mc pipe minio-qa/mongodb-qa-backup/mongo-qa-backup-`date +%Y-%m-%d`.archive.gz
```

### How to restore mongodb

#### All

```bash
mongorestore --gzip --archive=mongo-data-2018-09-17.archive.gz
```

#### Only one db

```bash
mongorestore --gzip --archive=mongo-data-2018-09-17.archive.gz --db TestDB
```

## Documents

<https://docs.minio.io/docs/minio-client-quickstart-guide>

<https://docs.minio.io/docs/minio-client-complete-guide>
