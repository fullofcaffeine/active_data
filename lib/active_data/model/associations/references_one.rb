module ActiveData
  module Model
    module Associations
      class ReferencesOne < ReferenceAssociation
        def build(attributes = {})
          self.target = build_object(attributes)
        end

        def create(attributes = {})
          build(attributes).tap(&:save)
        end

        def create!(attributes = {})
          build(attributes).tap(&:save!)
        end

        def apply_changes
          if target
            if target.marked_for_destruction? && reflection.autosave?
              target.destroy
            elsif target.new_record? || (reflection.autosave? && target.changed?)
              target.save
            else
              true
            end
          else
            true
          end
        end

        def target=(object)
          loaded!
          @target = object
        end

        def load_target
          source = read_source
          source ? scope(source).first : default
        end

        def default
          return if evar_loaded?
          default = reflection.default(owner) or return

          case default
          when reflection.klass
            default
          when Hash
            build_object(default)
          else
            scope(default).first
          end
        end

        def read_source
          attribute.read_before_type_cast
        end

        def write_source(value)
          attribute.write_value value
        end

        def reader(force_reload = false)
          reset if force_reload
          target
        end

        def replace(object)
          unless object.nil? || object.is_a?(reflection.klass)
            raise AssociationTypeMismatch.new(reflection.klass, object.class)
          end

          transaction do
            attribute.pollute do
              self.target = object
              write_source identify
            end
          end

          target
        end
        alias_method :writer, :replace

        def scope(source = read_source)
          reflection.scope(owner).where(reflection.primary_key => source)
        end

        def identify
          target.try(reflection.primary_key) if target.try(:persisted?)
        end

      private

        def attribute
          @attribute ||= owner.attribute(reflection.reference_key)
        end
      end
    end
  end
end
