const { Requester, Validator } = require('@chainlink/external-adapter')
require('dotenv').config()

const customError = (data) => {
  if (data.Response === 'Error') return true
  return false
}

const customParams = {
  tweetID: ['tweet'],
  query: ['query']
}

const createRequest = (input, callback) => {
  const validator = new Validator(callback, input, customParams)
  const jobRunID = validator.validated.id;
  const endpoint = 'tweets';
  const tweetID = validator.validated.data.tweetID;
  const query = validator.validated.data.query;
  const baseURL = `https://api.twitter.com/2/`;
  const url = `${endpoint}/${tweetID}`;
  const params = {
    expansions: "author_id"
  }
  const headers = {
    'Authorization': `Bearer ${process.env.TWITTER_BEARER_TOKEN}`
  }

  const config = {
    url,
    baseURL,
    params,
    headers
  }

  Requester.request(config, customError)
    .then(response => {
      switch (query) {
        case 'username': response.data.result = response.data.includes.users[0].username;
          break;
        case 'text': response.data.result = response.data.data.text;
          break;  
        default: response.data.result = null;
      }
      callback(response.status, Requester.success(jobRunID, response))
    })
    .catch(error => {
      callback(500, Requester.errored(jobRunID, error))
    })
}

// This is a wrapper to allow the function to work with
// GCP Functions
exports.gcpservice = (req, res) => {
  createRequest(req.body, (statusCode, data) => {
    res.status(statusCode).send(data)
  })
}

// This is a wrapper to allow the function to work with
// AWS Lambda
exports.handler = (event, context, callback) => {
  createRequest(event, (statusCode, data) => {
    callback(null, data)
  })
}

// This is a wrapper to allow the function to work with
// newer AWS Lambda implementations
exports.handlerv2 = (event, context, callback) => {
  createRequest(JSON.parse(event.body), (statusCode, data) => {
    callback(null, {
      statusCode: statusCode,
      body: JSON.stringify(data),
      isBase64Encoded: false
    })
  })
}

// This allows the function to be exported for testing
// or for running in express
module.exports.createRequest = createRequest