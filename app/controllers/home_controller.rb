class HomeController < ShopifyApp::AuthenticatedController
  def index
    binding.pry if ENV['DEBUGGER'] == 'true'
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
  end
end
