# ⚽ Pipeline ETL - Futebol (Mundial 2022 / StatsBomb)

Este projeto consiste num fluxo **ETL (Extract, Transform, Load)** desenvolvido em **Pentaho Data Integration (Spoon)** para processar dados de partidas de futebol do Campeonato do Mundo de 2022 (StatsBomb), automatizar a sua transformação e popular uma base de dados relacional em **MySQL**.

---

## 📂 Estrutura do Projeto

O repositório está organizado da seguinte forma:

```text
ISI_Futebol/
│
├── dados/                   # Ficheiros de dados brutos (ex: matches_2022.json)
├── jobs/                    # Orquestração do Pentaho (job_futebol.kjb)[cite: 1]
├── transformacoes/          # Fluxos individuais em Pentaho (.ktr) (cálculos, passes, eventos, etc.)[cite: 1]
├── sql/                     # Scripts de criação e configuração da base de dados (criar_base_dados.sql)[cite: 1]
└── resultados/              # Ficheiros CSV exportados (classificação, melhores marcadores, passes)[cite: 1]
