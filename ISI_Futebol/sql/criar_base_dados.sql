-- ISI 2026/27 - Trabalho Pratico I
-- ETL Mundial 2022 (StatsBomb Open Data) com Pentaho Kettle
-- Script de criacao das tabelas e views usadas nas transformacoes.

CREATE DATABASE IF NOT EXISTS isi_futebol;
USE isi_futebol;

-- ---------- Tabelas carregadas pelo Kettle ----------

CREATE TABLE IF NOT EXISTS jogos_mundial_2022 (
  match_id          INT PRIMARY KEY,
  match_date        VARCHAR(20),
  home_team         VARCHAR(100),
  away_team         VARCHAR(100),
  home_score        INT,
  away_score        INT,
  competition_stage VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS melhores_marcadores (
  player_name VARCHAR(100),
  team_name   VARCHAR(100),
  total_golos INT
);

CREATE TABLE IF NOT EXISTS percentagem_passes (
  player_name   VARCHAR(100),
  team_name     VARCHAR(100),
  total_passes  INT,
  passes_certos INT,
  percentagem   DOUBLE
);

CREATE TABLE IF NOT EXISTS penaltis_mundial_2022 (
  match_id       INT,
  team_name      VARCHAR(100),
  golos_penaltis INT
);

CREATE TABLE IF NOT EXISTS classificacao_final (
  posicao        INT,
  selecao        VARCHAR(100),
  fase_alcancada VARCHAR(50),
  jogos          INT,
  vitorias       INT,
  empates        INT,
  derrotas       INT,
  golos_marcados INT,
  golos_sofridos INT,
  saldo          INT,
  pontos         INT
);

-- ---------- Views ----------

CREATE OR REPLACE VIEW passes_por_selecao AS
SELECT team_name AS selecao,
       SUM(total_passes)  AS total_passes,
       SUM(passes_certos) AS passes_certos,
       ROUND(SUM(passes_certos)*100/SUM(total_passes),1) AS percentagem
FROM percentagem_passes
GROUP BY team_name
ORDER BY percentagem DESC;

CREATE OR REPLACE VIEW passes_por_jogador AS
SELECT player_name AS jogador, team_name AS selecao,
       total_passes, passes_certos, ROUND(percentagem,1) AS percentagem
FROM percentagem_passes
WHERE total_passes >= 100
ORDER BY percentagem DESC, total_passes DESC;

CREATE OR REPLACE VIEW resultados_equipas AS
SELECT r.match_id, r.fase, r.equipa, r.golos_marcados, r.golos_sofridos,
       COALESCE(pm.golos_penaltis,0) AS pen_marcados,
       COALESCE(ps.golos_penaltis,0) AS pen_sofridos
FROM (
  SELECT match_id, competition_stage AS fase, home_team AS equipa, away_team AS adversario,
         home_score AS golos_marcados, away_score AS golos_sofridos
  FROM jogos_mundial_2022
  UNION ALL
  SELECT match_id, competition_stage, away_team, home_team, away_score, home_score
  FROM jogos_mundial_2022
) r
LEFT JOIN penaltis_mundial_2022 pm ON pm.match_id = r.match_id AND pm.team_name = r.equipa
LEFT JOIN penaltis_mundial_2022 ps ON ps.match_id = r.match_id AND ps.team_name = r.adversario;

CREATE OR REPLACE VIEW equipas_resumo AS
SELECT selecao,
  CASE WHEN fase_max=6 AND ganhou_decisao=1 THEN 1 WHEN fase_max=6 THEN 2
       WHEN fase_max=5 AND ganhou_decisao=1 THEN 3 WHEN fase_max=5 THEN 4
       WHEN fase_max=3 THEN 5 WHEN fase_max=2 THEN 6 ELSE 7 END AS grupo,
  jogos, vitorias, empates, derrotas, golos_marcados, golos_sofridos
FROM (
  SELECT equipa AS selecao,
    CAST(MAX(CASE fase WHEN 'Group Stage' THEN 1 WHEN 'Round of 16' THEN 2
                  WHEN 'Quarter-finals' THEN 3 WHEN 'Semi-finals' THEN 4
                  WHEN '3rd Place Final' THEN 5 WHEN 'Final' THEN 6 END) AS SIGNED) AS fase_max,
    CAST(MAX(CASE WHEN fase IN ('Final','3rd Place Final')
              AND (golos_marcados > golos_sofridos
                   OR (golos_marcados = golos_sofridos AND pen_marcados > pen_sofridos))
             THEN 1 ELSE 0 END) AS SIGNED) AS ganhou_decisao,
    COUNT(*) AS jogos,
    CAST(SUM(golos_marcados > golos_sofridos) AS SIGNED) AS vitorias,
    CAST(SUM(golos_marcados = golos_sofridos) AS SIGNED) AS empates,
    CAST(SUM(golos_marcados < golos_sofridos) AS SIGNED) AS derrotas,
    CAST(SUM(golos_marcados) AS SIGNED) AS golos_marcados,
    CAST(SUM(golos_sofridos) AS SIGNED) AS golos_sofridos
  FROM resultados_equipas
  GROUP BY equipa
) t;

-- ---------- Consultas de exemplo ----------
-- SELECT * FROM melhores_marcadores ORDER BY total_golos DESC LIMIT 10;
-- SELECT * FROM passes_por_selecao;
-- SELECT * FROM classificacao_final ORDER BY posicao;
