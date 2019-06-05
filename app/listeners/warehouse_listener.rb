class WarehouseListener
  class << self
    attr_reader :warehouse

    def set_warehouse_slug(warehouse_id)
      warehouse = Warehouse.find(warehouse_id)
      warehouse.slug = "#{warehouse.name.parameterize.gsub('-', '_')}_#{warehouse.id}"
      warehouse.save
    end
  end
end
