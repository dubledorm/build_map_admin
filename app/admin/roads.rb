ActiveAdmin.register Road do
  permit_params :point1_id, :point2_id, :weight, :organization_id, :building_part_id, :road_type
  decorate_with RoadDecorator
  belongs_to :building
  includes :organization, :building, :building_part

  form title: Road.model_name.human do |f|
    f.semantic_errors *f.object.errors
    inputs do
      f.input :road_type, as: :select, collection: RoadDecorator.road_types
      f.input :point1, as: :select, collection: RoadDecorator.points(building)
      f.input :point2, as: :select, collection: RoadDecorator.points(building)
      f.input :weight
    end

    f.actions
  end

  show do
    panel Road.model_name.human do
      attributes_table_for road do
        row :organization
        row :building
        row :building_part
        row :point1
        row :point2
        row :road_type
        row :weight
        row :created_at
        row :updated_at
      end
    end
  end

  controller do
    def create
      @road = Road.new(params.required(:road).permit(:point1_id, :point2_id, :weight, :road_type))
      @point1 = Point.find(params.required(:road).required(:point1_id))
      @point1.building_part.roads << @road
      create! { admin_building_part_path(@point1.building_part_id) }
    end
  end
end
