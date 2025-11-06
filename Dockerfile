FROM n8nio/n8n:latest

# Configurações de ambiente
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_HOST=0.0.0.0
ENV NODE_ENV=production

# Expor porta
EXPOSE 5678

# Criar diretórios necessários
RUN mkdir -p /home/node/.n8n/workflows /home/node/.n8n/credentials

# Volumes para persistência
VOLUME ["/home/node/.n8n"]

# Comando de inicialização
CMD ["n8n", "start"]
