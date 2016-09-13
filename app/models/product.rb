class Product < ApplicationRecord
  after_create :send_new_product_notification
  after_update :send_product_update_notification, :send_product_restock_notification

  def send_new_product_notification
    body = "The #{self.name} is now available for sale on the web at: "
    body += "\n"
    body += "http://www.goruck.com/#{self.link}"

    ActionMailer::Base.mail(
      :from => "Sean Rankin <sean.rankin@gmail.com>",
      :to => "GORUCK inventory <sean.rankin@gmail.com>",
      :subject => "New GORUCK product available notification: #{self.name}",
      :body => body
    ).deliver
  end

  def send_product_update_notification
    if self.price_changed? && self.old_price.present?
      body = "The #{self.name} is now on sale at a lower price of #{self.price}. "
      body = "This represents a discount of $#{self.old_price - self.price}."
      body += "\n"
      body += "http://www.goruck.com/#{self.link}"

      ActionMailer::Base.mail(
        :from => "Sean Rankin <sean.rankin@gmail.com>",
        :to => "GORUCK inventory <sean.rankin@gmail.com>",
        :subject => "GORUCK product sale notification: #{self.name}",
        :body => body
      ).deliver
    end
  end

  def send_product_restock_notification
    if self.updated_at < 7.days.ago
      body = "The #{self.name} has been restocked at the price of $#{self.price}. "
      body += "\n"
      body += "http://www.goruck.com/#{self.link}"

      ActionMailer::Base.mail(
        :from => "Sean Rankin <sean.rankin@gmail.com>",
        :to => "GORUCK inventory <sean.rankin@gmail.com>",
        :subject => "GORUCK restock notification: #{self.name}",
        :body => body
      ).deliver
    end
  end
end
