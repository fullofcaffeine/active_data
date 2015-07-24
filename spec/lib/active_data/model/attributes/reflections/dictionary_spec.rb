require 'spec_helper'

describe ActiveData::Model::Attributes::Reflections::Dictionary do
  def reflection(options = {})
    described_class.new(:field, options)
  end

  describe '.build' do
    before { stub_class(:target) }
    specify do
      described_class.build(Target, :field)

      expect(Target).to be_method_defined(:field)
      expect(Target).to be_method_defined(:field=)
      expect(Target).to be_method_defined(:field?)
      expect(Target).to be_method_defined(:field_before_type_cast)
      expect(Target).to be_method_defined(:field_default)
      expect(Target).to be_method_defined(:field_values)
    end
  end

  describe '#keys' do
    specify { expect(reflection.keys).to eq([]) }
    specify { expect(reflection(keys: ['a', :b]).keys).to eq(%w[a b]) }
    specify { expect(reflection(keys: :c).keys).to eq(%w[c]) }
  end

  describe '#alias_attribute' do
    before { stub_class(:target) }

    specify do
      described_class.build(Target, :field).alias_attribute(:field_alias, Target)

      expect(Target).to be_method_defined(:field_alias)
      expect(Target).to be_method_defined(:field_alias=)
      expect(Target).to be_method_defined(:field_alias?)
      expect(Target).to be_method_defined(:field_alias_before_type_cast)
      expect(Target).to be_method_defined(:field_alias_default)
      expect(Target).to be_method_defined(:field_alias_values)
    end
  end
end
