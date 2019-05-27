class CurrentApplication
  def self.name
    Rails.application.class.parent_name
  end
end
