module ActiveData
  module Model
    module Validations
      class NestedValidator < ActiveModel::EachValidator
        def self.validate_nested(record, name, value)
          if value.is_a?(Enumerable)
            value.each.with_index do |object, i|
              if yield(object)
                object.errors.each do |key, message|
                  key = "#{name}.#{i}.#{key}"
                  record.errors[key] << message
                  record.errors[key].uniq!
                end
              end
            end
          elsif value && yield(value)
            value.errors.each do |key, message|
              key = "#{name}.#{key}"
              record.errors[key] << message
              record.errors[key].uniq!
            end
          end
        end

        def validate_each(record, attribute, value)
          self.class.validate_nested(record, attribute, value, &:invalid?)
        end
      end

      module HelperMethods
        def validates_nested(*attr_names)
          validates_with NestedValidator, _merge_attributes(attr_names)
        end
      end
    end
  end
end
