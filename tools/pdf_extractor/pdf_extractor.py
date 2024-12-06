"""
Extrator de texto do PDF do Tormenta 20.
Processa o índice e divide o conteúdo em seções para processamento.
"""

import pdfplumber
import re
from pathlib import Path
from typing import Generator
from dataclasses import dataclass


@dataclass
class TableOfContentsEntry:
    """Entrada do índice."""
    title: str
    page: int
    level: int  # 0 = capítulo, 1 = seção, 2 = subseção


class PDFExtractor:
    def __init__(self, pdf_path: str):
        self.pdf_path = Path(pdf_path)
        self.text = ""
        self.pages: list[dict] = []
        self.toc: list[TableOfContentsEntry] = []
        self.sections: dict = {}

    def extract(self) -> str:
        """Extrai todo o texto do PDF."""
        with pdfplumber.open(self.pdf_path) as pdf:
            for i, page in enumerate(pdf.pages):
                page_text = page.extract_text() or ""
                self.pages.append({
                    "number": i + 1,
                    "text": page_text
                })
                self.text += f"\n--- PÁGINA {i + 1} ---\n{page_text}"

        return self.text

    def extract_table_of_contents(self, toc_start_page: int = 3, toc_end_page: int = 6) -> list[TableOfContentsEntry]:
        """
        Extrai o índice do PDF.

        Args:
            toc_start_page: Página inicial do índice
            toc_end_page: Página final do índice

        Returns:
            Lista de entradas do índice
        """
        if not self.pages:
            self.extract()

        toc_text = self.get_pages_range(toc_start_page, toc_end_page)

        # Padrão para linhas do índice: "Título ... número" ou "Título número"
        # Captura títulos com páginas
        pattern = r'^(.+?)\s*\.{2,}\s*(\d+)\s*$|^(.+?)\s+(\d+)\s*$'

        entries = []
        for line in toc_text.split('\n'):
            line = line.strip()
            if not line:
                continue

            match = re.match(pattern, line)
            if match:
                if match.group(1):  # Padrão com pontos
                    title = match.group(1).strip()
                    page = int(match.group(2))
                else:  # Padrão sem pontos
                    title = match.group(3).strip()
                    page = int(match.group(4))

                # Determinar nível baseado em indentação ou formatação
                level = 0
                if line.startswith('  ') or line.startswith('\t'):
                    level = 1
                if line.startswith('    ') or line.startswith('\t\t'):
                    level = 2

                entries.append(TableOfContentsEntry(title=title, page=page, level=level))

        self.toc = entries
        return entries

    def build_sections_from_toc(self) -> dict:
        """
        Constrói o mapeamento de seções a partir do índice.

        Returns:
            Dicionário com seções e suas páginas
        """
        if not self.toc:
            self.extract_table_of_contents()

        sections = {}
        for i, entry in enumerate(self.toc):
            # Criar slug a partir do título
            slug = self._slugify(entry.title)

            # Determinar página final (próxima entrada ou fim do documento)
            if i + 1 < len(self.toc):
                end_page = self.toc[i + 1].page - 1
            else:
                end_page = len(self.pages)

            sections[slug] = {
                "title": entry.title,
                "start_page": entry.page,
                "end_page": end_page,
                "level": entry.level
            }

        self.sections = sections
        return sections

    def _slugify(self, text: str) -> str:
        """Converte texto para slug."""
        # Remove acentos
        replacements = {
            'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a', 'ä': 'a',
            'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
            'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
            'ó': 'o', 'ò': 'o', 'õ': 'o', 'ô': 'o', 'ö': 'o',
            'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
            'ç': 'c', 'ñ': 'n'
        }
        text = text.lower()
        for char, replacement in replacements.items():
            text = text.replace(char, replacement)

        # Remove caracteres especiais e substitui espaços
        text = re.sub(r'[^a-z0-9\s]', '', text)
        text = re.sub(r'\s+', '_', text.strip())
        return text

    def get_pages_range(self, start: int, end: int) -> str:
        """Retorna o texto de um intervalo de páginas."""
        return "\n".join(
            p["text"] for p in self.pages
            if start <= p["number"] <= end
        )

    def get_section_text(self, section_slug: str) -> str:
        """Retorna o texto de uma seção específica."""
        if not self.sections:
            self.build_sections_from_toc()

        if section_slug not in self.sections:
            # Tenta busca parcial
            matches = [k for k in self.sections.keys() if section_slug in k]
            if matches:
                section_slug = matches[0]
            else:
                raise ValueError(f"Seção não encontrada: {section_slug}")

        section = self.sections[section_slug]
        return self.get_pages_range(section["start_page"], section["end_page"])

    def list_sections(self) -> list[str]:
        """Lista todas as seções disponíveis."""
        if not self.sections:
            self.build_sections_from_toc()
        return list(self.sections.keys())

    def find_section(self, start_pattern: str, end_pattern: str = None) -> str:
        """Encontra uma seção do texto baseado em padrões."""
        start_match = re.search(start_pattern, self.text, re.IGNORECASE)
        if not start_match:
            return ""

        start_idx = start_match.start()

        if end_pattern:
            end_match = re.search(end_pattern, self.text[start_idx + 1:], re.IGNORECASE)
            end_idx = start_idx + 1 + end_match.start() if end_match else len(self.text)
        else:
            end_idx = len(self.text)

        return self.text[start_idx:end_idx]

    def split_by_headers(self, text: str, header_pattern: str) -> Generator[dict, None, None]:
        """Divide o texto por cabeçalhos."""
        matches = list(re.finditer(header_pattern, text, re.MULTILINE))

        for i, match in enumerate(matches):
            start = match.start()
            end = matches[i + 1].start() if i + 1 < len(matches) else len(text)

            yield {
                "header": match.group().strip(),
                "content": text[start:end].strip()
            }


