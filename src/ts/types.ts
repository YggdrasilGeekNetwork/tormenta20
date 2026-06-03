export interface Arma {
  id: string
  name: string
  type: "arma"
  proficiencia: "simples" | "marcial" | "exotica" | "fogo"
  proposito: "corpo_a_corpo" | "distancia" | "arremesso"
  empunhadura: "leve" | "uma_mao" | "duas_maos"
  preco: number
  dano: string
  critico: string
  alcance: string
  tipo_dano: string
  espacos: number
  habilidades: string[]
  especial: Record<string, unknown>
  description: string
}

export interface Armadura {
  id: string
  name: string
  type: "armadura"
  categoria: "leve" | "pesada"
  preco: number
  bonus_defesa: number
  penalidade: number
  espacos: number
  habilidades: string[]
  description: string
}

export interface Escudo {
  id: string
  name: string
  preco: number
  defense_bonus: number
  armor_penalty: number
  weight: number
  properties: unknown[]
  description: string
}

export interface Item {
  id: string
  name: string
  category: string
  preco?: number
  espacos?: number
  description: string
  habilidades?: string[]
}

export interface Poder {
  id: string
  name: string
  type: string
  sub_type?: string
  description: string
  requirements: PoderesRequirement[]
  effects?: unknown[]
  costs?: unknown[]
}

export interface PoderesRequirement {
  type: string
  sub_type: "hard" | "soft"
  [key: string]: unknown
}

export interface Magia {
  id: string
  name: string
  type: string
  circle: string
  school: string
  execution: string
  execution_details: string | null
  range: string
  target: { amount: number; up_to: number | null; type: string } | null
  effect: string
  effect_details: string | null
  counterspell: string | null
  duration: string
  duration_details: string | null
  resistence: { effect: string; skill: string } | null
  extra_costs: unknown | null
  description: string
  enhancements: MagiaEnhancement[]
  effects: MagiaEffect[]
}

export interface MagiaEnhancement {
  cost: number
  type: string
  description: string
  extra_details: string | null
}

export interface MagiaEffect {
  type: string
  attribute?: string
  amount?: string
  resistence_requirement?: string | null
  extra_requirements?: unknown | null
}

export interface Classe {
  id: string
  name: string
  hit_points: { initial: number; per_level: number }
  mana_points: { per_level: number }
  skills: {
    mandatory: unknown[]
    choose_amount: number
    choose_from: { name: string; attribute: string }[]
  }
  proficiencies: {
    weapons: string[]
    armors: string[]
    shields: boolean
  }
  abilities?: unknown[]
  powers?: unknown[]
  progression?: unknown[]
  spellcasting?: unknown
}

export interface Raca {
  id: string
  name: string
  description: string
  size: string
  movement: number
  vision: string
  vision_range: number | null
  attribute_bonuses: Record<string, number>
  skill_bonuses: unknown[]
  racial_abilities: string[]
  chosen_abilities_amount: number
  available_chosen_abilities: unknown[]
}

export interface Origem {
  id: string
  name: string
  description: string
  items: { type: string; text: string }[]
  benefits: {
    skills?: string[]
    powers?: string[]
    [key: string]: unknown
  }
  unique_power: string | null
}

export interface Pericia {
  id: string
  name: string
  atributo: string
  trained_only: boolean
  armor_penalty: boolean
  resistance_skill: boolean
  description: string
  uses: unknown[]
}

export interface Condicao {
  id: string
  name: string
  description: string
  effects: unknown[]
  condition_type: string | null
  escalates_to: string | null
}
