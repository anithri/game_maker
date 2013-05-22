guard 'rspec', spec_paths: ['spec','streets_of_gotham'] do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^streets_of_gotham/spec/.+_spec\.rb$})
  watch(%r{^streets_of_gotham/lib/(.+)\.rb$})     { |m| "streets_of_gotham/spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

