# How to alter the header meta tag

## 1. Authenticate into developer store

1. Visit developer account at: [developers.shopify.com](developers.shopify.com)
2. Log in
3. On the left-hand side, click "Development stores"
4. Click the first store and make sure it works.
5. Future apps + plugins will appear under "Apps" on the lower left

## 2. Access theme file via API

1. Make sure your `.env` file is present and has these vars

```
SHOPIFY_API_KEY=XXXXXXXXXXXXXXX
SHOPIFY_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

2. Visit `localhost:3000` and type in the store URL - `bicep-photography.myshopify.com`. This will be stored as a `Shop` record in the db.
2. When you hit localhost:3000, the session will already be authenticated with the store. You can start playing around by putting `binding.pry` in `HomeController#index`.

## 3. Figure out how to modify the theme file and re-upload it into the user's store

1. Get the current liquid file by

```
res = ShopifyAPI::Asset.find('layout/theme.liquid')
res.value
```

2. Figure out a way to insert a meta tag RIGHT after the `<head>` tag as follows:

```
{%- if template.name == 'product' -%}
  <meta content="https://example.com/?meta=#{some_key_product_info}" property="og:image">
{%- endif -%}
```

3. Encode some key product info into the `?meta` key, such as title, description, and price. If you wanna see how it's done in the liquid code, take a look by typing the following. This is key b/c the returned image will contain info given in the meta key.

`ShopifyAPI::Asset.find('snippets/social-meta-tags.liquid').value`

4. For further info on the "Assets" API, take a look at

- [Stackoverflow answer on how to do it](http://stackoverflow.com/questions/30883360/modify-theme-liquid-using-shopify-api), [forum answer](https://ecommerce.shopify.com/c/shopify-apis-and-technology/t/modifying-the-product-liquid-asset-via-api-195867)
- [Shopify API doc on how to modify theme assets](https://help.shopify.com/api/reference/asset)
- [Shopify gem repo](https://github.com/Shopify/shopify_api)
- [Gem doc](http://www.rubydoc.info/github/Shopify/shopify_api/ShopifyAPI/Asset)

5. Once you figure out how to do this, you could put a button in the Home#index view that hits another route, which will do the modification.

## 5. Acceptance criteria

1. When the shop owner clicks on a button, our app should modify his app's theme file by inserting the meta tag specified above.
2. ONLY on individual product pages, we should see a `og:image` meta tag right before the `</head>` tag.

## Keep in mind

- Make sure to preserver the original liquid theme value just in case we need to revert.

----

## Facebook open graph testing/debugging

* https://developers.facebook.com/tools/debug/og/object
* Paste the URL
* See the raw tags that were found

## API Usage Notes:

* Direct API usage For a private app:
  ```ruby
  shop_url = "https://#{ENV.fetch('SHOPIFY_API_KEY')}:#{ENV.fetch('SHOPIFY_SECRET')}@bicep-photography.myshopify.com/admin"
  ShopifyAPI::Base.site = shop_url
  shop = ShopifyAPI::Shop.current


  # Example: Get a specific product
  product_id = 9221550217
  product = ShopifyAPI::Product.find(product_id)

  ```

## Modifying a template via the API:

```ruby
 theme = ShopifyAPI::Asset.find('layout/theme.liquid')
new_theme_value = "<!-- this comment  was added via the API -->\n" + theme.value
theme.value = new_theme_value
theme.save!
```

## Imgix

* https://blog.imgix.com/2016/03/01/base64-encoding.html?_ga=1.248501184.679897000.1490296588 
* Imgix.js - https://github.com/imgix/imgix.js/#base-64-encoded-parameters
* Some non-base-64 examples with blends and marks: http://htmlpreview.github.io/?https://github.com/deepcut/shopify-app-test/blob/master/public/imgix-non-base64-example.html

Using third-party images:
* https://docs.imgix.com/setup/serving-images
* https://docs.imgix.com/setup/securing-images
* https://freakdesign.com.au/blogs/news/76831303-use-your-own-domain-instead-of-shopify-cdn-in-image-urls
* https://help.shopify.com/api/tutorials/application-proxies

## Warning about editing Themes

* [Don't Edit Theme Files](https://help.shopify.com/api/sdks/shopify-apps/modifying-online-store/use-javascript-responsibly)
* [Use a ScriptTag](https://help.shopify.com/api/reference/scripttag)

## Shopify

Liquid references:

* http://cheat.markdunkley.com/
* https://help.shopify.com/themes/liquid/filters/string-filters#url_param_escape
* https://help.shopify.com/themes/liquid/filters/url-filters#img_url
