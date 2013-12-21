chai    = require 'chai'
fibrous = require 'fibrous'
coffee  = require '../coffee-compiler.js'
expect  = chai.expect

SOURCE = """
  console.log "hello"
"""

describe 'coffee-compiler', ->
  describe '::fromSource', ->
    it 'compiles from source', fibrous ->
      results = coffee.sync.fromSource SOURCE
      expect(results).to.equal '''
        (function() {
          console.log("hello");

        }).call(this);

      '''

    it 'adds source maps', fibrous ->
      results = coffee.sync.fromSource SOURCE, sourceMap: yes
      expect(results).to.contain 'sourceMappingURL='

    it 'has pretty errors', fibrous ->
      expect(-> coffee.sync.fromSource 'syntax_error +').to.throw """
        coffee-compiler:1:14: error: unexpected CALL_END
        syntax_error +
                     ^
      """

  describe '::fromFile', ->
    it 'compiles from file', fibrous ->
      results = coffee.sync.fromFile __filename
      expect(results).to.contain "foo: 'hello'"

    it 'has pretty errors', fibrous ->
      filename = "#{__dirname}/_fixture_syntax_error.coffee"
      expect(-> coffee.sync.fromFile filename).to.throw """
        #{filename}:1:14: error: unexpected CALL_END
        syntax_error +
                     ^
      """
