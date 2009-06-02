require 'open3'

module Cambric
  module TestHelpers
    
    class ReduceError < RuntimeError ; end
    
    def execute_map db, view, doc
      view_functions = Cambric[db].cambric_design_doc['views'][view.to_s]
      execute_js <<-CODE
        var emittedKeyValuePairs = [];
        function emit(key, value) {
          emittedKeyValuePairs.push({ 'key': key, 'value': value });
        }
        var mapFunction = #{view_functions['map']};
        try { mapFunction(#{doc.to_json}); } catch (e) {}
        returnValueToRuby(emittedKeyValuePairs);
      CODE
    end

    def execute_reduce db, view, options
      view_functions = Cambric[db].cambric_design_doc['views'][view.to_s]
      options = { :rereduce => false }.merge(options)
      execute_js <<-CODE
        var reduceFunction = #{view_functions['reduce']};
        try {
          returnValueToRuby(reduceFunction(
            #{(options[:keys] || []).to_json},
            #{(options[:values] || []).to_json},
            #{options[:rereduce]}
          ));
        } catch (error) {
          raiseErrorToRuby(error);
        }
      CODE
    end
    
  private

    def execute_js code
      output = nil
      Open3.popen3 'js' do |stdin, stdout, stderr|
        stdin.puts HELPER_FUNCTIONS
        stdin.puts code
        stdin.close
        output = JSON.parse(stdout.read)
      end
      raise ReduceError, output['error'] if output.has_key?('error')
      output['result']
    end

    HELPER_FUNCTIONS = <<-HELPERS
      function sum(values) { 
        var total = 0;
        values.forEach(function(v) { total += v; });
        return total;
      }

      function toJSON(obj) {
       switch (typeof obj) {
        case 'object':
         if (obj) {
          var list = [];
          if (obj instanceof Array) {
           for (var i=0;i < obj.length;i++) {
            list.push(toJSON(obj[i]));
           }
           return '[' + list.join(',') + ']';
          } else {
           for (var prop in obj) {
            list.push('"' + prop + '":' + toJSON(obj[prop]));
           }
           return '{' + list.join(',') + '}';
          }
         } else {
          return 'null';
         }
        case 'string':
         return '"' + obj.replace(/(["'])/g, '\\'') + '"';
        case 'number':
        case 'boolean':
         return new String(obj);
       }
      }

      function returnValueToRuby(value) {
        print(toJSON({ 'result': value }));
      }
      
      function raiseErrorToRuby(error) {
        print(toJSON({ 'error': error['message'] }));
      }
    HELPERS
    
  end
end