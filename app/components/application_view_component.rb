# frozen_string_literal: true

# Base class for view components
class ApplicationViewComponent < ViewComponent::Base
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
end

