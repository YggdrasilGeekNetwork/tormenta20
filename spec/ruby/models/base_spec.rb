# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Models::Base do
  let(:model) { Tormenta20::Models::Origem }
  let(:record) { model.first }

  describe "read-only enforcement" do
    it "raises ReadOnlyError on save" do
      expect { record.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it "raises ReadOnlyError on destroy" do
      expect { record.destroy }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on create" do
      expect { model.create(id: "test", name: "Test") }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on delete_all" do
      expect { model.delete_all }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on destroy_all" do
      expect { model.destroy_all }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on update_all" do
      expect { model.update_all(name: "hacked") }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on insert" do
      expect { model.insert({ id: "test", name: "Test" }) }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end

    it "raises ReadOnlyError on upsert" do
      expect { model.upsert({ id: "test", name: "Test" }) }.to raise_error(Tormenta20::Models::Base::ReadOnlyError)
    end
  end

  describe "read operations still work" do
    it "can query all records" do
      expect(model.count).to be_positive
    end

    it "can find by id" do
      expect(model.first).not_to be_nil
    end

    it "can chain scopes" do
      expect(model.where("id IS NOT NULL").count).to be_positive
    end
  end
end
