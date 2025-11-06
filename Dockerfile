FROM n8nio/n8n:latest

# Configurações de ambiente para produção
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV N8N_HOST=0.0.0.0
ENV NODE_ENV=production

# Configurações adicionais para Fly.io
ENV N8N_RUNNERS_ENABLED=true
ENV EXECUTIONS_MODE=regular

# Expor porta
EXPOSE 5678

# Criar diretórios necessários
USER root
RUN mkdir -p /home/node/.n8n/workflows /home/node/.n8n/credentials && \
    chown -R node:node /home/node/.n8n

# Voltar para usuário node
USER node

# A imagem base já define o CMD correto, não precisamos sobrescrever
