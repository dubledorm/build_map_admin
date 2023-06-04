# frozen_string_literal: true

require 'rails_helper'
require 'rule_list/base_rule'
require 'rule_list/rule_list'
require 'rule_list/rule_list_item'

class RuleTrue < BaseRule
  def self.valid?(_checked_object)
    true
  end
end

class RuleFalse < BaseRule
  def self.valid?(_checked_object)
    false
  end
end


RSpec.describe RuleList do
  let(:rule_list) do
    RuleList.new(
      [RuleListItem.new(RuleTrue, 'message true'),
       RuleListItem.new(RuleFalse, 'message false')]
    )
  end

  let(:rule_list_true) do
    RuleList.new(
      [RuleListItem.new(RuleTrue, 'message true 1'),
       RuleListItem.new(RuleTrue, 'message true 2')]
    )
  end


  it { expect(rule_list.valid?(nil)).to be_falsey }
  it 'should fills errors' do
    rule_list.valid?(nil)
    expect(rule_list.errors).to eq(['message false'])
  end

  it { expect(rule_list_true.valid?(nil)).to be_truthy }
  it 'should fills errors' do
    rule_list_true.valid?(nil)
    expect(rule_list_true.errors).to eq([])
  end
end
