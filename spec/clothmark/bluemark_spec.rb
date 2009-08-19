require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlueMark do
  before :all do
    @testfile = 'testfile.txt'
    
    File.open(@testfile, 'w+') do |file|
      file.puts "# O HAI!
      
      Lorem **ipsum** dolor sit amet, *consectetur* adipiscing elit. Sed iaculis rutrum lobortis. Integer vitae magna dolor, luctus venenatis lorem. Etiam magna urna, porta non scelerisque ut, porttitor non purus. Nunc et tortor at eros venenatis molestie. Maecenas ut nulla ac leo congue porttitor. Phasellus vitae sem dolor, vitae elementum diam. Phasellus adipiscing augue nec dui fermentum bibendum. Donec ultrices tortor non lorem egestas ut pharetra diam vestibulum.
      
      > Blaargh!
      
      In ullamcorper placerat justo, ut dictum lorem sollicitudin a. Pellentesque dictum volutpat nisl, non rutrum dolor pharetra ut. Curabitur a elementum mi. Duis eu tellus eu justo ultrices tincidunt. Mauris blandit dui ac eros varius quis lacinia velit semper. Vivamus eu augue elit. Quisque lacinia sapien vel purus eleifend scelerisque feugiat quam sollicitudin. Pellentesque accumsan adipiscing leo, ut porttitor felis adipiscing id. Fusce cursus, lorem quis mollis commodo, dolor ipsum mattis lacus, ut suscipit augue lorem malesuada felis."
    end
  end
  
  before :each do
    @bluemark = BlueMark.new(@testfile)
  end
  
  it "should convert data from input file to HTML (Markdown -> HTML)" do
    
    @bluemark.convert
    
    @bluemark.data_for_output.should_not be_empty
    
    @bluemark.data_for_output.join("\n").should match(/<.+>/) # <.+> is the HTML tag
    
  end

  after :all do
    # Remove testfile (input)
    FileUtils.rm(@bluemark.file)
  end
end