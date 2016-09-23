namespace :notification do
  desc "Send GORUCK Product Digest"
  task send: :environment do
    puts "Checking for GORUCK product catalog updates..."
    @new_products = Notification.where(:is_new => true, :is_sent => false) || null
    @updated_products = Notification.where(:is_updated => true, :is_sent => false) || null
    @restocked_products = Notification.where(:is_restocked => true, :is_sent => false) || null

    if @new_products.length > 0 || @updated_products.length > 0 || @restocked_products.length > 0
      puts "Generating the GORUCK digest email..."
      NotificationMailer.send_digest(@new_products, @updated_products, @restocked_products).deliver_now
    end
  end
end
