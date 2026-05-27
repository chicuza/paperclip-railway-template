# Squadra Brand Guide

**Amábile · Squadra** — v1.0 · Maio 2026

Identidade visual oficial do produto **Squadra**, plataforma de orquestração de agentes de IA da Amábile AI. Reutiliza o mesmo brand kit Amábile aplicado em `portal.riscodocs.com.br` (Open WebUI rebrand) e `litellm.amabile.ai`.

---

## 1. Brand story

Squadra é o produto de orquestração de agentes de IA da Amábile AI, construído sobre o núcleo open-source Paperclip e rebrandado integralmente para o universo visual Amábile. O nome evoca **time**, **colaboração** e **execução coordenada** — exatamente o que agentes de IA fazem quando operam em conjunto.

A identidade visual herda sem modificação o kit Amábile: triângulo gradiente como glifo, paleta cream/charcoal/purple, Inter como tipografia e radii Apple-style.

**Assinaturas**:
- Editorial / proposta comercial: **"Amábile · Squadra"**
- Produto / UI: **"Squadra by Amábile"**
- Branding standalone (header, favicon): **"Squadra"**

---

## 2. Logos

3 variações oficiais (arquivos em `brand/`):

| Variante | Arquivo | Uso |
|---|---|---|
| **Horizontal lockup** | `logo-horizontal.jpeg` (origem `Downloads/logo-Amabile-AI.jpeg`) | Header da aplicação, footer, og:image, material comercial |
| **Vertical lockup** | `logo-vertical.jpeg` (origem `Downloads/logo-Amabile-AI2.jpeg`) | Auth page (splash centralizado), splash screen mobile, capa de apresentação |
| **Glifo isolado** | `logo-glyph.jpeg` (origem `Downloads/Somente Logo Amabile AI.jpeg`) | Favicon, apple-touch-icon, PWA icons, sidebar collapsed, ícone de notificação |

### Características do glifo

Triângulo "A" formado por 3 strokes rounded com **nós circulares nos 3 vértices**. Gradiente diagonal:

- Topo: `#A78BFA` (Purple 400)
- Esquerda/direita: `#EC4899` (Pink 500)
- Vértices inferiores: `#FB923C` (Orange 500)

Estilo: glassmorphism leve, rounded line caps. **Funciona em fundo claro e escuro** — não inverter, não recolorir, não monocromatizar.

### Espaçamento de proteção

Reservar ao redor do logo área equivalente a 1× a altura do glifo. Não colocar texto ou elementos visuais dentro dessa zona.

---

## 3. Paleta de cores oficial

Fonte: `Downloads/guia de cores amabile.jpeg` (também em `brand/paleta-oficial.jpeg`).

### Primárias

| Token | Hex | RGB | Uso |
|---|---|---|---|
| Purple 400 | `#A78BFA` | 167, 139, 250 | Principal, ações primárias |
| Pink 500 | `#EC4899` | 236, 72, 153 | Secundário, destaques |
| Orange 500 | `#FB923C` | 251, 146, 60 | Terciário, acentos |

### Neutras

| Token | Hex | Uso |
|---|---|---|
| Charcoal | `#1D1A36` | Texto principal |
| Gray 600 | `#6B7280` | Texto secundário |
| Gray 200 | `#E5E7EB` | Bordas e divisores |
| Cream | `#FDF6F3` | Fundos suaves |

### Acento

| Token | Hex | Uso |
|---|---|---|
| Lavender | `#EDD4F2` | Fundos claros, cards |
| Peach | `#FFD4CF` | Destaques suaves |
| Sky | `#C4E0F9` | Informacional |

### Combinações recomendadas

- **Interface principal + botões primários**: Purple 400 + Cream + Charcoal
- **Destaques e elementos secundários**: Pink 500 + Peach + Gray 600

### Status badges (paleta semântica, NÃO usar cores brand)

| Estado | Bg | Fg |
|---|---|---|
| idle | `#EDE9FE` | `#5B21B6` |
| running | Purple 400 `#A78BFA` + pulse | `#FFFFFF` |
| succeeded | `#DCFCE7` | `#16A34A` |
| error / failed | `#FCE7F3` | Pink 700 `#BE185D` |
| queued | `#FFF7ED` | `#C2410C` |

---

## 4. Tipografia

**Inter** — Google Fonts CDN
```
https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap
```

Fallback stack: `'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif`

| Weight | Uso |
|---|---|
| 400 | Body, captions, meta |
| 500 | Labels, nav items |
| 600 | Subheadings, card titles |
| 700 | Wordmark, H1-H2, CTAs |

