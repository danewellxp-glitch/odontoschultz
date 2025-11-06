# Deploy n8n no Railway - Guia Completo

Este guia mostra como fazer deploy do n8n no Railway com banco de dados PostgreSQL.

## Opções de Banco de Dados

Você pode escolher entre:
1. **Railway PostgreSQL** (Recomendado) - Banco gerenciado pelo Railway
2. **Supabase** - Backend as a Service externo

---

## Deploy no Railway (Passo a Passo)

### 1. Preparar Repositório GitHub

```bash
# Inicializar repositório Git (se ainda não tiver)
git init

# Adicionar todos os arquivos
git add .

# Criar commit inicial
git commit -m "Preparar projeto n8n para Railway"

# Conectar ao GitHub (criar repositório antes no GitHub)
git remote add origin https://github.com/seu-usuario/seu-repo.git
git branch -M main
git push -u origin main
```

### 2. Criar Projeto no Railway

1. Acesse https://railway.app
2. Faça login com GitHub
3. Clique em "New Project"
4. Selecione "Deploy from GitHub repo"
5. Escolha seu repositório

### 3. Adicionar PostgreSQL (Opção A - Recomendado)

1. No seu projeto Railway, clique em "+ New"
2. Selecione "Database" → "PostgreSQL"
3. Railway criará automaticamente as variáveis:
   - `PGHOST`
   - `PGPORT`
   - `PGUSER`
   - `PGPASSWORD`
   - `PGDATABASE`

### 4. Configurar Variáveis de Ambiente

No Railway, vá em seu serviço → "Variables" e adicione:

#### Variáveis Obrigatórias:

```bash
# Autenticação n8n
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=sua_senha_segura

# Configurações de host
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/

# Timezone
TIMEZONE=America/Sao_Paulo
```

#### Se usar Railway PostgreSQL (Opção A):

```bash
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{PGHOST}}
DB_POSTGRESDB_PORT=${{PGPORT}}
DB_POSTGRESDB_DATABASE=${{PGDATABASE}}
DB_POSTGRESDB_USER=${{PGUSER}}
DB_POSTGRESDB_PASSWORD=${{PGPASSWORD}}
DB_POSTGRESDB_SCHEMA=public
```

#### Se usar Supabase (Opção B):

```bash
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=db.xxxxx.supabase.co
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=postgres
DB_POSTGRESDB_USER=postgres
DB_POSTGRESDB_PASSWORD=sua_senha_supabase
DB_POSTGRESDB_SCHEMA=public

# Credenciais API Supabase (opcional)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=sua_anon_key
SUPABASE_SERVICE_ROLE_KEY=sua_service_key
```

### 5. Configurar Porta e Deploy

1. No Railway, vá em "Settings"
2. Em "Networking", o Railway detectará automaticamente a porta 5678
3. Clique em "Deploy" para fazer o primeiro deploy

### 6. Gerar Domínio Público

1. Vá em "Settings" → "Networking"
2. Clique em "Generate Domain"
3. Anote o domínio gerado (ex: `seu-app.up.railway.app`)
4. Atualize a variável `WEBHOOK_URL` com este domínio

---

## Pós-Deploy

### Acessar n8n

Após o deploy bem-sucedido:

```
URL: https://seu-app.up.railway.app
Usuário: admin (ou o que você definiu)
Senha: [sua senha configurada]
```

### Verificar Logs

No Railway:
1. Clique no seu serviço
2. Vá em "Deployments"
3. Clique no deployment ativo
4. Visualize os logs em tempo real

### Monitoramento

O Railway oferece:
- Métricas de CPU e memória
- Logs em tempo real
- Alertas de erro
- Reinicialização automática

---

## Custos Estimados

**Railway** oferece:
- $5 de crédito gratuito por mês no plano Hobby
- Após isso, ~$5-10/mês dependendo do uso

**Supabase** oferece:
- Plano gratuito com limitações
- Plano Pro $25/mês

---

## Backup e Manutenção

### Backup do PostgreSQL (Railway)

```bash
# Instalar Railway CLI
npm i -g @railway/cli

# Login
railway login

# Conectar ao projeto
railway link

# Backup do banco
railway run pg_dump $DATABASE_URL > backup.sql
```

### Atualizar n8n

O Railway faz rebuild automático quando você atualiza o repositório:

```bash
git add .
git commit -m "Atualizar configurações"
git push
```

---

## Troubleshooting

### n8n não inicia

Verifique:
- Variáveis de ambiente estão corretas
- Banco de dados está ativo
- Logs no Railway para erros

### Webhooks não funcionam

Verifique:
- `WEBHOOK_URL` está configurado corretamente
- Domínio Railway está ativo
- `N8N_PROTOCOL=https`

### Erro de conexão com banco

Verifique:
- Credenciais do PostgreSQL
- Banco está no mesmo projeto Railway
- Variáveis `DB_POSTGRESDB_*` corretas

---

## Recursos Úteis

- [Documentação n8n](https://docs.n8n.io)
- [Railway Docs](https://docs.railway.app)
- [Supabase Docs](https://supabase.com/docs)
- [n8n Community](https://community.n8n.io)

---

## Segurança

- Sempre use senhas fortes para `N8N_BASIC_AUTH_PASSWORD`
- Não commite o arquivo `.env` no Git
- Use variáveis de ambiente do Railway
- Ative SSL/HTTPS (Railway faz automaticamente)
- Faça backups regulares do banco de dados
