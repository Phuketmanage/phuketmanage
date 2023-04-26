module DocumentsHelper
  def code(owner)
    houses = owner.houses
    code = if houses.count > 1 || owner.code.present?
      owner.code
    else
      houses.first.code.tr('/', '-')
    end
  end
end
