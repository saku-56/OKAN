// キャッシュ名
const CACHE_NAME = 'okan-cache-v1';

// キャッシュするリソース
const urlsToCache = [
  '/',
  '/manifest.json',
  '/pwa/icon-192x192.png',
  '/pwa/icon-512x512.png',
  '/favicon/favicon.ico',
  '/favicon/favicon-16x16.png',
  '/favicon/favicon-32x32.png',
  '/favicon/apple-touch-icon.png'
];

// Service Worker のインストール
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

// キャッシュからレスポンスを返す
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => response || fetch(event.request))
  );
});