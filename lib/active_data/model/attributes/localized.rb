module ActiveData
  module Model
    module Attributes
      class Localized < Base
        def read_value value, context
          Hash[(value.presence || {}).map { |locale, value| [locale.to_s, super(value, context)] }]
        end

        def read_value_before_type_cast value, context
          Hash[(value.presence || {}).map { |locale, value| [locale.to_s, super(value, context)] }]
        end

        def generate_instance_methods context
          context.class_eval <<-EOS
            def #{name}_translations
              read_attribute('#{name}')
            end

            def #{name}_translations= value
              write_attribute('#{name}', value)
            end

            def #{name}
              read_localized_attribute('#{name}')
            end

            def #{name}= value
              write_localized_attribute('#{name}', value)
            end

            def #{name}?
              read_localized_attribute('#{name}').present?
            end

            def #{name}_before_type_cast
              read_localized_attribute_before_type_cast('#{name}')
            end
          EOS
        end

        def generate_instance_alias_methods alias_name, context
          context.class_eval <<-EOS
            alias_method :#{alias_name}_translations, :#{name}_translations
            alias_method :#{alias_name}_translations=, :#{name}_translations=
            alias_method :#{alias_name}, :#{name}
            alias_method :#{alias_name}=, :#{name}=
            alias_method :#{alias_name}?, :#{name}?
            alias_method :#{alias_name}_before_type_cast, :#{name}_before_type_cast
          EOS
        end

        def generate_class_methods context
        end

        def generate_class_alias_methods alias_name, context
        end
      end
    end
  end
end
