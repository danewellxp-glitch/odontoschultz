# Quick Start - Deploy n8n no Railway com PostgreSQL

## Passo 1: Enviar para GitHub

```bash
git init
git add .
git commit -m "Preparar n8n para Railway"
git remote add origin https://github.com/seu-usuario/seu-repo.git
git branch -M main
git push -u origin main
```

## Passo 2: Criar Projeto no Railway

1. Acesse https://railway.app
2. Login com GitHub
3. "New Project" → "Deploy from GitHub repo"
4. Selecione seu repositório

## Passo 3: Adicionar PostgreSQL

1. No projeto, clique "+ New"
2. Selecione "Database" → "Add PostgreSQL"
3. Railway criará o banco automaticamente

## Passo 4: Configurar Variáveis de Ambiente

Clique no serviço n8n → "Variables" → Adicione:

```bash
# Autenticação
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=SuaSenhaSuperSegura123!

# Host
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
WEBHOOK_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}/

# Timezone
TIMEZONE=America/Sao_Paulo

# Database (Railway PostgreSQL)
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{PGHOST}}
DB_POSTGRESDB_PORT=${{PGPORT}}
DB_POSTGRESDB_DATABASE=${{PGDATABASE}}
DB_POSTGRESDB_USER=${{PGUSER}}
DB_POSTGRESDB_PASSWORD=${{PGPASSWORD}}
DB_POSTGRESDB_SCHEMA=public
```

## Passo 5: Gerar Domínio

1. No serviço n8n → "Settings" → "Networking"
2. Clique em "Generate Domain"
3. Aguarde o deploy finalizar

## Passo 6: Acessar n8n

```
URL: https://seu-app.up.railway.app
Usuário: admin
Senha: [a senha que você configurou]
```

## Pronto!

Seu n8n está rodando em produção no Railway com PostgreSQL!

## Próximos Passos

- Configure workflows no n8n
- Adicione integrações (Telegram, Email, etc)
- Configure backups regulares
- Monitore uso no dashboard Railway

## Custos

- Railway: $5 grátis/mês, depois ~$5-10/mês
- PostgreSQL incluído no custo do Railway
