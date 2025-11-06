# Ambiente n8n + PostgreSQL - Odonto

Este ambiente está configurado para executar o n8n (automação de workflows) integrado com PostgreSQL.

## Deploy em Produção

### Railway (Recomendado para produção)

Este projeto está pronto para deploy no Railway! Veja o guia completo em [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md)

**Passos rápidos:**
1. Faça push do código para GitHub
2. Conecte no Railway: https://railway.app
3. Adicione PostgreSQL ao projeto
4. Configure variáveis de ambiente (veja `.env.example`)
5. Deploy automático!

---

## Desenvolvimento Local

### Pré-requisitos

- Docker
- Docker Compose

## Serviços Disponíveis

Este ambiente inclui:
- **n8n** - Automação de workflows
- **PostgreSQL** - Banco de dados relacional
- **pgAdmin** - Interface web para gerenciar o PostgreSQL

## Como usar

### Iniciar todos os serviços

```bash
docker-compose up -d
```

### Acessar os serviços

**n8n (Automação)**
- URL: http://localhost:5678
- Usuário:`
- Senha: 

**pgAdmin (Database Manager)**
- URL: http://localhost:5050
- Email: 
- Senha: 

**PostgreSQL (Direto)**
- Host: localhost
- Porta: 5432
- Database: `odonto_db`
- Usuário: `postgres`
- Senha: `postgres123`

### Parar todos os serviços

```bash
docker-compose down
```

### Ver logs

```bash
# Todos os serviços
docker-compose logs -f

# Apenas n8n
docker-compose logs -f n8n

# Apenas pgAdmin
docker-compose logs -f pgadmin

# Apenas PostgreSQL
docker-compose logs -f postgres
```

### Reiniciar

```bash
# Todos os serviços
docker-compose restart

# Serviço específico
docker-compose restart n8n
```

## Estrutura de pastas

- `workflows/` - Workflows do n8n
- `credentials/` - Credenciais do n8n
- `n8n_data/` - Volume Docker com dados do n8n
- `postgres_data/` - Volume Docker com dados do PostgreSQL

## Integração n8n + PostgreSQL

Para conectar o n8n ao PostgreSQL:
   - Host: `postgres`
   - Port: `5432`
   - Database: `odonto_db`
   - User: `postgres`
   - Password: `postgres123`

## Configurações

As configurações podem ser alteradas no arquivo `.env`:

### n8n
- `N8N_BASIC_AUTH_USER` - Usuário de acesso
- `N8N_BASIC_AUTH_PASSWORD` - Senha de acesso
- `TIMEZONE` - Fuso horário

### PostgreSQL
- `POSTGRES_USER` - Usuário do banco
- `POSTGRES_PASSWORD` - Senha do banco
- `POSTGRES_DB` - Nome do banco

### pgAdmin
- `PGADMIN_EMAIL` - Email de login
- `PGADMIN_PASSWORD` - Senha de login

## Notas importantes

- Os dados são persistidos em volumes Docker
- Em produção, altere TODAS as senhas no arquivo `.env`
- O pgAdmin está acessível apenas localmente por padrão
- Backup regular do volume `postgres_data` é recomendado
- O n8n pode usar o PostgreSQL para armazenar seus dados internos (workflows, execuções, etc.)
