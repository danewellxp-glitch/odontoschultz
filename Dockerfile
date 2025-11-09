FROM n8nio/n8n:latest

# Configurações de ambiente para produção
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_HOST=0.0.0.0
ENV NODE_ENV=production

# Configurações adicionais para Fly.io
ENV N8N_RUNNERS_ENABLED=true
ENV EXECUTIONS_MODE=regular

# Expor porta
EXPOSE 5678

# Criar diretórios necessários e instalar custom nodes
USER root

RUN mkdir -p /home/node/.n8n/custom /home/node/.n8n/workflows /home/node/.n8n/credentials && \
    chown -R node:node /home/node/.n8n

# Instalar extensão no diretório custom do n8n
USER node
WORKDIR /home/node/.n8n/custom
RUN npm install n8n-nodes-evolution-api

WORKDIR /data

# A imagem base já define o CMD correto, não precisamos sobrescrever
