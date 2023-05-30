# frozen_string_literal: true

# Запись для сохранения данный о пользователи
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :registerable

  belongs_to :organization
  has_many :roles, dependent: :destroy

  accepts_nested_attributes_for :roles, allow_destroy: true

  def role?(name)
    roles.where(name:).any?
  end
end
