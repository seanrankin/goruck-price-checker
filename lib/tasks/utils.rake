namespace :utils do
  desc "Keep the site alive on heroku."

  task :wake_up do
    begin
      uri = URI('https://goruck-price-checker.herokuapp.com/products')

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)

      # Create Request
      req =  Net::HTTP::Get.new(uri)

      # Fetch Request
      res = http.request(req)

      if res.code == "200"
        puts "Success, the site sent back the following code: #{res.code}"
      else
        puts "Error, the site sent back the following code: #{res.code}"
      end
    rescue StandardError => e
      puts "Site Keep Alive Failed (#{e.message})"
    end
  end
end
