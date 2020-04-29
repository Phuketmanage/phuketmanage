module DocumentsHelper

  def code owner
    houses = owner.houses
    if houses.count > 1
      code = owner.code
    else
      code = houses.first.code.gsub(/\//,'-')
    end
  end

end
