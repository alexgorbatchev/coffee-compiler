// Generated by CoffeeScript 1.6.3
var coffee, compiler, fs,
  __slice = [].slice;

fs = require('fs');

coffee = require('coffee-script');

module.exports = compiler = {
  fromSource: function() {
    var callback, code, err, map, opts, results, src, v3SourceMap, _i;
    src = arguments[0], opts = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
    opts = opts[0] || {};
    try {
      results = coffee.compile(src, opts);
      if (results.charAt != null) {
        code = results;
      } else {
        code = results.js, v3SourceMap = results.v3SourceMap;
        if (v3SourceMap) {
          map = JSON.parse(v3SourceMap);
          map.sources = [opts.filename];
          map.sourcesContent = [src];
          code += '\n//@ sourceMappingURL=data:application/json;base64,';
          code += new Buffer(JSON.stringify(map)).toString('base64');
        }
      }
    } catch (_error) {
      err = _error;
      if (err.name === 'SyntaxError') {
        err.message = coffee.helpers.prettyErrorMessage(err, opts.filename || 'coffee-compiler', src);
      }
    }
    return callback(err, code);
  },
  fromFile: function() {
    var callback, filepath, opts, _i;
    filepath = arguments[0], opts = 3 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 1) : (_i = 1, []), callback = arguments[_i++];
    opts = opts[0] || {};
    if (opts.filename == null) {
      opts.filename = filepath;
    }
    return fs.readFile(filepath, 'utf8', function(err, src) {
      if (err != null) {
        return callback(err);
      }
      return compiler.fromSource(src, opts, callback);
    });
  }
};
