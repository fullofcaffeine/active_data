module ActiveData
  module Model
    module Associations
      class ReferenceAssociation < Base
      private

        def build_object(attributes)
          reflection.klass.new(attributes)
        end
      end
    end
  end
end