# Padrões de cabeçalho por tipo de entidade
# Organizados por capítulo do livro
ENTITY_PATTERNS = {
    # ===========================================
    # CAPÍTULO 1: CONSTRUÇÃO DE PERSONAGEM
    # ===========================================

    # Raças (págs. 18-31)
    "racas": r"^([A-Z][a-zá-ú]+(?:/[a-zá-ú]+)?(?:\s+[A-Z][a-zá-ú]+)*)\n(?:Destreza|Força|Inteligência|Carisma|Constituição|Sabedoria|\+1)",

    # Classes (págs. 32-84)
    "classes": r"^(Arcanista|Bárbaro|Bardo|Bucaneiro|Caçador|Cavaleiro|Clérigo|Druida|Guerreiro|Inventor|Ladino|Lutador|Nobre|Paladino)\n",

    # Origens (págs. 85-95)
    "origens": r"^([A-Z][a-zá-ú]+(?:\s+(?:de\s+)?[a-zA-Zá-ú]+)*)\n(?:Você|Itens\.|Neste|Este|Esta)",

    # Deuses/Divindades (págs. 96-105)
    "divindades": r"^([A-Z][a-zá-ú]+(?:-[A-Z][a-zá-ú]+)?)\n(?:Crenças|Outrora|A Deusa|O Deus|Este|Esta|Também|Diz-se|Ainda)",

    # ===========================================
    # CAPÍTULO 2: PERÍCIAS & PODERES
    # ===========================================

    # Perícias (págs. 114-123)
    "pericias": r"^([A-Z][a-zá-ú]+)\s+(For|Des|Int|Sab|Car|Con)(?:\s+[•·])?",

    # Poderes Gerais (págs. 124-137)
    "poderes": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito|Uma vez|No início|Durante)",

    # Poderes de Combate (págs. 124-128)
    "poderes_combate": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito|Uma vez)",

    # Poderes de Destino (págs. 129-130)
    "poderes_destino": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito)",

    # Poderes de Magia (págs. 131)
    "poderes_magia": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito)",

    # Poderes Concedidos (págs. 132-135)
    "poderes_concedidos": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito|Uma vez|No início)",

    # Poderes da Tormenta (págs. 136-137)
    "poderes_tormenta": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Você|Quando|Sua|Seu|Pré-requisito|Uma vez)",

    # ===========================================
    # CAPÍTULO 3: EQUIPAMENTO
    # ===========================================

    # Armas (págs. 142-151) - geralmente em tabelas
    "armas": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s+T\$\s*\d+",

    # Armaduras & Escudos (págs. 152-154)
    "armaduras": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s+T\$\s*\d+",

    # Itens Gerais (págs. 155-163)
    "itens_gerais": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*[\.:]?\s*(?:T\$|Este|Esta|Um|Uma|Você)",

    # Itens Superiores (págs. 164-167)
    "itens_superiores": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*[\.:]?\s*(?:T\$|Este|Esta|Um|Uma|Arma|Armadura)",

    # ===========================================
    # CAPÍTULO 4: MAGIA
    # ===========================================

    # Magias (págs. 178-211)
    "magias": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Arcana|Divina|Universal)",

    # ===========================================
    # CAPÍTULO 7: AMEAÇAS
    # ===========================================

    # Criaturas/Monstros (págs. 282-316)
    "criaturas": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s+ND\s*\d+",

    # Perigos (págs. 317-321)
    "perigos": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n(?:Este|Esta|Um|Uma|Perigo|Armadilha)",

    # ===========================================
    # CAPÍTULO 8: RECOMPENSAS
    # ===========================================

    # Tesouros (págs. 327-332)
    "tesouros": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*[\.:]?\s*(?:T\$|Este|Esta|Um|Uma)",

    # Itens Mágicos - Armas (págs. 335-337)
    "itens_magicos_armas": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*(?:\([^)]+\))?\s*\n(?:Esta arma|Este|Arma)",

    # Itens Mágicos - Armaduras (págs. 338-340)
    "itens_magicos_armaduras": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*(?:\([^)]+\))?\s*\n(?:Esta armadura|Este escudo|Armadura|Escudo)",

    # Poções & Pergaminhos (págs. 341)
    "pocoes_pergaminhos": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*(?:\([^)]+\))?\s*\n(?:Esta poção|Este pergaminho|Poção|Pergaminho)",

    # Acessórios (págs. 342-345)
    "acessorios": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*(?:\([^)]+\))?\s*\n(?:Este|Esta|Um|Uma|Anel|Amuleto|Botas|Capa|Manto)",

    # Artefatos (págs. 346-349)
    "artefatos": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\s*(?:\([^)]+\))?\s*\n(?:Este|Esta|Um|Uma|Artefato|Lendário)",

    # ===========================================
    # OUTROS
    # ===========================================

    # Condições (pág. 394)
    "condicoes": r"^([A-Z][a-zá-ú]+)\s*[\.:]?\s*(?:você|uma criatura|o personagem|a criatura)",

    # Padrão genérico - fallback
    "generico": r"^([A-Z][a-zá-ú]+(?:\s+[a-zA-Zá-ú]+)*)\n"
}

