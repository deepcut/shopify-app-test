class ShopifyAssetModifier
  def modify_theme
    ShopifyAPI::Asset.find('layout/theme.liquid').value
  end

  private

  def theme_partial(meta = '')
    <<~PARTIAL
      {%- if template.name == 'product' -%}
        <meta content="https://example.com/?meta=#{meta}" property="og:image">
      {%- endif -%}
    PARTIAL
  end
end
