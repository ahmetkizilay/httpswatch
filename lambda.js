const fs = require('fs');
const exec = require('child_process').exec;
const Promise = require('promise');
const AWS = require('aws-sdk');



function run() {
  return new Promise(function (fulfill, reject) {

    const commandParts = [];
    if (process.env['LAMBDA_TASK_ROOT']) {
      commandParts.push(`cd ${process.env['LAMBDA_TASK_ROOT']}`);
    }
    commandParts.push('/bin/bash ./download-and-analyse.sh');

    const command = commandParts.join(' && ');

    exec(command, (error, stdout, stderr) => {
      console.log(stdout);
      console.log(stderr);

      if (error) {
        console.error(`exec error: ${error}`);
        reject(error, stderr);
      }
      else {
        fulfill(stdout);
      }
    });
  });
}

function uploadToS3(bucketname, filename) {
  return new Promise(function (fulfill, reject) {

    var fileStream = fs.createReadStream(`/tmp/${filename}`);
    fileStream.on('open', function() {
      var s3 = new AWS.S3();
      const params = {
        Bucket: bucketname,
        Key: filename,
        Body: fileStream
      };

      s3.putObject(params, function (err) {
        if (err) {
          reject(err);
        }
        else {
          fulfill();
        }
      });

    });

    fileStream.on('error', function (err) {
      reject(err);
    })

  });
}


function uploadReportToS3(obj, filename) {
  return uploadToS3(obj.ReportBucket, `${filename.trim()}.tsv`);
}

function uploadArchiveToS3(obj, filename) {
  return uploadToS3(obj.ArchiveBucket, `${filename.trim()}.tar.gz`);
}

exports.myHandler = function (event, context, callback) {

  const onSuccess = function (filename) {
    if (event) {
      Promise.all([
        uploadReportToS3(event, filename),
        uploadArchiveToS3(event, filename)
      ]).then(function() {
        callback();
      }, function (err) {
        console.log(err);
        callback('Upload to s3 Failed');
      });
    }
    else {
      callback();
    }
  };

  const onFailure = function (err) {
    console.error(err);
    callback('Failed to execute bash');
  };

  run().then(onSuccess, onFailure);
};
