# encoding: utf-8
module OrdersHelper

  def update_articles_link(order, text, view)
    link_to text, order_path(order, view: view), remote: true
  end

  def order_pdf(order, document, text)
    link_to text, order_path(order, document: document, format: :pdf), title: I18n.t('helpers.orders.order_pdf')
  end

  def options_for_suppliers_to_select
    options = [[I18n.t('helpers.orders.option_choose')]]
    options += Supplier.all.map {|s| [ s.name, url_for(action: "new", supplier_id: s)] }
    options += [[I18n.t('helpers.orders.option_stock'), url_for(action: 'new', supplier_id: 0)]]
    options_for_select(options)
  end

  def units_history_line(order_article)
    if order_article.order.open?
      nil
    else
      units_info = "#{order_article.units_to_order} ordered"
      units_info += ", #{order_article.units_billed} billed" unless order_article.units_billed.nil?
      units_info += ", #{order_article.units_received} received" unless order_article.units_received.nil?
    end
  end

  # can be article or article_price
  def pkg_helper(article, icon=true)
    if icon
      "<i class='package'> &times; #{article.unit_quantity}</i>".html_safe
    else
      "<span class='package'> &times; #{article.unit_quantity}</span>".html_safe
    end
  end
  
  def article_price_change_hint(order_article)
    return nil if order_article.article.price == order_article.article_price.price
    "<i class='icon icon-asterisk' title='#{j t('.old_price', default: 'Old price')}: #{number_to_currency order_article.article.price}'></i>".html_safe
  end
  
  def receive_input_field(form)
    order_article = form.object
    units_expected = (order_article.units_billed or order_article.units_to_order)
    form.text_field :units_received, class: 'input-nano package units_received',
      data: {'units-expected' => units_expected},
      readonly: order_article.result_manually_changed? ? "readonly" : nil,
      title: order_article.result_manually_changed? ? t('.locked_to_protect_manual_update') : nil,
      autocomplete: 'off'
  end
end
