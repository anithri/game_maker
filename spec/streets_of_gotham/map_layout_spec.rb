require "spec_helper"

describe StreetsOfGotham::MapLayout do
  subject { StreetsOfGotham::MapLayout }
  let(:layout) {subject.new({test: [:a,:b,:c],sample: [:x,:y,:z]})}
  describe "#initialize" do
    it {subject.new.should be_a subject}
  end
  describe ".parts_by_type" do
    it "should return a hash with a random element of each value in hash" do
      arr_1 = [:a,:b,:c]
      arr_2 = [:l,:m,:n,:o]
      arr_3 = [:x,:y,:z]
      arr_1.stub(:sample).and_return(:b)
      arr_2.stub(:sample).and_return(:o)
      arr_3.stub(:sample).and_return(:x)
      obj = subject.new(first: arr_1, second: arr_2, third: arr_3)
      expected = {first: :b, second: :o, third: :x}
      obj.parts_by_type.should eq expected
    end
  end
end
