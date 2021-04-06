class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.pagination(per_page, page)
    page = 1 if page < 1
    limit(per_page).offset((page - 1) * per_page)
  end

  def self.search_by_name(name)
    where("lower(name) LIKE '%#{name}%'").order(:name)
  end
end
