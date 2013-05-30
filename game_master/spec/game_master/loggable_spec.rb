require "spec_helper"

describe GameMaster::Loggable do
  let(:mod){Class.new{include GameMaster::Loggable}}

  it{mod.logger.should eq Yell['GameMaster']}
  it{mod.new.logger.should eq Yell['GameMaster']}

end