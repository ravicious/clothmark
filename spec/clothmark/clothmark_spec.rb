require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClothMark do
  before :each do
    @klass = Class.new { include ClothMark }
    @foo = @klass.new('nothing_special.txt')
  end
  
  it "should generate valid default 'output' filename" do
    @foo.output.should == 'nothing_special_clothmark.html'
  end

  it "should gets output filename if it is specified" do
    @bar = @klass.new('rails.txt', 'rubyonrails.txt')
    @bar.output.should == 'rubyonrails.txt'
  end
  
  it "should save valid data (one paragraph per line)" do
  @foo.data_for_output = ['Donec ultrices tortor non lorem egestas ut pharetra diam vestibulum.',
    'Etiam magna urna, porta non scelerisque ut, porttitor non purus.',
    'Mauris blandit dui ac eros varius quis lacinia velit semper.']
    
    @foo.save_to_file
    
    counter = 0
    
    File.open(@foo.output, 'r') do |file|
      # There's more than one paragraph in 'input file' (data_for_output),
      # so we wan't a few paragraphs also in 'output' file.
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
    
    # Puts each file from output to string for test
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

    @egg = @klass.new('example.txt', nil, false)

    @egg.data_for_output = ["OH MY!"]
    @egg.save_to_file
    
    test_string = ''
    
    # Puts each file from output to string for test
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

  after :all do
    # Remove testfiles (outputs)
    [@foo.output, @egg.output].each do |file|
      FileUtils.rm(file)
    end
  end
end
