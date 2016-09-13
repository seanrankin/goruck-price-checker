namespace :inventory do
  desc "Check the product inventory."

  task check: :environment do
    require "mechanize"

    a = Mechanize.new { |agent|
      agent.user_agent_alias = "Windows IE 11"
      agent.follow_meta_refresh = true
    }

    link = "http://www.goruck.com/gear-we-build/c/97"
    # link = "https://dl.dropboxusercontent.com/u/21441346/goruck-temp.html"

    a.get(link) do | page |
      page.search(".mz-productlist-item").each do | item |
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
          product.update_attributes(old_price: product.price, price: price)
        else
          product.update_attributes(price: price, link: link)
        end
      end
    end
  end
end
