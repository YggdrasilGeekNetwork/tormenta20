"""
Prompts para extração de entidades do Tormenta 20.
Cada prompt inclui a estrutura JSON esperada e instruções específicas.
"""

SYSTEM_PROMPT = """Você é um assistente especializado em extrair dados estruturados do sistema de RPG Tormenta 20.

Regras gerais:
- Use slugs em snake_case para IDs (ex: "bola_de_fogo", "poder_de_arcanista")
- Referências a outras entidades usam slugs (ex: "powers": ["raio_arcano"])
- Campos de texto livre mantêm acentos e formatação original
- Atributos abreviados: for, des, con, int, sab, car
- Se um campo não existir no texto, use null
- Retorne APENAS o JSON, sem explicações ou markdown"""


PROMPTS = {
    "racas": {
        "instruction": """Extraia os dados da RAÇA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_da_raca",
  "name": "Nome da Raça",
  "description": "Texto descritivo completo...",
  "attributes": {
    "for": 0,
    "des": 0,
    "con": 0,
    "int": 0,
    "sab": 0,
    "car": 0
  },
  "size": "medio|pequeno|grande|enorme|minusculo",
  "creature_type": "humanoide|construto|monstro|morto_vivo",
  "speed": 9,
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome da Habilidade",
      "description": "Descrição completa...",
      "effects": [
        { "type": "tipo_efeito", "value": "valor" }
      ],
      "costs": [
        { "type": "PM", "value": 1 }
      ],
      "choices": [
        { "id": "opcao", "description": "..." }
      ]
    }
  ]
}

Notas:
- attributes: só inclua atributos mencionados, os demais são 0
- Se mencionar "+1 em Três Atributos Diferentes", use "any_three": 1
- speed padrão é 9 (9m), a menos que especificado
- creature_type padrão é "humanoide"
- costs e choices são opcionais, inclua só se existirem

TEXTO DA RAÇA:
""",
        "example": """{
  "id": "hynne",
  "name": "Hynne",
  "description": "Também conhecidos como halflings ou 'pequeninos'...",
  "attributes": { "des": 2, "car": 1, "for": -1 },
  "size": "pequeno",
  "creature_type": "humanoide",
  "speed": 6,
  "abilities": [
    {
      "id": "arremessador",
      "name": "Arremessador",
      "description": "Quando faz um ataque à distância com uma funda ou uma arma de arremesso, seu dano aumenta em um passo.",
      "effects": [{ "type": "damage_step_increase", "value": 1, "condition": "funda_ou_arremesso" }]
    }
  ]
}"""
    },

    "classes": {
        "instruction": """Extraia os dados da CLASSE a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_da_classe",
  "name": "Nome da Classe",
  "description": "Texto descritivo...",
  "hit_points": {
    "initial": 8,
    "per_level": 2,
    "attribute": "con"
  },
  "mana_points_per_level": 6,
  "skills": {
    "mandatory": ["pericia1", "pericia2"],
    "choose": {
      "amount": 2,
      "from": ["pericia3", "pericia4", ...]
    }
  },
  "proficiencies": ["armaduras_leves", "armas_simples", ...],
  "famous_characters": ["Nome1", "Nome2", ...],
  "class_features": [
    {
      "id": "slug_habilidade",
      "name": "Nome da Habilidade",
      "level": 1,
      "description": "...",
      "choices": [
        {
          "id": "opcao",
          "name": "Nome Opção",
          "description": "...",
          "key_attribute": "int",
          "special_rules": { ... }
        }
      ]
    }
  ],
  "powers": ["poder1", "poder2", ...]
}

Notas:
- Não inclua "poder_de_[classe]" nas class_features, é implícito
- powers: lista de slugs dos poderes disponíveis para a classe
- proficiencies: armaduras_leves, armaduras_pesadas, escudos, armas_simples, armas_marciais, armas_de_fogo, etc.

TEXTO DA CLASSE:
""",
        "example": ""
    },

    "origens": {
        "instruction": """Extraia os dados da ORIGEM a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_origem",
  "name": "Nome da Origem",
  "description": "Texto descritivo...",
  "items": [
    { "id": "slug_item", "name": "Nome do Item" },
    { "id": "slug_item", "name": "Nome do Item", "value": 300 },
    { "choose": 1, "from": [{ "id": "item1", "name": "Item 1" }, ...] }
  ],
  "benefits": {
    "skills": ["pericia1", "pericia2"],
    "powers": ["poder1", "poder2"],
    "special_choices": [
      { "type": "poder_de_combate", "choose": 1 }
    ],
    "choose": 2
  },
  "unique_power": {
    "id": "slug_poder",
    "name": "Nome do Poder",
    "description": "Descrição completa...",
    "effects": [...]
  }
}

Notas:
- benefits.choose geralmente é 2
- special_choices para casos como "um poder de combate a sua escolha"
- unique_power é o poder exclusivo da origem

TEXTO DA ORIGEM:
""",
        "example": ""
    },

    "divindades": {
        "instruction": """Extraia os dados da DIVINDADE a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_divindade",
  "name": "Nome",
  "title": "Deus/Deusa de...",
  "description": "Texto descritivo...",
  "beliefs_and_goals": [
    "Crença ou objetivo 1",
    "Crença ou objetivo 2"
  ],
  "holy_symbol": "Descrição do símbolo sagrado",
  "channel_energy": "positiva|negativa|qualquer",
  "preferred_weapon": "slug_arma",
  "devotees": {
    "races": ["raca1", "raca2"],
    "classes": ["classe1", "classe2"]
  },
  "granted_powers": ["poder1", "poder2", "poder3", "poder4"],
  "obligations_and_restrictions": [
    {
      "type": "tipo_restricao",
      "description": "Descrição da restrição..."
    }
  ]
}

Notas:
- channel_energy: "positiva", "negativa" ou "qualquer"
- Humanos e clérigos podem ser devotos de qualquer deus (não precisa listar)
- granted_powers: sempre 4 poderes concedidos

TEXTO DA DIVINDADE:
""",
        "example": ""
    },

    "pericias": {
        "instruction": """Extraia os dados da PERÍCIA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_pericia",
  "name": "Nome da Perícia",
  "key_attribute": "for|des|con|int|sab|car",
  "armor_penalty": true|false,
  "trained_only": true|false,
  "description": "Descrição geral...",
  "uses": [
    {
      "id": "slug_uso",
      "name": "Nome do Uso",
      "cd": 15,
      "trained_only": false,
      "action": "padrao|movimento|completa|reacao|livre|parte_do_movimento",
      "description": "Descrição do uso...",
      "cd_table": [
        { "condition": "condição", "cd": 10 }
      ],
      "effects": [
        { "on_success": "efeito" },
        { "on_fail": "efeito" },
        { "on_fail_by_5": "efeito" }
      ]
    }
  ]
}

Notas:
- armor_penalty: true se tiver "Armadura" na linha de atributos
- trained_only: true se tiver "Treinada" na linha de atributos
- cd pode ser número ou "teste_oposto"
- cd_table para CDs variáveis

TEXTO DA PERÍCIA:
""",
        "example": ""
    },

    "magias": {
        "instruction": """Extraia os dados da MAGIA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_magia",
  "name": "Nome da Magia",
  "type": "arcana|divina|universal",
  "circle": 1,
  "school": "abjur|adiv|conv|encan|evoc|ilusao|necro|trans",
  "execution": "padrao|movimento|completa|livre|reacao",
  "execution_details": null,
  "range": "pessoal|toque|curto|medio|longo|ilimitado",
  "target": {
    "amount": 1,
    "up_to": null,
    "type": "criatura|objeto|area|voce"
  },
  "effect": "alvo|area|...",
  "effect_details": {
    "shape": "esfera|cone|linha|cubo",
    "dimension": "raio|comprimento",
    "size": "6m"
  },
  "duration": "instantanea|cena|sustentada|1_dia|permanente",
  "duration_details": null,
  "resistance": {
    "effect": "anula|parcial|reduz_metade",
    "skill": "fortitude|reflexos|vontade"
  },
  "extra_costs": null,
  "description": "Descrição completa...",
  "enhancements": [
    {
      "cost": 2,
      "type": "aumenta|muda",
      "description": "Descrição do aprimoramento..."
    }
  ],
  "effects": [
    {
      "type": "dano|bonus|cura|condicao",
      "amount": "6d6",
      "damage_type": "fogo|frio|eletricidade|acido|..."
    }
  ]
}

Notas:
- circle: número de 1 a 5
- school: abjur (abjuração), adiv (adivinhação), conv (convocação), encan (encantamento), evoc (evocação), ilusao (ilusão), necro (necromancia), trans (transmutação)
- range: curto=6m, medio=30m, longo=90m

TEXTO DA MAGIA:
""",
        "example": ""
    },

    "poderes": {
        "instruction": """Extraia os dados do PODER a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_poder",
  "name": "Nome do Poder",
  "type": "poder_geral|habilidade_de_classe",
  "sub_type": "poder_de_combate|poder_de_destino|poder_de_magia|poder_de_[classe]",
  "description": "Descrição completa...",
  "requirements": [
    {
      "type": "attr_value|character_lvl|skill_training|feature|power",
      "attr": "for|des|con|int|sab|car",
      "value": 13,
      "skill": "slug_pericia",
      "power": "slug_poder",
      "feature": "slug_habilidade"
    }
  ],
  "effects": [
    {
      "type": "tipo_efeito",
      "value": "valor",
      "description": "descrição se necessário"
    }
  ],
  "costs": [
    { "type": "PM", "value": 1 },
    { "type": "acao", "value": "movimento" }
  ]
}

Notas:
- requirements pode ser null se não houver pré-requisitos
- effects pode ser null se o efeito for puramente descritivo
- costs pode ser null se não houver custo

TEXTO DO PODER:
""",
        "example": ""
    },

    # ===========================================
    # EQUIPAMENTO
    # ===========================================

    "armas": {
        "instruction": """Extraia os dados da ARMA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_arma",
  "name": "Nome da Arma",
  "category": "simples|marcial|exotica|fogo",
  "type": "corpo_a_corpo|distancia|arremesso",
  "price": 10,
  "damage": "1d8",
  "damage_type": "corte|perfuracao|impacto",
  "critical": "19|20/x2|x3",
  "range": null,
  "weight": "1kg",
  "properties": ["leve", "duas_maos", "alcance", ...],
  "description": "Descrição se houver..."
}

Notas:
- price em T$ (tibares)
- properties: leve, pesada, duas_maos, versatil, alcance, arremesso, munição, recarga, etc.
- range só para armas de distância/arremesso (em metros)

TEXTO DA ARMA:
""",
        "example": ""
    },

    "armaduras": {
        "instruction": """Extraia os dados da ARMADURA ou ESCUDO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_armadura",
  "name": "Nome da Armadura",
  "type": "leve|pesada|escudo",
  "price": 100,
  "defense_bonus": 4,
  "armor_penalty": -2,
  "weight": "10kg",
  "description": "Descrição se houver..."
}

Notas:
- price em T$ (tibares)
- defense_bonus: bônus na Defesa
- armor_penalty: penalidade de armadura (valor negativo)

TEXTO DA ARMADURA:
""",
        "example": ""
    },

    "itens_gerais": {
        "instruction": """Extraia os dados do ITEM GERAL a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_item",
  "name": "Nome do Item",
  "category": "alimentacao|alquimia|vestuario|servico|transporte|hospedagem|animal|kit|ferramenta",
  "price": 10,
  "weight": "1kg",
  "description": "Descrição do item..."
}

Notas:
- price em T$ (tibares)
- weight pode ser null para itens sem peso significativo

TEXTO DO ITEM:
""",
        "example": ""
    },

    "itens_superiores": {
        "instruction": """Extraia os dados do ITEM SUPERIOR a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_item",
  "name": "Nome do Item Superior",
  "base_item": "slug_item_base",
  "type": "arma|armadura|escudo",
  "price_modifier": "+500",
  "effects": [
    {
      "type": "tipo_efeito",
      "value": "valor",
      "description": "descrição"
    }
  ],
  "description": "Descrição completa..."
}

Notas:
- price_modifier: custo adicional sobre o item base
- base_item: referência ao item base (se aplicável)

TEXTO DO ITEM SUPERIOR:
""",
        "example": ""
    },

    # ===========================================
    # CRIATURAS E PERIGOS
    # ===========================================

    "criaturas": {
        "instruction": """Extraia os dados da CRIATURA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_criatura",
  "name": "Nome da Criatura",
  "nd": 5,
  "type": "animal|construto|espirito|humanode|monstro|morto_vivo",
  "size": "minusculo|pequeno|medio|grande|enorme|colossal",
  "attributes": {
    "for": 10, "des": 10, "con": 10, "int": 10, "sab": 10, "car": 10
  },
  "defense": 15,
  "hit_points": 50,
  "speed": 9,
  "special_movement": ["voo_18m", "natacao_9m", ...],
  "resistances": ["fogo_10", ...],
  "immunities": ["veneno", "medo", ...],
  "vulnerabilities": ["frio", ...],
  "senses": ["visao_no_escuro", "faro", ...],
  "attacks": [
    {
      "name": "Mordida",
      "bonus": "+10",
      "damage": "2d6+5",
      "damage_type": "perfuracao",
      "special": "descrição se houver"
    }
  ],
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome",
      "description": "Descrição..."
    }
  ],
  "treasure": "padrao|dobro|triplo|nenhum|especifico",
  "description": "Descrição da criatura..."
}

Notas:
- nd: Nível de Desafio
- speed em metros
- treasure indica o tesouro padrão da criatura

TEXTO DA CRIATURA:
""",
        "example": ""
    },

    "perigos": {
        "instruction": """Extraia os dados do PERIGO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_perigo",
  "name": "Nome do Perigo",
  "type": "armadilha|ambiente|magico",
  "nd": 3,
  "detection": {
    "skill": "percepcao|investigacao",
    "cd": 20
  },
  "disarm": {
    "skill": "ladinagem|misticismo",
    "cd": 20
  },
  "trigger": "Descrição do gatilho...",
  "effect": "Descrição do efeito...",
  "damage": "4d6",
  "damage_type": "perfuracao|fogo|veneno|...",
  "save": {
    "skill": "reflexos|fortitude|vontade",
    "cd": 15,
    "effect": "metade|anula"
  },
  "description": "Descrição completa..."
}

TEXTO DO PERIGO:
""",
        "example": ""
    },

    # ===========================================
    # RECOMPENSAS E ITENS MÁGICOS
    # ===========================================

    "tesouros": {
        "instruction": """Extraia os dados do TESOURO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_tesouro",
  "name": "Nome do Tesouro",
  "category": "gema|joia|arte|material|outros",
  "value": 100,
  "value_range": { "min": 50, "max": 150 },
  "description": "Descrição..."
}

Notas:
- value em T$ (tibares)
- value_range para itens com valor variável

TEXTO DO TESOURO:
""",
        "example": ""
    },

    "itens_magicos_armas": {
        "instruction": """Extraia os dados da ARMA MÁGICA a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_arma_magica",
  "name": "Nome da Arma",
  "type": "arma",
  "rarity": "menor|medio|maior",
  "aura": "abjur|adiv|conv|encan|evoc|ilusao|necro|trans",
  "price": 5000,
  "base_item": "espada_longa",
  "enhancement_bonus": 1,
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome",
      "description": "Descrição..."
    }
  ],
  "description": "Descrição completa..."
}

TEXTO DA ARMA MÁGICA:
""",
        "example": ""
    },

    "itens_magicos_armaduras": {
        "instruction": """Extraia os dados da ARMADURA/ESCUDO MÁGICO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_armadura_magica",
  "name": "Nome da Armadura",
  "type": "armadura|escudo",
  "rarity": "menor|medio|maior",
  "aura": "abjur|adiv|conv|encan|evoc|ilusao|necro|trans",
  "price": 5000,
  "base_item": "cota_de_malha",
  "enhancement_bonus": 1,
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome",
      "description": "Descrição..."
    }
  ],
  "description": "Descrição completa..."
}

TEXTO DA ARMADURA MÁGICA:
""",
        "example": ""
    },

    "pocoes_pergaminhos": {
        "instruction": """Extraia os dados da POÇÃO ou PERGAMINHO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_item",
  "name": "Nome do Item",
  "type": "pocao|pergaminho",
  "spell": "slug_magia",
  "spell_circle": 1,
  "price": 50,
  "description": "Descrição..."
}

Notas:
- spell: referência à magia contida
- price em T$ (tibares)

TEXTO DO ITEM:
""",
        "example": ""
    },

    "acessorios": {
        "instruction": """Extraia os dados do ACESSÓRIO MÁGICO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_acessorio",
  "name": "Nome do Acessório",
  "slot": "cabeca|olhos|pescoco|ombros|torso|corpo|cintura|bracos|maos|anel|pes|nenhum",
  "rarity": "menor|medio|maior",
  "aura": "abjur|adiv|conv|encan|evoc|ilusao|necro|trans",
  "price": 2000,
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome",
      "description": "Descrição...",
      "activation": "constante|uso|comando",
      "uses_per_day": null
    }
  ],
  "description": "Descrição completa..."
}

Notas:
- slot: local do corpo onde o acessório é usado
- activation: como a habilidade é ativada

TEXTO DO ACESSÓRIO:
""",
        "example": ""
    },

    "artefatos": {
        "instruction": """Extraia os dados do ARTEFATO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_artefato",
  "name": "Nome do Artefato",
  "type": "arma|armadura|acessorio|outro",
  "slot": "cabeca|maos|nenhum|...",
  "aura": "forte",
  "abilities": [
    {
      "id": "slug_habilidade",
      "name": "Nome",
      "description": "Descrição..."
    }
  ],
  "drawbacks": [
    {
      "description": "Desvantagem ou maldição..."
    }
  ],
  "destruction": "Como destruir o artefato...",
  "history": "História/lore do artefato...",
  "description": "Descrição completa..."
}

Notas:
- Artefatos são itens únicos e lendários
- drawbacks: desvantagens ou maldições do artefato
- destruction: condições para destruir (se aplicável)

TEXTO DO ARTEFATO:
""",
        "example": ""
    },

    "condicoes": {
        "instruction": """Extraia os dados da CONDIÇÃO a seguir e retorne um JSON válido.

Estrutura esperada:
{
  "id": "slug_condicao",
  "name": "Nome da Condição",
  "description": "Descrição completa da condição...",
  "effects": [
    {
      "type": "penalty|bonus|restriction|immunity",
      "target": "ataque|defesa|deslocamento|pericias|...",
      "value": -2,
      "description": "Descrição do efeito"
    }
  ],
  "duration": "ate_curar|1_rodada|cena|permanente",
  "removal": "Como remover a condição..."
}

Notas:
- effects: lista de efeitos mecânicos da condição
- removal: condições para remover (se aplicável)

TEXTO DA CONDIÇÃO:
""",
        "example": ""
    }
}


# Mapeamento de tipos para prompts (para tipos que compartilham estrutura)
PROMPT_FALLBACKS = {
    "poderes_combate": "poderes",
    "poderes_destino": "poderes",
    "poderes_magia": "poderes",
    "poderes_concedidos": "poderes",
    "poderes_tormenta": "poderes",
}


def get_prompt(entity_type: str, content: str) -> tuple[str, str]:
    """
    Retorna o prompt formatado para uma entidade.

    Returns:
        Tupla com (system_prompt, user_prompt)
    """
    # Usa fallback se o tipo não tiver prompt específico
    prompt_type = PROMPT_FALLBACKS.get(entity_type, entity_type)

    if prompt_type not in PROMPTS:
        raise ValueError(f"Tipo de entidade desconhecido: {entity_type}. Tipos disponíveis: {list(PROMPTS.keys())}")

    prompt_config = PROMPTS[prompt_type]
    user_prompt = prompt_config["instruction"] + content

    if prompt_config.get("example"):
        user_prompt += f"\n\nEXEMPLO DE OUTPUT:\n{prompt_config['example']}"

    return SYSTEM_PROMPT, user_prompt
