class BlueMark
  include ClothMark
  
  # Converts all lines from input file from Markdown format to HTML
  # and pushes them to an array data_for_output.
  def convert
    File.open(@file) do |file|
      file.each_line {|line| @data_for_output << BlueCloth.new(line).to_html}
    end
  end
end

class RedMark
  include ClothMark

  # Converts all lines from input file from Textile format to HTML
  # and pushes them to an array data_for_output.
  def convert
    File.open(@file) do |file|
      file.each_line {|line| @data_for_output << RedCloth.new(line).to_html}
    end
  end
end

class BBMark
  include ClothMark
  
  # Converts all lines from input file from BBCode format to HTML
  # and pushes them to an array data_for_output.
  def convert
    File.open(@file) do |file|
      file.each_line {|line| @data_for_output << line.bbcode_to_html}
    end
  end
end
