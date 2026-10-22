# ⚽ Pipeline ETL \- Futebol (Mundial 2022 / StatsBomb)

**Autor:** a31554  
**Unidade Curricular:** Integração de Sistemas de Informação (ISI)  
**Trabalho Prático:** TP01

---

## 🎥 Demonstração em Vídeo

* **Link direto para o vídeo de demonstração:** https\://drive.google.com/file/d/17jUu3DdjnVG53dLKXzhfrPNEdyWdYAqi/view?usp=sharing

---

## 📂 Descrição da Estrutura de Ficheiros

O projeto encontra-se organizado na seguinte estrutura de pastas:

```
tp01-a31554/
│
├── README.md                      # Ficheiro com identificação, instrução de execução e link do vídeo
├── doc/
│   └── a31554_doc.pdf             # Relatório final de documentação do projeto (com QR Code)
├── dataintegration/               # Ficheiros do Pentaho Data Integration
│   ├── job_futebol.kjb            # Job principal de orquestração do ETL
│   └── *.ktr                      # Transformações individuais de extração e tratamento de dados
├── data/
│   ├── input/                     # Dados brutos de entrada (JSON do Mundial 2022 da StatsBomb)
│   └── output/                    # Ficheiros CSV com os resultados processados pelo ETL
└── src/
    └── criar_base_dados.sql       # Script SQL para criação das tabelas no MySQL
```

---

## 🛠️ Ferramentas Utilizadas

* **Pentaho Data Integration (Spoon):** Utilizado para a orquestração e execução do fluxo ETL.  
* **MySQL Database:** Sistema de Gestão de Base de Dados relacional para armazenamento final.  
* **StatsBomb Data:** Fonte de dados abertos referente às partidas do Mundial 2022\.

---

## ⚙️ Como Executar a Solução

1. **Preparação da Base de Dados:**

   * Abre o teu SGBD MySQL (ex: MySQL Workbench / phpMyAdmin).  
   * Executa o script SQL localizado em `src/criar_base_dados.sql` para criar o schema e a estrutura de tabelas.  
2. **Configuração das Ligações no Pentaho:**

   * Abre o **Pentaho Spoon**.  
   * Garante que as credenciais da ligação MySQL (Host, Porta, DB Name, Utilizador e Password) estão configuradas corretamente nas transformações/jobs.  
3. **Execução do Pipeline:**

   * No Pentaho Spoon, abre o Job principal localizado em `dataintegration/job_futebol.kjb`.  
   * Executa o Job. O fluxo irá automaticamente ler os ficheiros de `data/input/`, realizar as transformações, exportar os relatórios CSV para `data/output/` e popular as tabelas no MySQL.
