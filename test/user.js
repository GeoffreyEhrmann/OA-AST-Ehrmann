var should = require('should');
var user = require('../src/user.js');

describe('tests', function() {
  it('get should return geoffrey', function(done){
    user.get("geoffrey",function(res){
      res.should.equal("geoffrey");
      done();
    })
  })
  
  it('get should not return geoffrey', function(done){
    user.get("pokemon",function(res){
      res.should.be.not.equal("geoffrey");
      done();
    })
  })

  it('save should return geoffrey', function(done){
    user.save("geoffrey",function(res){
      res.should.equal("geoffrey");
      done();
    })
  })
})
