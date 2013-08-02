request = require 'request'
chai    = require 'chai'
coffee  = require '../coffee-compiler'
expect  = chai.expect

describe 'coffee-compiler', ->
  describe '::fromSource', ->
    it 'compiles from source', (done) ->
      coffee.fromSource 'console.log "hello"', 'filename', false, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.equal 'console.log("hello");\n'
        done()

    it 'adds source maps', (done) ->
      coffee.fromSource 'console.log "hello"', 'filename', true, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.contain 'sourceMappingURL='
        done()

    it 'uses function context with eco templates', (done) ->
      context = foo : 'hello'

      coffee.fromSource.call context, 'console.log "<%= @foo %>"', 'filename', false, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.equal 'console.log("hello");\n'
        done()

  describe '::fromFile', ->
    it 'compiles from file', (done) ->
      coffee.fromFile __filename, false, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.contain "foo: 'hello'"
        done()

    it 'uses function context with eco templates', (done) ->
      context = foo : 'hello'

      coffee.fromFile.call context, "#{__dirname}/fixture.coffee", false, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.equal 'console.log("hello");\n'
        done()
