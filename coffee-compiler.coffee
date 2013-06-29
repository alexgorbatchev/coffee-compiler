fs     = require 'fs'
path   = require 'path'
coffee = require 'coffee-script'
eco    = require 'eco'

module.exports = compiler =
  fromSource : (src, filename, debug, callback) ->
    src = eco.render src, @

    if debug
      { js, v3SourceMap } = coffee.compile src, bare: true, sourceMap: true, filename: filename
      code = js

      if v3SourceMap
        map = JSON.parse v3SourceMap
        map.sources = [ path.basename filename ]
        map.sourcesContent = [ src ]

        code += '\n//@ sourceMappingURL=data:application/json;base64,'
        code += new Buffer(JSON.stringify map).toString('base64')
    else
      code = coffee.compile src, bare: true, filename: filename

    callback null, code

  fromFile : (filepath, debug, callback) ->
    fs.readFile filepath, 'utf8', (err, src) =>
      return callback err if err?
      compiler.fromSource.apply @, [ src, filepath, debug, callback ]
