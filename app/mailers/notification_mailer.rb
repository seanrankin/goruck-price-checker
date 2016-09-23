class NotificationMailer < ApplicationMailer
  def send_digest(new_products, updated_products, restocked_products)
    @new_products = new_products
    @updated_products = updated_products
    @restocked_products = restocked_products
    mail(to: "Sean Rankin <sean.rankin@gmail.com>", subject: 'Hourly GORUCK Product Catalog Digest')
  end
end
