require 'rails_helper'

RSpec.describe "/orders", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      orders = FactoryBot.create_list(:order, 10)
      get orders_path
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(assigns(:orders)).to eq(orders)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      order = FactoryBot.create(:order)
      get order_url(id: order.id)
      expect(response).to be_successful
      expect(response).to render_template(:show)
      expect(assigns(:order)).to eq(order)
    end
    it "redirects to the index path if the order id is invalid" do
      get order_path(id: 500000) # an ID that doesn't exist
      expect(response).to redirect_to orders_url
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_order_url
      expect(response).to be_successful
      expect(response).to render_template(:new)
      expect(assigns(:order)).to be_a_new(Order)
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      order = FactoryBot.create(:order)
      get edit_order_url(order)
      expect(response).to be_successful
      expect(response).to render_template(:edit)
      expect(assigns(:order)).to eq(order)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Order" do
        customer = FactoryBot.create(:customer)
        order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
        expect {
          post orders_url, params: { order: order_attributes }
        }.to change(Order, :count).by(1)
        expect(response).to redirect_to order_url(id: Order.last.id)
        expect(assigns(:order)).to be_a(Order)
        expect(assigns(:order)).to be_persisted
      end
    end

    context "with invalid parameters" do
      it "does not create a new Order" do
        order_attributes = FactoryBot.attributes_for(:order)
        expect {
          post orders_url, params: { order: order_attributes }
        }.to change(Order, :count).by(0)
        expect(response).to render_template(:new)
        expect(assigns(:order)).to_not be_persisted
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /update" do
    context "with valid parameters" do
      it "updates the requested order" do
        order = FactoryBot.create(:order)
        customer = FactoryBot.create(:customer)
        new_order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
        put order_url(order), params: { order: new_order_attributes }
        order.reload
        expect(order.product_name).to eq(new_order_attributes[:product_name])
        expect(order.product_count).to eq(new_order_attributes[:product_count])
        expect(order.customer_id).to eq(new_order_attributes[:customer_id])
        expect(response).to redirect_to(order_url(order))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        order = FactoryBot.create(:order)
        customer = FactoryBot.create(:customer)
        new_order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
        put order_url(order), params: { order: { product_count: 0 } }
        expect(order.product_count).not_to eq(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested order" do
      order = FactoryBot.create(:order)
      expect {
        delete order_url(order)
      }.to change(Order, :count).by(-1)
      expect(Order.exists?(order.id)).to be_falsey
      expect{ order.reload }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Order with 'id'=#{order.id}")
      expect(response).to redirect_to(orders_url)
    end
  end
end
