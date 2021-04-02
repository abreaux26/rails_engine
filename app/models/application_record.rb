class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.pagination(per_page, page)
    page = 1 if page < 1
    self.limit(per_page).offset((page - 1) * per_page)
  end
end
