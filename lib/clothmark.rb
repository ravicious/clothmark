require "rubygems"
require "BlueCloth"
require "RedCloth"
require "bb-ruby"

class ClothMark
  attr_accessor :data_for_output, :file, :output
  attr_reader :markup
 
  # ClothMark will generate a default filename if user don't want to save output to a specific file
  # and will use Markdown as a default markup language.
  def initialize(file, markup = "markdown", additional_html = false, output = nil)
    @file = file

    # ClothMark will raise an error if unknown markup language has been sent
    if %w(markdown textile bbcode).include? markup
      @markup = markup
    else
      raise ArgumentError, "Unknown markup language (#{markup})"
    end

    if (!output || output.empty?)
      @output = "#{file.gsub(/(\.[a-z]{3,4})/, '')}_clothmark.html"
    else
      @output = output
    end
    @data_for_output = []
    @additional_html = additional_html # If true, then ClothMark will generate additional CSS and HTML
  end
  
  # Reads data from input file and puts it to array
  def read_from_file
    begin
    File.open(@file) do |file|
      file.each_line {|line| @data_for_output << line}
    end
    rescue Errno::ENOENT => e
      puts e
      exit
    end
  end

  def to_html
    case @markup
    when 'markdown'
      @data_for_output.collect! {|line| BlueCloth.new(line).to_html}
    when 'textile'
      @data_for_output.collect! {|line| RedCloth.new(line).to_html}
    when 'bbcode'
      @data_for_output.collect! {|line| line.bbcode_to_html}
    end
  end

  # Saves output to a file (one paragraph per line).
  def save_to_file
    File.open(@output, 'w+') do |file|
      file.puts HEADER if @additional_html
      file.puts @data_for_output.join("\n")
      file.puts FOOTER if @additional_html
    end
  end
end

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
