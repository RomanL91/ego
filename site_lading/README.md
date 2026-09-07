# rlebedev.dev — статический сайт

Самодостаточные HTML-страницы плюс картинки. Никакой сборки и зависимостей:
содержимое папки кладётся в корень сайта как есть.

## Что внутри

- `index.html` — главная: кто я, боль заказчика, диапазон, услуги, проекты
- `uslugi/` — раздел услуг: каталог, форматы работы, ставка, стадии,
  гарантии, границы и частые вопросы
- `uslugi/*/` — девять страниц услуг под конкретные поисковые запросы
- десять папок с кейсами, по одной на проект
- `roman.jpg`, `sitemap.xml`, `robots.txt`, `404.html`

Адреса — папками: `/metis-one/`, `/uslugi/integraciya-s-moyskladom/`. Ссылки
внутри сайта абсолютные от корня, поэтому открывать файлы двойным щелчком
с диска больше нельзя — нужен любой сервер. Для локальной проверки хватит
`python -m http.server` в корне.

## Куда выложить

**Свой сервер с nginx.** Скопировать содержимое папки и добавить блок:

```nginx
server {
    listen 443 ssl http2;
    server_name rlebedev.dev www.rlebedev.dev;

    root /var/www/rlebedev.dev;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;

    location ~* \.(jpg|png|webp|svg|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    location ~* \.(html|xml)$ {
        add_header Cache-Control "public, max-age=300";
    }

    gzip on;
    gzip_types text/html text/css application/javascript application/xml image/svg+xml;
}
```

**GitHub Pages.** Залить папку в репозиторий, включить Pages из ветки, указать
Custom domain. Файл `.nojekyll` уже лежит рядом.

**Netlify / Vercel / Cloudflare Pages.** Перетащить папку: команда сборки не
нужна, каталог публикации — корень.

## DNS

`A`-запись на IP сервера (или `CNAME` на домен хостинга) плюс `CNAME` для `www`.
Сертификат: certbot на своём сервере, у хостингов выдаётся автоматически.

## Что уже сделано по SEO

- `title` и `description` под выдачу на каждой странице
- микроразметка JSON-LD: `Person` + `ProfilePage` + два `ItemList` на главной,
  `Service` + `OfferCatalog` + `FAQPage` + `BreadcrumbList` на услугах,
  `ItemList` + `FAQPage` на каталоге услуг, `CreativeWork` + `BreadcrumbList`
  на кейсах
- `sameAs` на GitHub и Telegram — этим поисковик связывает сайт с профилями
- Open Graph и `twitter:card` с фото, `canonical`, `robots: max-image-preview:large`
- один `<h1>` на страницу, `<main>`, `<nav>`, хлебные крошки, ссылка «К содержанию»
- перелинковка: с каждого кейса — три похожих проекта, с услуг — релевантные
  кейсы и каталог услуг
- `sitemap.xml` со всеми адресами и `robots.txt`

## Что нужно сделать руками

1. **Подтвердить права** в Google Search Console и Яндекс.Вебмастере — проще
   всего DNS TXT-записью, либо мета-тегом в `<head>` главной:

   ```html
   <meta name="google-site-verification" content="…">
   <meta name="yandex-verification" content="…">
   ```

2. **Отправить карту сайта** в обеих панелях и запросить переобход главной.

3. **Проставить обратные ссылки.** На индексацию персонального сайта они влияют
   сильнее любой разметки: профиль GitHub, README публичных репозиториев, шапка
   Telegram, резюме на hh, Хабр Карьера. Отдельно стоит договориться о ссылке
   с сайтов заказчиков — она весит больше всех перечисленных.

4. **Перевести шрифты на свой домен.** Сейчас они грузятся с Google Fonts —
   это лишний домен и задержка первой отрисовки. Запустить `./download-fonts.sh`
   из корня сайта, затем заменить в страницах ссылку на `fonts.googleapis.com`
   на `<link rel="stylesheet" href="/fonts/fonts.css">`. Заготовка `@font-face`
   лежит в `fonts/fonts.css`, имена файлов поправить под скачанные.

5. **Проверить разметку** после выкладки: `search.google.com/test/rich-results`
   и валидатор Яндекса.
