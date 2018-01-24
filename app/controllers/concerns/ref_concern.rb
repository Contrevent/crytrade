module RefConcern
  extend ActiveSupport::Concern

  def ref_char
    current_user != nil ? current_user.reference_character : '$'
  end

  def usd_to_ref_norm(usd_value)
    unless is_number? usd_value
      return usd_value
    end
    num_norm(ref_value(usd_value))
  end

  def usd_to_ref_fine(usd_value)
    unless is_number? usd_value
      return usd_value
    end
    num_fine(ref_value(usd_value))
  end


  def num_norm(value)
    value.round(reference_precision)
  end


  def num_fine(value)
    value.round(reference_precision + 2)
  end

  def ref_coin
    current_user != nil ? current_user.reference_symbol : 'USD'
  end

  private

  def reference_precision
    current_user != nil ? current_user.reference_precision : 2
  end

  def ref_value(usd_value)
    if ref_coin != 'USD'
      rate = TickerConcern::last_price_usd(ref_coin)
      if rate != -1
        usd_value * rate
      else
        'n.a.'
      end
    else
      usd_value
    end
  end

  def is_number? string
    true if Float(string) rescue false
  end

end