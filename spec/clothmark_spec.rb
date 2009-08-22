require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ClothMark do
  before :all do
    @egg = ClothMark.new('example.txt', 'markdown', false)

    # Create input text for BBCode
    @bbcode_file = 'bbcode.txt'
    BBCODE = "[b]O HAI![/b]
      
Lorem [i]ipsum[/i] dolor sit amet, [b]consectetur[/b] adipiscing elit.
    
[quote]Blaargh![/quote]" 

    # Create input text for Markdown
    @markdown_file = 'markdown.txt'
    MARKDOWN = "# O HAI!
    
Lorem *ipsum* dolor sit amet, **consectetur** adipiscing elit."

    # Create input text for Textile
    @textile_file = 'textile.txt'
    TEXTILE = "h1. O HAI!
    
Lorem _ipsum_ dolor sit amet, *consectetur* adipiscing elit."

    # Save input text to files
    [@bbcode_file, @markdown_file, @textile_file, 'example.txt'].each do |markup|
      File.open(markup, 'w+') do |file|
        case markup
        when @bbcode_file
          file.puts BBCODE
        when @markdown_file
          file.puts MARKDOWN
        when @textile_file
          file.puts TEXTILE
        else
          file.puts "OH MY!"
        end
      end
    end

    @bbmark = ClothMark.new(@bbcode_file, 'bbcode')
    @bluemark = ClothMark.new(@markdown_file, 'markdown')
    @redmark = ClothMark.new(@textile_file, 'textile')

    [@bbmark, @bluemark, @redmark].each do |clothmark|
      clothmark.read_from_file
      clothmark.to_html
    end
  end

  before :each do
    @foo = ClothMark.new('nothing_special.txt', 'markdown', true, nil)
  end

  it "should raise an error if unknown markup language has been specified" do
    lambda { ClothMark.new('rotfl', 'wikitext') }.should raise_error(ArgumentError)
  end

  it "should raise an error if specified input file doesn't exist" do
    lambda { ClothMark.new('dunnolol').read_from_file }.should_not raise_error(Errno::ENOENT)
  end

  it "should generate valid default 'output' filename" do
    @foo.output.should == 'nothing_special_clothmark.html'
  end

  it "should get output filename if it is specified" do
    @bar = ClothMark.new('rails.txt', 'markdown', true, 'rubyonrails.txt')
    @bar.output.should == 'rubyonrails.txt'
  end
  
  it "should save valid data (one paragraph per line)" do
  @foo.data_for_output = ['Donec ultrices tortor non lorem egestas ut pharetra diam vestibulum.',
    'Etiam magna urna, porta non scelerisque ut, porttitor non purus.',
    'Mauris blandit dui ac eros varius quis lacinia velit semper.']
    
    @foo.save_to_file
    
    counter = 0
    
    File.open(@foo.output, 'r') do |file|
      # There's more than one paragraph in input file (data_for_output),
      # so we wanna see a few paragraphs also in output file.
      file.each_line do |line|
        counter += 1 unless line.empty?
      end
    end
    
    # File should have at least two paragraphs
    counter.should > 1
  end

  it "should save data for output to the output file with additional CSS and HTML" do
    @foo.data_for_output = ["OH MY!"]
    @foo.save_to_file
    
    test_string = ''
    
    # Put each file from output to string for test
    File.open(@foo.output, 'r') do |file|
    file.each_line do |line|
        test_string << "#{line} \n"
      end
    end
       
    # Additional HTML and CSS should be added
    test_string.should match(/<html/)
    test_string.should match(/<head/)
    test_string.should match(/<style/)
    test_string.should match(/<body/)
  end

   it "should save data for output to the output file without additional HTML and CSS" do


    @egg.read_from_file
    @egg.save_to_file
    
    test_string = ''
    
    # Put each file from output to string for test
    File.open(@egg.output, 'r') do |file|
      file.each_line do |line|
        test_string << "#{line} \n"
      end
    end
    
    # Additional HTML and CSS should not be added
    test_string.should_not match(/<html/)
    test_string.should_not match(/<head/)
    test_string.should_not match(/<style/)
    test_string.should_not match(/<body/)
  end 

  it "should convert data from input file to HTML (BBCode -> HTML)" do
    @bbmark.data_for_output.should_not be_empty
    @bbmark.data_for_output.join("\n").should match(/<.+>/) # <.+> is the HTML tag
  end

  it "should convert data from input file to HTML (Markdown -> HTML)" do
    @bluemark.data_for_output.should_not be_empty
    @bluemark.data_for_output.join("\n").should match(/<.+>/)
  end

  it "should convert data from input file to HTML (Textile -> HTML)" do
    @redmark.data_for_output.should_not be_empty
    @redmark.data_for_output.join("\n").should match(/<.+>/)
  end

  after :all do
    # Remove testfiles (outputs and inputs)
    [@bbcode_file, @markdown_file, @textile_file].each do |file|
      FileUtils.rm(file)
    end
    [@foo, @egg].each do |file|
      begin
        FileUtils.rm(file.output)
        FileUtils.rm(file.file)
      rescue Errno::ENOENT => e
        # puts e
      end
    end
  end
end
