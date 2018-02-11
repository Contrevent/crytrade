module ViewModelConcern
  extend ActiveSupport::Concern

  def populate(*view_models)
    @view_model = view_models
  end

  def populate_by_array(vms)
    @view_model = vms
  end

  def find_vm_by_kind(kind)
    @view_model.select {|vm| vm[:kind] == kind}.first
  end

  def kind_options
    Tile.kinds.map {|opt| opt.reverse}
  end

  def populate_locals(vm, options = nil)
    locals = {}
    if vm.key? :model
      locals = {model: vm[:model]}
    end
    if vm.key? :locals and vm[:locals] != nil
      locals = locals.merge(vm[:locals])
    end
    if options != nil
      locals = locals.merge(options)
    end
    p "Locals: #{vm[:view]}, #{locals}"
    locals
  end

  def create_vm(kind, view, width, height, model, locals = nil)
    title = Tile.kinds[kind]
    {kind: kind, view: view, class: (get_col_class width, height), model: model, locals: locals, title: title}
  end

  private

  def get_col_class(width, height)
    "col-12 col-lg-#{width} ct-h-#{height}"
  end

end
