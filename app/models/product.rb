class Product < ActiveRecord::Base
  attr_accessible :description, :imageurl, :price, :size, :title
  validates_presence_of :title, :price, :description, :imageurl, :size
  validates :title, :uniqueness => true, :length => {:maximum => 50 }
  validates :description, :length => {
    :maximum   => 250,
    :tokenizer => lambda { |str| str.scan(/\w+/) },
    :too_long  => "must have at most %{count} words"
  }
  validates :price, :format => { :with => /\d+\.\d{0,2}/ }
  validates :size, :inclusion => {:in => %w(small medium large) }

  validate :has_a_valid_url, :has_a_valid_imageurl

  def has_a_valid_imageurl
    errors.add(:imageurl, "not an image") if imageurl.match(/(.jpg|.png|.gif)$/).nil?
  end

  def has_a_valid_url
    errors.add(:imageurl, "not a valid uri") if imageurl.match(URI::regexp(%w(http https))).nil? 
  end
end
