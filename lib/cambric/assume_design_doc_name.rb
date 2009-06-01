module Cambric
  module AssumeDesignDocName

    attr_accessor :cambric_design_doc_name
  
    def view name, options={}, &block
      super "#{@cambric_design_doc_name}/#{name}", options, &block
    end
    
    def cambric_design_doc
      get "_design/#{@cambric_design_doc_name}"
    end
  
  end
end
