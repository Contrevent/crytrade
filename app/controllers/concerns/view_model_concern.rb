module ViewModelConcern
  extend ActiveSupport::Concern

  def populate(*view_models)
    @view_model = view_models
  end

  def find_vm_by_kind(kind)
    @view_model.select {|vm| vm[:kind] == kind}.first
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

  def create_vm(kind, view, width, model)
    {kind: kind, view: view, class: (get_col_class width), model: model}
  end

  private

  def get_col_class(width)
    "col-xl-#{width}"
  end

end