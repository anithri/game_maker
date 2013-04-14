require "spec_helper"

describe StreetsOfGotham do

  describe "#config" do
    subject { StreetsOfGotham.config }
    context "Has required keys" do
      it {expect{subject.data_dir}.            to_not raise_error}
      it {expect{subject.map_board}.           to_not raise_error}
      it {expect{subject.map_board_content}.   to_not raise_error}
      it {expect{subject.map_elements}.        to_not raise_error}
      it {expect{subject.map_elements_content}.to_not raise_error}
      it {expect{subject.map_layout}.          to_not raise_error}
      it {expect{subject.map_layout_content}.  to_not raise_error}
    end
  end
end