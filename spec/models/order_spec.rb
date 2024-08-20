require 'rails_helper'

RSpec.describe Order, type: :model do
  customer = FactoryBot.create(:customer)
  subject { Order.new(product_name: "Book", product_count: 15, customer: customer) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a product_name" do
    subject.product_name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a product_count" do
    subject.product_count = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a customer_id" do
    subject.customer_id = nil
    expect(subject).to_not be_valid
  end
  it "is not valid if the product_count is not in (1..100000)" do
    subject.product_count = -1
    expect(subject).to_not be_valid
    subject.product_count = 0
    expect(subject).to_not be_valid
    subject.product_count = 100001
    expect(subject).to_not be_valid
  end
  it "is not valid if the product_count is not a numerical" do
    subject.product_count = "qere"
    expect(subject).to_not be_valid
  end
  it "is not valid if the customer_id is greater than 0" do
    subject.product_count = -1
    expect(subject).to_not be_valid
    subject.product_count = 0
    expect(subject).to_not be_valid
  end
  it "is not valid if the customer_id is not a numerical" do
    subject.customer_id = "qere"
    expect(subject).to_not be_valid
  end
end
