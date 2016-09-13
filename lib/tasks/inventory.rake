namespace :inventory do
  desc "Check the product inventory."

  task check: :environment do
    require "mechanize"

    a = Mechanize.new { |agent|
      agent.user_agent_alias = "Windows IE 11"
      agent.follow_meta_refresh = true
    }

    link = "http://www.goruck.com"
    # link = "https://dl.dropboxusercontent.com/u/21441346/goruck-temp.html"

    a.get(link) do | home_page |
      gear_page = a.click(home_page.link_with(:text => /All GORUCK Built Gear/))

      puts "Checking GORUCK Inventory"

      gear_page.search(".mz-productlist-item").each do | item |
        name = item.search(".mz-productlisting-title").text.strip
        link = item.search(".mz-cat-product-buy-button").attr('href')

        if item.search(".mz-price.is-saleprice").text.present?
          price = item.search(".mz-price.is-saleprice").text.strip.gsub!("$", '').to_f
        else
          price = item.search(".mz-price").text.strip.gsub!("$", '').to_f
        end

        # ap "#{name} - #{price} - #{link}"

        product = Product.find_or_create_by(name: name)

        if product.price.present? && product.price != price
          product.assign_attributes(old_price: product.price, price: price)
        else
          product.assign_attributes(price: price, link: link)
        end

        if product.changed?
          product.save
          puts "Updated #{name} - #{price}"
        end
      end

      puts "Finished checking GORUCK Inventory"
    end
  end
end
