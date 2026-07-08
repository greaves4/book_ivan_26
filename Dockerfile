FROM nginx:1.27-alpine

# Reemplaza la config default de nginx por la nuestra
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/site.conf

# Copia solo lo que sirve el sitio (ver .dockerignore para exclusiones)
COPY index.html /usr/share/nginx/html/index.html
COPY _ds /usr/share/nginx/html/_ds
COPY assets /usr/share/nginx/html/assets

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/ >/dev/null 2>&1 || exit 1

CMD ["nginx", "-g", "daemon off;"]
