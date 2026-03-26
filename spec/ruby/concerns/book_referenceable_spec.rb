# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Tormenta20::Concerns::BookReferenceable do
  let(:classe) { Tormenta20::Models::Classe.first }

  describe "included in all models" do
    it "is included in Classe" do
      expect(Tormenta20::Models::Classe.ancestors).to include(described_class)
    end

    it "is included in Raca" do
      expect(Tormenta20::Models::Raca.ancestors).to include(described_class)
    end

    it "is included in Magia" do
      expect(Tormenta20::Models::Magia.ancestors).to include(described_class)
    end
  end

  describe "when no index entry exists" do
    before do
      allow(Tormenta20::Models::IndiceRemissivo).to receive(:includes).and_return(
        double(find_by: nil)
      )
    end

    it "#book_reference returns nil" do
      expect(classe.book_reference).to be_nil
    end

    it "#page returns nil" do
      expect(classe.page).to be_nil
    end

    it "#book returns nil" do
      expect(classe.book).to be_nil
    end

    it "#full_book returns nil" do
      expect(classe.full_book).to be_nil
    end
  end

  describe "when an index entry exists" do
    let(:livro) do
      double("Livro", nome_curto: "T20 - EJA", nome: "Tormenta 20 - Edição Jogo do Ano")
    end

    let(:entry) do
      double("IndiceRemissivo", pagina: 56, livro: livro)
    end

    before do
      allow(Tormenta20::Models::IndiceRemissivo).to receive(:includes).and_return(
        double(find_by: entry)
      )
    end

    it "#book_reference returns formatted string" do
      expect(classe.book_reference).to eq("T20 - EJA, p. 56")
    end

    it "#page returns the page number" do
      expect(classe.page).to eq(56)
    end

    it "#book returns the short book name" do
      expect(classe.book).to eq("T20 - EJA")
    end

    it "#full_book returns the full book name" do
      expect(classe.full_book).to eq("Tormenta 20 - Edição Jogo do Ano")
    end
  end

  describe "memoization" do
    it "only queries the database once per instance" do
      relation = double(find_by: nil)
      allow(Tormenta20::Models::IndiceRemissivo).to receive(:includes).and_return(relation)

      # Force fresh instance without memoized value
      fresh = Tormenta20::Models::Classe.first

      fresh.book_reference
      fresh.book_reference
      fresh.page

      expect(Tormenta20::Models::IndiceRemissivo).to have_received(:includes).once
    end
  end
end
