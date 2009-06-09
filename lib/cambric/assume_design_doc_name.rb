module Cambric
  module AssumeDesignDocName

    attr_accessor :cambric_design_doc_name
  
    def view name, options={}, &block
      case name
      when String
        super name, options, &block
      when Symbol
        super "#{@cambric_design_doc_name}/#{name}", options, &block
      end
    end
    
    def cambric_design_doc
      get "_design/#{@cambric_design_doc_name}"
    end
    
    def get_docs_from_view name, options={}
      cast_as = options.delete(:cast_as) || options.delete('cast_as')
      results = view name, options.merge(:reduce => false, :include_docs => true)
      mapper = case cast_as
        when String then lambda { |r| CouchRest.constantize(r['doc'][cast_as]).new(r['doc']) }
        when Class then lambda { |r| cast_as.new(r['doc']) }
        else lambda { |r| r['doc'] }
      end
      results['rows'].map &mapper
    end
  
  end
end
