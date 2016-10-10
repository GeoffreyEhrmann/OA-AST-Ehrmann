should=require("should")
user=require("../src/user.coffee")

describe 'Tests', ->
    	
    it 'get should return geoffrey', ->
   		user.get 'geoffrey', (res) ->
   			res.should.equal 'geoffrey'

    
    it 'get should not return geoffrey', ->
    	user.get 'pokemon', (res) ->	
    		res.should.be.not.equal 'geoffrey'        

    	
    it 'get should return geoffrey', ->
    	user.save 'geoffrey', (res) ->
    		res.should.equal 'geoffrey'        