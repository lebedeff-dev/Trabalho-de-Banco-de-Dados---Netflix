# Modelo lógico Netflix

Fonte: `Banco de dados/netflix.mwb` (MySQL Workbench). Feito no 1º trabalho, em grupo. **13 tabelas, 12 FKs.** O modelo foi aprovado com 12/12 ([[Feedback da professora (modelo logico)]]) e **não será alterado**.

## Ordem de criação (mãe antes da filha)
1. `plano`, `categoria`, `pessoa`, `titulo` (sem FK)
2. `conta` (→ plano), `temporada` (→ titulo)
3. `dados_cobranca`, `perfil` (→ conta), `episodio` (→ temporada)
4. `configuracao_perfil` (→ perfil), `titulo_categoria` (→ titulo, categoria), `participacao` (→ pessoa, titulo), `historico_visualizacao` (→ perfil, titulo)

## Tabelas (todas com PK `id_...` AUTO_INCREMENT)

**plano**: nome VARCHAR(40) UNIQUE, descricao TEXT, valor_mensal DECIMAL(6,2), qualidade_maxima ENUM('SD','HD','Full HD','4K UHD'), telas_simultaneas TINYINT, permite_download TINYINT(1) =1, data_criacao DATE

**conta**: id_plano FK, email VARCHAR(120) UNIQUE, senha_hash VARCHAR(255), telefone VARCHAR(15) NULL, pais CHAR(2) ='BR', data_cadastro DATETIME =now, status ENUM('Ativa','Suspensa','Cancelada') ='Ativa'

**dados_cobranca** (1:1 com conta): id_conta FK UNIQUE, nome_titular VARCHAR(100), forma_pagamento ENUM('Cartao de Credito','Cartao de Debito','Pix','Boleto'), ultimos_quatro_digitos CHAR(4) NULL, dia_vencimento TINYINT, data_proxima_cobranca DATE, cobranca_ativa TINYINT(1) =1

**perfil**: id_conta FK, nome VARCHAR(50), avatar VARCHAR(60) ='padrao', data_criacao DATE, perfil_infantil TINYINT(1) =0, pin CHAR(4) NULL. UNIQUE em (conta, nome) (`uk_perfil_conta`)

**configuracao_perfil** (1:1 com perfil): id_perfil FK UNIQUE, idioma_interface VARCHAR(20) ='Portugues', idioma_legenda VARCHAR(20) ='Portugues', legendas_ativas =1, reproducao_automatica =1, qualidade_preferida ENUM('Automatica','Baixa','Media','Alta') ='Automatica', data_atualizacao DATETIME =now

**titulo**: nome VARCHAR(150), sinopse TEXT NULL, tipo ENUM('Filme','Serie','Documentario','Stand-up'), ano_lancamento SMALLINT, classificacao_indicativa ENUM('L','10','12','14','16','18'), duracao_minutos INT NULL, idioma_original VARCHAR(30), data_adicao_catalogo DATE, disponivel TINYINT(1) =1

**temporada**: id_titulo FK, numero_temporada TINYINT, nome VARCHAR(100) NULL, ano_lancamento SMALLINT, data_estreia DATE, sinopse TEXT NULL, disponivel =1. UNIQUE (titulo, numero)

**episodio**: id_temporada FK, numero_episodio TINYINT, titulo_episodio VARCHAR(120), sinopse TEXT NULL, duracao_minutos INT, data_estreia DATE, disponivel =1. UNIQUE (temporada, numero)

**categoria**: nome VARCHAR(50) UNIQUE, descricao TEXT NULL, codigo_interno CHAR(4) UNIQUE, ativa TINYINT(1) =1, data_criacao DATE

**titulo_categoria** (N:N titulo↔categoria): id_titulo FK, id_categoria FK, categoria_principal =0, ordem_exibicao =1, data_associacao DATE. UNIQUE (titulo, categoria)

**pessoa**: nome VARCHAR(100), nome_artistico VARCHAR(100) NULL, data_nascimento DATE NULL, nacionalidade VARCHAR(50), biografia TEXT NULL, em_atividade TINYINT(1) =1

**participacao** (N:N pessoa↔titulo): id_pessoa FK, id_titulo FK, funcao ENUM('Ator','Diretor','Roteirista','Produtor','Dublador'), nome_personagem VARCHAR(80) NULL, papel_principal =0, ordem_credito =1. UNIQUE `uk_participacao`

**historico_visualizacao** (N:N perfil↔titulo): id_perfil FK, id_titulo FK, data_inicio DATETIME =now, data_ultima_visualizacao DATETIME =now, minuto_parada INT =0, concluido TINYINT(1) =0, dispositivo ENUM('TV','Celular','Notebook','Tablet','Console'). UNIQUE `uk_visualizacao`

## Regras das FKs (já no modelo)
- `ON UPDATE CASCADE` em todas.
- `ON DELETE RESTRICT`: conta→plano, titulo_categoria→categoria.
- `ON DELETE CASCADE`: todas as demais.

## UNIQUE (confirmados no `.mwb`)
| Tabela | Campos únicos |
|---|---|
| categoria | `nome`; `codigo_interno` |
| configuracao_perfil | `id_perfil` |
| conta | `email` |
| dados_cobranca | `id_conta` |
| episodio | (`id_temporada`, `numero_episodio`) |
| historico_visualizacao | (`id_perfil`, `id_titulo`) — um registro por perfil e título |
| participacao | (`id_pessoa`, `id_titulo`, `funcao`) |
| perfil | (`id_conta`, `nome`) |
| plano | `nome` |
| temporada | (`id_titulo`, `numero_temporada`) |
| titulo_categoria | (`id_titulo`, `id_categoria`) |

**Atenção nos inserts:** `historico_visualizacao` não aceita o mesmo perfil assistindo ao mesmo título duas vezes; 30 linhas exigem 30 pares (perfil, título) diferentes. Ver [[Passo a passo]].
