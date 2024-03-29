# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"

    return unless user.present?

    if user.role?(:system_account_manager)
      can :manage, AdminUser, organization_id: user.organization_id
      can :manage, Role, organization_id: user.organization_id
      can :manage, LabelTemplate
      can :manage, LabelTemplateDecorator
    end

    if user.role?(:client_owner)
      can :manage, AdminUser, organization_id: user.organization_id
      can :manage, Role, organization_id: user.organization_id
      can %i[read update], Organization, id: user.organization_id
      can :manage, Building, organization_id: user.organization_id
      can :manage, BuildingPart, organization_id: user.organization_id
      can :manage, BuildingPartDecorator, organization_id: user.organization_id
      can :manage, Point, organization_id: user.organization_id
      can :manage, PointDecorator, organization_id: user.organization_id
      can :manage, Road, organization_id: user.organization_id
      can :manage, RoadDecorator, organization_id: user.organization_id
      can :read, Group, organization_id: user.organization_id
    end

    cannot :destroy, AdminUser, id: user.id # Нельзя удалить себя

    if user.role?(:system_admin)
      can :read, AdminUser
      can :read, Role
    end

    return unless user.role?(:system_manager)

    can :read, AdminUser
    can :read, Role
    can :read, Organization
    can :read, Building
    can :read, BuildingPart
    can :read, BuildingPartDecorator
    can :read, Point
    can :read, PointDecorator
    can :read, Road
    can :read, RoadDecorator
    can :read, Group
  end
end
