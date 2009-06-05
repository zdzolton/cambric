module Cambric
  module AssumeDesignDocName

    attr_accessor :cambric_design_doc_name
  
    def view name, options={}, &block
      super "#{@cambric_design_doc_name}/#{name}", options, &block
    end
    
    def cambric_design_doc
      get "_design/#{@cambric_design_doc_name}"
    end
    
    def get_docs_from_view name, options={}
      cast_as = options.delete(:cast_as) || options.delete('cast_as')
      results = view name, options.merge(:reduce => false, :include_docs => true)
      if cast_as
        results['rows'].map{ |r| cast_as.new(r['doc']) rescue nil }.reject{ |r| r.nil? }
      else
        results
      end
    end
  
  end
end