Letter-spacing em headings: `-0.025em`.

---

## 5. Geometria

- **Border-radius padrão**: `0.75rem` (Apple-style)
- Derivados: sm `0.5rem`, md `0.625rem`, xl `1rem`
- Focus ring: `0 0 0 3px rgb(167 139 250 / 0.55)`
- Card shadow: `0 8px 32px rgb(29 26 54 / 0.08)`

---

## 6. Banner / Cover OG

Arquivo: `og-cover-1200x630.png` (gerado por `_gen_assets.py`).

Especificação:
- Dimensões: 1200×630
- Background: gradiente vertical Lavender (topo) → Cream (meio) → Peach (base)
- Lockup horizontal centralizado, ~800px de largura, levemente acima do centro vertical
- Tagline "Squadra by Amábile AI" em Gray 600 abaixo do lockup
- Sem bordas, sem sombras pesadas

---

## 7. Favicon set

| Arquivo | Dimensão | Tipo |
|---|---|---|
| `favicon.ico` | 16/32/48 multi-res | ICO |
| `favicon-16x16.png` | 16×16 | PNG transparente |
| `favicon-32x32.png` | 32×32 | PNG transparente |
| `favicon-48x48.png` | 48×48 | PNG transparente |
| `favicon-96x96.png` | 96×96 | PNG transparente |
| `apple-touch-icon.png` | 180×180 | Glifo sobre Cream com padding 10% |
| `web-app-manifest-192x192.png` | 192×192 | PWA, glifo sobre Cream |
| `web-app-manifest-512x512.png` | 512×512 | PWA splash, glifo sobre Cream |

Todos gerados a partir de `logo-glyph.jpeg` via `_gen_assets.py`. Para regenerar: `python brand/_gen_assets.py`.

---

## 8. Do / Don't

### ✅ Do

- Usar o glifo gradiente em monocromo (não recolorir)
- Usar Purple 400 como cor única de CTA primário
- Usar Lavender como fundo de cards e hover states
- Manter `0.75rem` em todos os corner radii
- Aplicar Inter em toda copy

### ❌ Don't

- **NÃO usar magenta `#E20074`** — esse é da Amábile corporate web, não do produto Squadra
- Não recolorir o glifo (gradiente é fixo)
- Não esticar o lockup horizontal verticalmente
- Não usar gradiente do glifo como fundo de seção inteira (overload visual)
- Não criar badge de erro com fundo escuro sem garantir contraste 4.5:1
- Não traduzir "Squadra" — é nome próprio em PT-BR e EN

---

## 9. URLs canônicas

| Produto | URL |
|---|---|
| **Squadra** | `squadra.amabileai.com.br` |
| Open WebUI portal | `portal.riscodocs.com.br` |
| LiteLLM | `litellm.amabile.ai` |
| CDN assets | `cdn.amabileai.com.br/squadra/v1/*` |

---

## 10. Arquivos entregues neste brand kit

```
C:/Users/chicu/paperclip-amabileai/brand/
├── BRAND_GUIDE.md                       ← este documento
├── _gen_assets.py                       ← script Python idempotente que regenera todos os PNGs/ICO
├── logo-horizontal.jpeg                 ← copy de Downloads/logo-Amabile-AI.jpeg
├── logo-vertical.jpeg                   ← copy de Downloads/logo-Amabile-AI2.jpeg
├── logo-glyph.jpeg                      ← copy de Downloads/Somente Logo Amabile AI.jpeg
├── paleta-oficial.jpeg                  ← copy de Downloads/guia de cores amabile.jpeg
├── favicon.ico                          ← 16/32/48 multi-res, gerado
├── favicon-16x16.png                    ← gerado
├── favicon-32x32.png                    ← gerado
├── favicon-48x48.png                    ← gerado
├── favicon-96x96.png                    ← gerado
├── apple-touch-icon.png                 ← 180×180 sobre cream, gerado
├── web-app-manifest-192x192.png         ← PWA, gerado
├── web-app-manifest-512x512.png         ← PWA splash, gerado
├── og-cover-1200x630.png                ← banner OG, gerado
├── squadra-manifest.webmanifest         ← PWA manifest
└── custom.css                           ← token overlay injetado pelo Cloudflare Worker
```

**Pendente (entrega externa)**:
- `logo-horizontal.svg`, `logo-vertical.svg`, `logo-glyph.svg` — vetorização dos 3 logos JPEG (sugestão: Figma export OU `vectorizer.ai`). Sem SVG, fica usando PNG/JPEG.
