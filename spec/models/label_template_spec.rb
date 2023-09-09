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

  describe 'template_type' do
    let!(:single_label_template) { FactoryBot.create :label_template, template_type: :single }
    let!(:multiple_label_template) { FactoryBot.create :label_template, template_type: :multiple }

    it { expect(described_class.single_templates.count).to eq(1) }
    it { expect(described_class.single_templates.first).to eq(single_label_template) }

    it { expect(described_class.multiple_templates.count).to eq(1) }
    it { expect(described_class.multiple_templates.first).to eq(multiple_label_template) }
  end
end
