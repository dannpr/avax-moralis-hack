const assert = require('chai').assert
const createRequest = require('../index.js').createRequest

describe('createRequest', () => {
  const jobID = '1'

  context('successful calls', () => {
    const requests = [
      { name: 'username', testData: { data: { "tweet": "1469504391057137664", "query": "username" } } },
      { name: 'text', testData: { data: { "tweet": "1469504391057137664", "query": "text" } } },
    ]

    requests.forEach(req => {
      it(`${req.name}`, (done) => {
        createRequest(req.testData, (statusCode, data) => {
          assert.equal(statusCode, 200)
          assert.equal(data.jobRunID, jobID)
          assert.isNotEmpty(data.data)
          done()
        })
      })
    })
  })

  context('error calls', () => {
    const requests = [
      { name: 'empty body', testData: {} },
      { name: 'empty data', testData: { data: {} } },
      { name: 'query not supplied', testData: { id: jobID, data: { "tweet": "1469504391057137664" } } },
      { name: 'tweet not supplied', testData: { id: jobID, data: { "query": "username" } } },
      { name: 'unknown query', testData: { id: jobID, data: { "tweet": "1469504391057137664", "query": "query"} } },
    ]

    requests.forEach(req => {
      it(`${req.name}`, (done) => {
        createRequest(req.testData, (statusCode, data) => {
          assert.equal(statusCode, 500)
          assert.equal(data.jobRunID, jobID)
          assert.equal(data.status, 'errored')
          assert.isNotEmpty(data.error)
          done()
        })
      })
    })
  })
})
