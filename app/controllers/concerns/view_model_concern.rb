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
    p Tile.kinds
    Tile.kinds
  end



  def populate_locals(vm)
    locals = {}
    if vm.key? :model
      locals = {model: vm[:model]}
    end
    if vm.key? :locals
      locals = locals.merge(vm[:locals])
    end
    p "Locals: #{vm[:view]}, #{locals}"
    locals
  end

  def create_vm(kind, view, width, height, model)
    title = kind_options[kind]
    {kind: kind, view: view, class: (get_col_class width, height), model: model, title: title}
  end

  private

  def get_col_class(width, height)
    "col-#{width} ct-h-#{height}"
  end

end