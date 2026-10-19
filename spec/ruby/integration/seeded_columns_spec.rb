# frozen_string_literal: true

require_relative "../spec_helper"

# Columns whose source JSON key differs from the column name, or that bin/build_db used to drop.
RSpec.describe "Seeded columns" do
  def find(model, id)
    Tormenta20::Models.const_get(model).find(id)
  end

  it "escudo properties come from especial" do
    expect(find(:Escudo, "escudo_leve").properties).not_to be_empty
  end

  it "material especial price_modifier comes from precos_adicionais" do
    expect(find(:MaterialEspecial, "adamante").price_modifier).to include("arma" => 3000)
    expect(find(:MaterialEspecial, "adamante").applicable_to).to eq([])
  end

  it "melhoria applicable_to is a flat list of categorias" do
    expect(find(:Melhoria, "inscrito").applicable_to).to eq(%w[arma armadura escudo ferramenta vestuario])
  end

  it "poder keeps costs" do
    expect(find(:Poder, "barreira_mistica").costs).to eq([{ "value" => 1, "type" => "PM" }])
  end

  it "poderes imported without effects or prerequisites default to empty arrays" do
    expect(find(:Poder, "dom_da_ressurreicao").effects).to eq([])
    expect(find(:Poder, "advocacia").prerequisites).to eq([])
  end
end
