json.extract! product, :id, :price, :old_price, :link, :name, :created_at, :updated_at
json.url product_url(product, format: :json)