# frozen_string_literal: true

# Передача данных для печати этикетки
class SingleLabelPrintPresenter
  include ActiveModel::Model

  attr_reader :template_label_id

  validates :template_label_id, presence: true

  def initialize(hash_attributes = {})
    self.attributes = hash_attributes
  end

  def attributes=(hash)
    return unless hash

    @template_label_id = hash[:template_label_id]
  end
end
