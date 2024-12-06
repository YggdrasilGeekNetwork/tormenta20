# PDF Extractor - Tormenta 20

Pipeline para extrair dados estruturados do PDF do Tormenta 20 e convertê-los em JSON usando um modelo LLM local (Ollama).

## Requisitos

### Sistema
- Python 3.10+
- GPU com 12GB+ VRAM (recomendado) ou CPU com 32GB+ RAM

### Ollama
```bash
# Instalar Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Baixar modelo recomendado
ollama pull mistral
# ou
ollama pull llama3
```

### Dependências Python
```bash
cd tools/pdf_extractor
pip install -r requirements.txt
```

## Uso

### 1. Listar seções disponíveis no PDF

```bash
python pdf_extractor.py tormenta20.pdf --list-sections
```

Saída esperada:
```
Seções encontradas no índice:
============================================================
racas: páginas 18-31 (Raças)
classes: páginas 32-84 (Classes)
origens: páginas 85-95 (Origens)
deuses: páginas 96-105 (Deuses)
...
```

### 2. Extrair entidades (dry-run)

Veja quais entidades serão extraídas sem processá-las:

```bash
python pipeline.py tormenta20.pdf racas racas --dry-run
```

### 3. Extrair e gerar JSONs

```bash
# Extrair todas as raças
python pipeline.py tormenta20.pdf racas racas

# Extrair classes com modelo específico
python pipeline.py tormenta20.pdf classes classes --model llama3

# Especificar diretório de saída
python pipeline.py tormenta20.pdf magias magias --output-dir ../../src/json/magias
```

## Tipos de Entidade Disponíveis

| Tipo | Descrição | Páginas (aprox.) |
|------|-----------|------------------|
| `racas` | Raças jogáveis | 18-31 |
| `classes` | Classes de personagem | 32-84 |
| `origens` | Origens de personagem | 85-95 |
| `divindades` | Deuses do panteão | 96-105 |
| `pericias` | Perícias | 114-123 |
| `poderes` | Poderes gerais | 124-137 |
| `poderes_combate` | Poderes de combate | 124-128 |
| `poderes_destino` | Poderes de destino | 129-130 |
| `poderes_magia` | Poderes de magia | 131 |
| `poderes_concedidos` | Poderes concedidos (deuses) | 132-135 |
| `poderes_tormenta` | Poderes da Tormenta | 136-137 |
| `armas` | Armas | 142-151 |
| `armaduras` | Armaduras e escudos | 152-154 |
| `itens_gerais` | Itens gerais | 155-163 |
| `itens_superiores` | Itens superiores | 164-167 |
| `magias` | Magias | 178-211 |
| `criaturas` | Criaturas/monstros | 282-316 |
| `perigos` | Perigos e armadilhas | 317-321 |
| `tesouros` | Tesouros | 327-332 |
| `itens_magicos_armas` | Armas mágicas | 335-337 |
| `itens_magicos_armaduras` | Armaduras mágicas | 338-340 |
| `pocoes_pergaminhos` | Poções e pergaminhos | 341 |
| `acessorios` | Acessórios mágicos | 342-345 |
| `artefatos` | Artefatos | 346-349 |
| `condicoes` | Condições | 394 |

## Estrutura de Saída

Os JSONs são salvos em `src/json/<tipo>/` por padrão:

```
src/json/
├── racas/
│   ├── humano.json
│   ├── anao.json
│   └── ...
├── classes/
│   ├── arcanista.json
│   └── ...
└── ...
```

## Modelos Recomendados

| Modelo | VRAM | Qualidade | Velocidade |
|--------|------|-----------|------------|
| `mistral` | ~10GB | Excelente | Rápido |
| `llama3` | ~10GB | Excelente | Rápido |
| `mixtral` | ~32GB | Superior | Médio |
| `qwen2.5:14b` | ~11GB | Muito boa | Médio |

## Troubleshooting

### Ollama não está rodando
```bash
ollama serve
```

### Modelo não instalado
```bash
ollama pull mistral
```

### Memória insuficiente
Use um modelo menor ou quantização:
```bash
ollama pull mistral:7b-q4_0
```

### JSON mal formatado
O pipeline tenta extrair JSON mesmo de respostas malformadas. Se falhar, a entidade será listada nos erros do relatório final. Você pode:
1. Processar novamente apenas as entidades que falharam
2. Ajustar o prompt em `prompts.py`
3. Criar o JSON manualmente

## Uso Programático

```python
from pdf_extractor import extract_entities, list_available_sections
from pipeline import run_pipeline, LLMClient

# Listar seções
sections = list_available_sections("tormenta20.pdf")

# Extrair entidades de uma seção
entities = extract_entities("tormenta20.pdf", "racas", "racas")

# Executar pipeline completo
stats = run_pipeline(
    pdf_path="tormenta20.pdf",
    section="racas",
    entity_type="racas",
    model="mistral",
    output_dir="./output"
)
```

## Contribuindo

Se encontrar padrões de extração que não funcionam bem, ajuste os regex em `ENTITY_PATTERNS` no arquivo `pdf_extractor.py`.
