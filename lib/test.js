var should =require('should');
var user =require('../src/users.js');

describe ("my first test", {
	it("should get a user", function (done){
		//do some tests
		user.get("marie", function(res){
			get("marie", function(user) {
				user.should.equal("marie");
			})
			done();

		})
		
	})


})