# Mapeamento de seções do sumário para tipos de entidade
SECTION_TO_ENTITY_TYPE = {
    "racas": "racas",
    "raças": "racas",
    "humano": "racas",
    "anao": "racas",
    "classes": "classes",
    "arcanista": "classes",
    "barbaro": "classes",
    "origens": "origens",
    "deuses": "divindades",
    "pericias": "pericias",
    "poderes_gerais": "poderes",
    "poderes_de_combate": "poderes_combate",
    "poderes_de_destino": "poderes_destino",
    "poderes_de_magia": "poderes_magia",
    "poderes_concedidos": "poderes_concedidos",
    "poderes_da_tormenta": "poderes_tormenta",
    "armas": "armas",
    "armaduras_escudos": "armaduras",
    "itens_gerais": "itens_gerais",
    "itens_superiores": "itens_superiores",
    "descricao_das_magias": "magias",
    "criaturas": "criaturas",
    "perigos": "perigos",
    "tesouros": "tesouros",
    "itens_magicos": "itens_magicos_armas",  # default
    "pocoes_pergaminhos": "pocoes_pergaminhos",
    "acessorios": "acessorios",
    "artefatos": "artefatos",
    "lista_de_condicoes": "condicoes",
}


def extract_entities(pdf_path: str, section_name: str, entity_type: str = None) -> list[dict]:
    """
    Extrai entidades de uma seção específica do PDF.

    Args:
        pdf_path: Caminho para o PDF
        section_name: Nome/slug da seção (do índice)
        entity_type: Tipo de entidade para usar padrão correto (opcional).
                     Se não especificado, tenta inferir pelo nome da seção.

    Returns:
        Lista de dicionários com header e content de cada entidade
    """
    extractor = PDFExtractor(pdf_path)
    extractor.extract()
    extractor.build_sections_from_toc()

    section_text = extractor.get_section_text(section_name)

    # Tentar inferir tipo de entidade pelo nome da seção
    if not entity_type:
        # Busca no mapeamento
        section_lower = section_name.lower()
        for key, value in SECTION_TO_ENTITY_TYPE.items():
            if key in section_lower or section_lower in key:
                entity_type = value
                break

    # Usar padrão específico ou genérico
    if entity_type and entity_type in ENTITY_PATTERNS:
        pattern = ENTITY_PATTERNS[entity_type]
    else:
        # Padrão genérico: linha começando com maiúscula seguida de quebra
        pattern = ENTITY_PATTERNS["generico"]

    entities = list(extractor.split_by_headers(section_text, pattern))
    return entities


