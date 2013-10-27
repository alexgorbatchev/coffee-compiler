fs     = require 'fs'
path   = require 'path'
coffee = require 'coffee-script'

module.exports = compiler =
  fromSource : (src, filename, debug, callback) ->
    try
      if debug
        {js, v3SourceMap} = coffee.compile src, bare: true, sourceMap: true, filename: filename
        code = js

        if v3SourceMap
          map = JSON.parse v3SourceMap
          map.sources = [filename]
          map.sourcesContent = [src]

          code += '\n//@ sourceMappingURL=data:application/json;base64,'
          code += new Buffer(JSON.stringify map).toString('base64')
      else
        code = coffee.compile src, bare: true, filename: filename
    catch err
      if err.name is 'SyntaxError'
        err.message = coffee.helpers.prettyErrorMessage err, filename, src

    callback err, code

  fromFile : (filepath, debug, callback) ->
    fs.readFile filepath, 'utf8', (err, src) =>
      return callback err if err?
      compiler.fromSource.apply @, [src, filepath, debug, callback]
