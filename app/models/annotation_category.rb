class AnnotationCategory < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.to_plugin_init
    AnnotationCategory.all.inject({}) { |h, ac| h[ac.id] = { "name" => ac.name, "hex" => ac.hex, "css_classes" => ac.css_classes }; h }.to_json
  end
end
