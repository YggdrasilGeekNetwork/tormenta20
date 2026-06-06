const MODEL_LABELS = {
  armas: "Armas",
  armaduras: "Armaduras",
  classes: "Classes",
  condicoes: "Condições",
  divindades: "Divindades",
  escudos: "Escudos",
  indice_remissivo: "Índice Remissivo",
  itens: "Itens",
  livros: "Livros",
  magias: "Magias",
  materiais_especiais: "Materiais Especiais",
  melhorias: "Melhorias",
  origens: "Origens",
  poderes: "Poderes",
  racas: "Raças",
  regras: "Regras",
}

function buildNav(container, activeSrc) {
  const models = Object.keys(MODEL_LABELS)
  const rubyOpen = activeSrc && activeSrc.startsWith("ruby/") ? "open" : ""
  const tsOpen = activeSrc && activeSrc.startsWith("ts/") ? "open" : ""

  function modelLinks(prefix, open) {
    const links = models
      .map(m => {
        const src = `${prefix}/${m}.md`
        const active = activeSrc === src ? ' class="active"' : ""
        return `<a href="viewer.html?src=${src}"${active}>${MODEL_LABELS[m]}</a>`
      })
      .join("")
    const label = prefix === "ruby" ? "Ruby" : "TypeScript"
    const cls = prefix === "ruby" ? "badge-rb" : "badge-ts"
    const tag = prefix === "ruby" ? "RB" : "TS"
    return `
      <details ${open}>
        <summary class="nav-section-toggle">
          <span class="nav-chevron">›</span>
          ${label}
          <span class="badge ${cls}">${tag}</span>
        </summary>
        ${links}
      </details>`
  }

  const homeActive = !activeSrc ? ' class="active"' : ""
  container.innerHTML = `
    <span class="sidebar-section">Docs</span>
    <a href="index.html"${homeActive}>Home</a>
    <a href="typedoc/" target="_blank" rel="noopener noreferrer">TypeDoc (TS/JS) <span class="badge badge-ts">TS</span></a>
    <a href="https://rubydoc.info/gems/tormenta20" target="_blank" rel="noopener noreferrer">RubyDoc <span class="badge badge-rb">RB</span></a>
    <span class="sidebar-section">Modelos</span>
    ${modelLinks("ruby", rubyOpen)}
    ${modelLinks("ts", tsOpen)}
    <span class="sidebar-section">Pacotes</span>
    <a href="https://www.npmjs.com/package/tormenta20" target="_blank" rel="noopener noreferrer">npm <span class="badge badge-ext">↗</span></a>
    <a href="https://rubygems.org/gems/tormenta20" target="_blank" rel="noopener noreferrer">RubyGems <span class="badge badge-ext">↗</span></a>
    <span class="sidebar-section">Projeto</span>
    <a href="https://github.com/YggdrasilGeekNetwork/tormenta20" target="_blank" rel="noopener noreferrer">GitHub <span class="badge badge-ext">↗</span></a>
    <a href="https://github.com/YggdrasilGeekNetwork/tormenta20/issues" target="_blank" rel="noopener noreferrer">Issues <span class="badge badge-ext">↗</span></a>
  `
}
