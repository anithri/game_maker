shared_examples "a singleton" do
  let(:instance) { subject.instance }

  describe ".instance" do
    it "should return an instance of itself" do
      subject.instance.should be_a subject
    end
    it "should always return the same object" do
      first = subject.instance
      subject.instance.should eq first
    end
  end

end
