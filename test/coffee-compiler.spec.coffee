request = require 'request'
chai    = require 'chai'
coffee  = require '../coffee-compiler.js'
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

    it 'has pretty errors', (done) ->
      coffee.fromSource 'syntax_error +', 'filename', false, (err, results) ->
        expect(err).to.be.ok
        expect(err.message).to.equal """
          filename:1:14: error: unexpected CALL_END
          syntax_error +
                       ^
        """
        expect(results).to.be.undefined
        done()

  describe '::fromFile', ->
    it 'compiles from file', (done) ->
      coffee.fromFile __filename, false, (err, results) ->
        expect(err).to.be.falsy
        expect(results).to.contain "foo: 'hello'"
        done()

    it 'has pretty errors', (done) ->
      filename = "#{__dirname}/_fixture_syntax_error.coffee"
      coffee.fromFile filename, false, (err, results) ->
        expect(err).to.be.ok
        expect(err.message).to.equal """
          #{filename}:1:14: error: unexpected CALL_END
          syntax_error +
                       ^
        """
        expect(results).to.be.undefined
        done()
