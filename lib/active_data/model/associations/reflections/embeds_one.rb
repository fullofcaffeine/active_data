module ActiveData
  module Model
    module Associations
      module Reflections
        class EmbedsOne < Base
          def self.build(target, generated_methods, name, options = {}, &block)
            if target < ActiveData::Model::Attributes
              target.add_attribute(ActiveData::Model::Attributes::Reflections::Base, name)
            end
            options[:validate] = true unless options.key?(:validate)
            super
          end

          def self.generate_methods(name, target)
            super

            target.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def build_#{name} attributes = {}
                association(:#{name}).build(attributes)
              end

              def create_#{name} attributes = {}
                association(:#{name}).create(attributes)
              end

              def create_#{name}! attributes = {}
                association(:#{name}).create!(attributes)
              end
            RUBY
          end

          def collection?
            false
          end

          def embedded?
            true
          end
        end
      end
    end
  end
end
