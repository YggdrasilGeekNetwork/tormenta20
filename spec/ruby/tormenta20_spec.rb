# frozen_string_literal: true

RSpec.describe Tormenta20 do
  it "has a version number" do
    expect(Tormenta20::VERSION).not_to be_nil
  end

  describe ".setup" do
    it "connects to the database" do
      expect(Tormenta20::Database).to be_connected
    end
  end

  describe "Models" do
    it "exposes all model classes" do
      expect(Tormenta20::Models::Origem).to be_a(Class)
      expect(Tormenta20::Models::Poder).to be_a(Class)
      expect(Tormenta20::Models::Divindade).to be_a(Class)
      expect(Tormenta20::Models::Classe).to be_a(Class)
      expect(Tormenta20::Models::Magia).to be_a(Class)
      expect(Tormenta20::Models::Escudo).to be_a(Class)
      expect(Tormenta20::Models::MaterialEspecial).to be_a(Class)
      expect(Tormenta20::Models::Regra).to be_a(Class)
    end
  end
end
