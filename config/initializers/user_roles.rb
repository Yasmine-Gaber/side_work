begin
Role.all.each do |role|
  dynamic_name = role.title.strip.gsub(" ", "_").camelcase
  Object.const_set(dynamic_name, Class.new(User))
end
rescue Exception => e
  puts "."
end
