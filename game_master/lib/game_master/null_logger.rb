class NullLogger < Yell::Adapters::Base
  write do |event|
    nil
  end
end

Yell::Adapters.register :null_logger, NullLogger