def list_available_sections(pdf_path: str, toc_start: int = 3, toc_end: int = 6) -> dict:
    """
    Lista todas as seções disponíveis no PDF.

    Args:
        pdf_path: Caminho para o PDF
        toc_start: Página inicial do índice
        toc_end: Página final do índice

    Returns:
        Dicionário com seções e suas informações
    """
    extractor = PDFExtractor(pdf_path)
    extractor.extract()
    extractor.extract_table_of_contents(toc_start, toc_end)
    return extractor.build_sections_from_toc()


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Uso:")
        print("  python pdf_extractor.py <caminho_pdf> --list-sections")
        print("  python pdf_extractor.py <caminho_pdf> <secao> [tipo_entidade]")
        print(f"\nTipos de entidade disponíveis: {list(ENTITY_PATTERNS.keys())}")
        sys.exit(1)

    pdf_path = sys.argv[1]

    if len(sys.argv) >= 3 and sys.argv[2] == "--list-sections":
        # Listar seções
        toc_start = int(sys.argv[3]) if len(sys.argv) > 3 else 3
        toc_end = int(sys.argv[4]) if len(sys.argv) > 4 else 6

        sections = list_available_sections(pdf_path, toc_start, toc_end)
        print("\nSeções encontradas no índice:")
        print("=" * 60)
        for slug, info in sections.items():
            print(f"{slug}: páginas {info['start_page']}-{info['end_page']} ({info['title']})")
        sys.exit(0)

    if len(sys.argv) < 3:
        print("Erro: especifique a seção ou use --list-sections")
        sys.exit(1)

    section = sys.argv[2]
    entity_type = sys.argv[3] if len(sys.argv) > 3 else None

    entities = extract_entities(pdf_path, section, entity_type)

    print(f"\nEncontradas {len(entities)} entidades na seção '{section}':")
    print("=" * 60)

    for entity in entities:
        print(f"\n{'='*50}")
        print(f"ENTIDADE: {entity['header']}")
        print(f"{'='*50}")
        preview = entity['content'][:500]
        print(preview + ("..." if len(entity['content']) > 500 else ""))
