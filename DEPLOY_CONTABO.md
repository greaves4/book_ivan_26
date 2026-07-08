# Deploy a Contabo (VPS)

Sitio 100% estático. Basta con copiar los archivos a un directorio y apuntar nginx.

Reemplazá:
- `TU_IP` → IP de tu VPS Contabo
- `TU_DOMINIO` → dominio (ej. `ivangalar.com`)
- `USER` → usuario SSH (por defecto `root` en Contabo)

---

## 1 · Preparar el servidor (una vez)

SSH al VPS:

```bash
ssh USER@TU_IP
```

Instalar nginx + certbot:

```bash
apt update && apt install -y nginx certbot python3-certbot-nginx
```

Crear el directorio del sitio:

```bash
mkdir -p /var/www/ivangalar
chown -R www-data:www-data /var/www/ivangalar
```

## 2 · Subir los archivos

Desde tu máquina local, parado en la carpeta del handoff:

```bash
# copiar todo el contenido del handoff (menos los .md)
rsync -avz --exclude '*.md' ./ USER@TU_IP:/var/www/ivangalar/
```

O con `scp` si preferís:

```bash
scp -r index.html _ds assets USER@TU_IP:/var/www/ivangalar/
```

Verificá en el server:

```bash
ls /var/www/ivangalar/
# index.html  _ds  assets
```

## 3 · Configurar nginx

Crear `/etc/nginx/sites-available/ivangalar`:

```nginx
server {
    listen 80;
    server_name TU_DOMINIO www.TU_DOMINIO;

    root /var/www/ivangalar;
    index index.html;

    # cache largo para assets, corto para HTML
    location ~* \.(png|jpg|jpeg|webp|woff2?|ttf|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    location / {
        try_files $uri $uri/ /index.html;
    }

    # gzip
    gzip on;
    gzip_types text/css application/javascript image/svg+xml;
}
```

Activar y recargar:

```bash
ln -s /etc/nginx/sites-available/ivangalar /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

Probá con la IP: `http://TU_IP/` — debería levantar.

## 4 · DNS

En tu proveedor de dominio, crear dos A-records apuntando a `TU_IP`:

- `@` → TU_IP
- `www` → TU_IP

Esperá a que propague (`dig TU_DOMINIO +short` debe devolver la IP).

## 5 · HTTPS con Let's Encrypt

```bash
certbot --nginx -d TU_DOMINIO -d www.TU_DOMINIO
```

Seguí el wizard, elegí redirect HTTP → HTTPS. Certbot renueva solo vía cron.

## 6 · Deploys futuros

Sólo hay que re-sincronizar:

```bash
rsync -avz --delete --exclude '*.md' ./ USER@TU_IP:/var/www/ivangalar/
```

`--delete` limpia archivos que ya no existan en el bundle local.

---

## Troubleshooting

- **403 Forbidden** → permisos: `chown -R www-data:www-data /var/www/ivangalar`
- **404 en assets** → verificá que la carpeta `_ds/` se copió entera (rsync a veces omite dot-folders con patrones raros; el nombre empieza con `_` pero no con `.`, así que debería estar OK)
- **Fuentes no cargan** → las tipografías son Google Fonts vía `@import` en `typography.css`; requiere que el server tenga salida a internet en cliente, no en server — funciona
- **Firewall** → Contabo abre 80/443 por default; si usaste `ufw`: `ufw allow 'Nginx Full'`
