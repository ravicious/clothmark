module ClothMark
  attr_accessor :data_for_output, :file, :output
  
  # Header for an output file.
  HEADER = <<-EOF
<html>
  <head>
    <style type="text/css">
      #wrapper {
        width: 600px; margin: 0 auto;
        font-family: "Trebuchet MS", Verdana, sans-serif;
        border-top: 1px solid black;
        border-bottom: 1px solid black;
        line-height: 1.5em;
      }
      pre {
        font-size:90%;
        line-height:1.5em !important;
        overflow:auto;
        margin:1em 0;
        padding:0.5em;
      }
      
      pre, code {
        font-family:Monaco, "Courier New", monospace;
        color:#444;
        background-color:#F8F8FF;
        border:1px solid #DEDEDE;
      }
    </style>
    <title>ClothMark file preview</title>
  </head>
  <body>
    <div id="wrapper">
  EOF
  
  # Footer for an output file.
  FOOTER = <<-EOF
    </div>
  </body>
</html>
  EOF
  
  # ClothMark will generate a default filename if user don't want to save output to a specific file.
  def initialize(file, output = nil)
    @file = file
    if (!output || output.empty?)
      @output = "#{file.gsub(/(\.[a-z]{3,4})/, '')}_clothmark.html"
    else
      @output = output
    end
    @data_for_output = []
  end
  
  # Saves output to a file (one paragraph per line).
  def save_to_file
    File.open(@output, 'w+') do |file|
      file.puts HEADER
      file.puts @data_for_output.join("\n")
      # @data_for_output.each {|line| file.puts "#{line} \n"}
      file.puts FOOTER
    end
  end
end
