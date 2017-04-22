ShopifyApp.configure do |config|
  config.application_name = 'Mega Tags'
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_SECRET']
  config.scope = 'read_products, read_themes, write_themes'
  config.embedded_app = true
end
