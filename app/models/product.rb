class Product < ApplicationRecord
  has_many :notifications, dependent: :destroy

  after_create :new_product_notification
  after_update :product_update_notification, :product_restock_notification

  def new_product_notification
    self.notifications.create!(:is_new => true)
  end

  def product_update_notification
    self.notifications.create!(:is_updated => true) if self.price_changed? && self.old_price.present?
  end

  def product_restock_notification
    self.notifications.create!(:is_restocked => true) if self.updated_at > 1.week.ago
  end
end
