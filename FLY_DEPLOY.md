# Deploy n8n no Fly.io - Guia Completo

Este guia mostra como fazer deploy do n8n no Fly.io com persistência de dados.

## Pré-requisitos

1. **Instalar Fly CLI**
```bash
# Windows (PowerShell)
pwsh -Command "iwr https://fly.io/install.ps1 -useb | iex"

# macOS/Linux
curl -L https://fly.io/install.sh | sh
```

2. **Fazer login no Fly.io**
```bash
flyctl auth login
```

3. **Criar um PostgreSQL no Fly.io (Opcional mas Recomendado)**
```bash
flyctl postgres create --name odontoschultz-db --region gru
```

## Passo a Passo do Deploy

### 1. Criar o Volume para Persistência

O n8n precisa de um volume para armazenar workflows, credenciais e dados:

```bash
flyctl volumes create n8n_data --region gru --size 1
```

### 2. Configurar Variáveis de Ambiente Secretas

Configure as variáveis sensíveis como secrets:

```bash
# Autenticação do n8n (OBRIGATÓRIO)
flyctl secrets set N8N_BASIC_AUTH_ACTIVE=true
flyctl secrets set N8N_BASIC_AUTH_USER=admin
flyctl secrets set N8N_BASIC_AUTH_PASSWORD=SuaSenhaSuperSegura123!

# Se estiver usando PostgreSQL do Fly.io
flyctl secrets set DB_TYPE=postgresdb
flyctl secrets set DB_POSTGRESDB_HOST=odontoschultz-db.internal
flyctl secrets set DB_POSTGRESDB_PORT=5432
flyctl secrets set DB_POSTGRESDB_DATABASE=nome_do_banco
flyctl secrets set DB_POSTGRESDB_USER=usuario_do_banco
flyctl secrets set DB_POSTGRESDB_PASSWORD=senha_do_banco
```

### 3. Fazer o Deploy

```bash
flyctl deploy
```

### 4. Verificar o Status

```bash
flyctl status
```

### 5. Ver Logs

```bash
flyctl logs
```

### 6. Obter a URL da Aplicação

```bash
flyctl info
```

A URL será algo como: `https://odontoschultz.fly.dev`

## Configurações do Projeto

### Dockerfile (já configurado)

- Baseado na imagem oficial `n8nio/n8n:latest`
- Configurado para produção com HTTPS
- Task runners habilitados para melhor performance
- Permissões corretas para o usuário node

### fly.toml (já configurado)

- **App name**: odontoschultz
- **Região**: gru (São Paulo)
- **Porta**: 5678
- **HTTPS**: Forçado
- **Health check**: Endpoint /healthz
- **Auto start/stop**: Economia de custos quando não está em uso
- **Volume**: Persistência em `/home/node/.n8n`

## Atualizar a Aplicação

Após fazer alterações no código:

```bash
git add .
git commit -m "Atualização do projeto"
flyctl deploy
```

## Comandos Úteis

### Ver logs em tempo real
```bash
flyctl logs -a odontoschultz
```

### SSH na máquina
```bash
flyctl ssh console -a odontoschultz
```

### Reiniciar a aplicação
```bash
flyctl apps restart odontoschultz
```

### Ver métricas
```bash
flyctl monitor -a odontoschultz
```

### Escalar recursos (se necessário)
```bash
flyctl scale memory 1024 -a odontoschultz
```

### Listar volumes
```bash
flyctl volumes list -a odontoschultz
```

### Backup do volume (importante!)
```bash
flyctl volumes snapshots list n8n_data -a odontoschultz
flyctl volumes snapshots create n8n_data -a odontoschultz
```

## Banco de Dados

### Opção 1: PostgreSQL do Fly.io (Recomendado)

Vantagens:
- Gerenciado pelo Fly.io
- Backups automáticos
- Rede interna (mais rápido e seguro)

```bash
# Criar banco
flyctl postgres create --name odontoschultz-db --region gru

# Anexar ao app
flyctl postgres attach odontoschultz-db -a odontoschultz
```

### Opção 2: Supabase

Se preferir usar Supabase:

```bash
flyctl secrets set DB_TYPE=postgresdb
flyctl secrets set DB_POSTGRESDB_HOST=db.xxxxx.supabase.co
flyctl secrets set DB_POSTGRESDB_PORT=5432
flyctl secrets set DB_POSTGRESDB_DATABASE=postgres
flyctl secrets set DB_POSTGRESDB_USER=postgres
flyctl secrets set DB_POSTGRESDB_PASSWORD=sua_senha_supabase
```

## Webhooks

O n8n precisa saber sua URL para webhooks. Configure:

```bash
flyctl secrets set WEBHOOK_URL=https://odontoschultz.fly.dev/
flyctl secrets set N8N_PROTOCOL=https
```

## Custos Estimados

**Fly.io** oferece:
- Allowances gratuitas: 3 máquinas compartilhadas, 3GB de volume
- Após isso: ~$1.94/mês por CPU compartilhada + $0.15/GB de volume
- Total estimado: **$2-5/mês** para uso básico

## Troubleshooting

### Erro: "Command 'n8n' not found"

**Resolvido!** O Dockerfile foi corrigido para não sobrescrever o CMD da imagem base.

### App reiniciando em loop

Verifique:
1. Se o volume foi criado: `flyctl volumes list`
2. Se as variáveis de ambiente estão corretas: `flyctl secrets list`
3. Logs para ver o erro: `flyctl logs`

### Health check falhando

O n8n pode demorar 20-30 segundos para iniciar. O grace period está configurado para 30s.

### Sem persistência de dados

Certifique-se que:
1. O volume foi criado
2. O mount está configurado no fly.toml
3. A aplicação foi reiniciada após criar o volume

### Erro de memória

Se o n8n está ficando sem memória:
```bash
flyctl scale memory 1024 -a odontoschultz
```

## Segurança

- ✅ HTTPS forçado
- ✅ Autenticação básica obrigatória
- ✅ Variáveis sensíveis em secrets
- ✅ Volume criptografado
- ✅ Rede interna para banco de dados

## Backup e Restore

### Criar backup manual do volume
```bash
flyctl volumes snapshots create n8n_data -a odontoschultz
```

### Listar backups
```bash
flyctl volumes snapshots list n8n_data -a odontoschultz
```

### Restaurar de backup
```bash
# Criar novo volume do snapshot
flyctl volumes create n8n_data --snapshot-id <snapshot-id> --region gru
```

## Monitoramento

Acesse o dashboard do Fly.io:
```bash
flyctl dashboard -a odontoschultz
```

Ou veja métricas em tempo real:
```bash
flyctl monitor -a odontoschultz
```

## Recursos Úteis

- [Documentação Fly.io](https://fly.io/docs/)
- [Documentação n8n](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Fly.io Community](https://community.fly.io/)

## Próximos Passos

1. ✅ Deploy básico funcionando
2. 🔄 Conectar ao PostgreSQL
3. 🔄 Configurar domínio customizado (opcional)
4. 🔄 Configurar backups automáticos
5. 🔄 Adicionar monitoramento externo

---

**Dúvidas?** Consulte a [documentação oficial do Fly.io](https://fly.io/docs/) ou a [documentação do n8n](https://docs.n8n.io/hosting/).
