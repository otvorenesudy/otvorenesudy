require 'spec_helper'

describe TextExtractor do 
  it "should extract text from pdf file" do
    file = File.join(FIXTURES, "documents", "good.pdf")

    @ext = TextExtractor.new
    content = @ext.extract(file)

    content.starts_with?("A Circle Drawing Algorithm").should be_true
    content.length.should == 3719
  end

  it "should extract nothing from pdf file with scanned pages" do
    file = File.join(FIXTURES, "documents", "bad.pdf")

    @ext = TextExtractor.new
    content = @ext.extract(file)
    
    content.strip.should be_empty
   end
end

