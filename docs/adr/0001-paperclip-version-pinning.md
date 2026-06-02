# ADR-0001 — Versionamento do Paperclip: pin estável + bump automatizado

- **Status:** Aceito
- **Data:** 2026-06-02
- **Escopo:** deploy Squadra — fork `chicuza/paperclip-railway-template@squadra` na Railway

## Contexto
O Paperclip é embutido em **build-time** via `git clone --depth 1 --branch ${PAPERCLIP_REF}` no
`Dockerfile`. A versão fica **congelada na imagem**: um restart não atualiza, só um rebuild. A
auditoria de 2026-06-02 encontrou drift de ~44 dias / 7 releases (`v2026.416.0` vs `v2026.529.0`
estável). As migrações de DB rodam no boot e são **forward-only** (sem downgrade).

## Decisão
Manter o pin em build-arg na **última tag ESTÁVEL** e **automatizar o bump** via PR com revisão
humana (`.github/workflows/bump-paperclip.yml` + `scripts/bump-paperclip-ref.mjs`, resolvendo o
GitHub `releases/latest`). **Não** flutuar em `master`/`@latest`/`canary`.

## Alternativas rejeitadas
- **Flutuar em master/HEAD ou npm `@latest`/`canary`:** mais atual, mas aplica migrações
  forward-only sem janela de revisão; tags/branches são mutáveis; e o cache de build da Railway
  pode nem re-resolver o ref (exigiria `NO_CACHE`). Menos seguro para produção.
- **Pin manual sem automação:** seguro, porém gera drift por esquecimento (foi o que ocorreu).

## Consequências
- (+) Build reprodutível, revisável, rollback de 1 linha; janela para revisar migrações antes do deploy.
- (−) Exige merge humano do PR de bump (intencional — é o gate de segurança).
- **Gate do PR de bump:** revisar migrações novas · backup do Postgres · confirmar rebrand em
  `/app/ui/dist` · smoke test pós-deploy.
- **Hardening opcional futuro:** pinar por commit SHA da tag em vez da tag (imutabilidade real).
