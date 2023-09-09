# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelTemplate, type: :model do
  describe 'factory' do
    let!(:label_template) { FactoryBot.create :label_template }

    # Factories
    it { expect(label_template).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }
  end
end
