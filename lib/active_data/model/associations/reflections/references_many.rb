module ActiveData
  module Model
    module Associations
      module Reflections
        class ReferencesMany < ReferenceReflection
          def self.build(target, generated_methods, name, *args, &block)
            reflection = super

            target.add_attribute(
              ActiveData::Model::Attributes::Reflections::ReferenceMany,
              reflection.reference_key, association: name
            )

            reflection
          end

          def collection?
            true
          end

          def reference_key
            @reference_key ||= options[:reference_key].presence.try(:to_sym) ||
              :"#{name.to_s.singularize}_#{primary_key.to_s.pluralize}"
          end
        end
      end
    end
  end
end
