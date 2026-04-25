sudo docker run -d --name open-webui --restart unless-stopped \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  -e ENABLE_RAG_WEB_SEARCH=true \
  -e RAG_WEB_SEARCH_ENGINE=searxng \
  -e SEARXNG_QUERY_URL='https://search.ramoul.org/search?q=<query>' \
  -e RAG_WEB_SEARCH_RESULT_COUNT=3 \
  -e RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10 \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
