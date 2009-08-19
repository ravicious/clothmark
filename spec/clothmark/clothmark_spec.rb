require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClothMark do
  before :each do
    @klass = Class.new { include ClothMark }
    @foo = @klass.new('nothing_special.txt')
  end
  
  it "should generate valid default 'output' filename" do
    @foo.output.should == 'nothing_special_clothmark.html'
  end

  it "should gets output if it is specified" do
    @bar = @klass.new('rails.txt', 'rubyonrails.txt')
    @bar.output.should == 'rubyonrails.txt'
  end
  
  it "should save data for output to the output file" do
    @foo.data_for_output = ['Donec ultrices tortor non lorem egestas ut pharetra diam vestibulum.',
    'Etiam magna urna, porta non scelerisque ut, porttitor non purus.',
    'Mauris blandit dui ac eros varius quis lacinia velit semper.']
    
    @foo.save_to_file
    
    counter = 0
    test_string = ''
    
    File.open(@foo.output, 'r') do |file|
      # There's more than one paragraph in 'input file' (data_for_output),
      # so we wan't a few paragraphs also in 'output' file.
      file.each_line do |line|
        counter += 1 unless line.empty?
        test_string << "#{line} \n"
      end
    end
    
    # File should have at least two paragraphs
    counter.should > 1
    
    test_string.should match(/<html/)
    test_string.should match(/<head/)
    test_string.should match(/<body/)
  end
  
  after :all do
    # Remove testfile (output)
    FileUtils.rm(@foo.output)
  end
end
