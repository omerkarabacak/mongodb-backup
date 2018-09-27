#!/bin/bash

# Example usage:
# ./mongo-backup.sh qa localhost 27017 rootuser rootpassword

environment=$1
mongo_host=$2
mongo_port=$3
mongo_user=$4
mongo_pass=$5

# mongodump all data to a gzip archive and than send it to Minio object storage
mongodump -h "$mongo_host" -p "$mongo_port" -u "$mongo_user" -p "$mongo_pass" --archive --gzip | ./mc pipe minio-"$environment"/mongodb-"$environment"-backup/mongo-"$environment"-backup-"$(date +%Y-%m-%d--%H-%M-%S)".archive.gz

# Remove backups older than 15 days
./mc rm --recursive --older-than=15 --force minio-"$environment"/mongodb-"$environment"-backup/