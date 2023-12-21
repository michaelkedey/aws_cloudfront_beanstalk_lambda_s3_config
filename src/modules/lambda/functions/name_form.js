const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const bucketName = process.env.BUCKET_NAME;


exports.handler = async (event) => {
 const formData = JSON.parse(event.body);
 const name = formData.name;

 const params = {
    Bucket: bucketName,
    Key: `names/${name}.txt`,
    Body: `Hello ${name}!`,
 };

 try {
    await s3.putObject(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Name saved successfully' }),
    };
 } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Error saving name' }),
    };
 }
};