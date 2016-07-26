module FuncList

  @@regex = /\s*(\w+)\s*:\s*\(\s*\w+\s*\*?\s*\)\s*\w+\s*/

  def self.capture(str) 
    results = []
    str.scan @@regex do |curr_match|
      md = Regexp.last_match
      whole_match = md[0]
      captures = md.captures

      captures.each do |capture|
        results << capture
        p [whole_match, capture]
      end
    end
    results
  end

  def self.genFuncList(path)
    capture_methods = []
    funclist_path = "#{path}/func.list"  
    file = File.open(funclist_path, "w")
    file_pathes = `find #{path} -name "*.m" -d`.split "\n"
    file_pathes.each do |file_path|
      content = File.read file_path
      captures = capture content 
      captures.each do |capture_method| 
        if !capture_method.start_with? "init" 
          if !capture_methods.include? capture_method 
            capture_methods << capture_method 
          end
        end
      end
    end
    if capture_methods.length > 0 
      file.write(capture_methods.join "\n") 
    end
    file.close
    funclist_path
  end
  
end

