module FacetsConcern
  extend ActiveSupport::Concern

  def facet(symbol, label, path = nil, vm = nil, primary = false, active_bg = 'secondary')
    {sym: symbol, label: label, vm: vm, path: path, active: false, primary: primary, active_bg: active_bg}
  end

  def activate(facet_symbol, *facets)
    facets.map {|current| current[:sym] == facet_symbol ? current.merge({active: true}) : current}
  end

  def select_primary
    @facets.select {|face| face.key? :primary and face[:primary]}.first
  end

  def select_active
    @facets.select {|face| face.key? :active and face[:active]}.first
  end

end