require 'active_data/model/collectionizable/proxy'

module ActiveData
  module Model
    module Collectionizable
      extend ActiveSupport::Concern

      included do
        collectionize Array
      end

      module ClassMethods

        def collectionize collection_superclass = nil
          collection = Class.new(collection_superclass) do
            include ActiveData::Model::Collectionizable::Proxy
          end
          collection.collectible = self

          if anonymous?
            @collection_class = collection
          else
            remove_const :Collection if collection_class
            const_set :Collection, collection
          end
        end

        def respond_to? method
          super || collection_class.superclass.method_defined?(method)
        end

        def method_missing method, *args, &block
          collection_class.superclass.method_defined?(method) ?
            current_scope.send(method, *args, &block) :
            super
        end

        def collection source = nil
          collection_class.new source
        end

        def collection_class
          @collection_class ||= collection_class_name.safe_constantize
        end

        def collection_class_name
          "::#{name}::Collection"
        end

        def current_scope= value
          @current_scope = value
        end

        def current_scope
          @current_scope ||= collection(load)
        end
        alias :scope :current_scope

        def load; end

      end
    end
  end
end
