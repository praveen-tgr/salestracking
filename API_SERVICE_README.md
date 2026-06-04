# API Service with Caching

This Flutter app now includes an `ApiService` that provides RTK Query-like functionality with automatic caching using Dio and DioCacheInterceptor.

## Features

- **Automatic Caching**: GET requests are cached to avoid unnecessary API calls.
- **Token Management**: Automatically adds authorization headers if a token is stored in SharedPreferences.
- **Error Handling**: Built-in error handling and logging.
- **Cache Management**: Methods to clear cache and retrieve cached responses.

## Usage

### Basic API Calls

```dart
final apiService = Provider.of<ApiService>(context, listen: false);

// GET request with caching
Response response = await apiService.get('endpoint/path');

// POST request (not cached by default)
Response response = await apiService.post('endpoint/path', data: {'key': 'value'});

// PUT request
Response response = await apiService.put('endpoint/path', data: {'key': 'value'});

// DELETE request
Response response = await apiService.delete('endpoint/path');
```

### Cache Control

```dart
// Clear all cache
await apiService.clearCache();

// Get cached response
CacheResponse? cached = await apiService.getCachedResponse('full-url');
```

### Custom Options

You can pass custom `Options` to control caching behavior:

```dart
Options options = Options(
  extra: {
    'dio_cache_interceptor': CacheOptions(
      policy: CachePolicy.forceCache, // Force using cache
    ),
  },
);

Response response = await apiService.get('endpoint', options: options);
```

## How It Works

- **Caching Policy**: By default, uses `CachePolicy.request` which caches responses and serves from cache when offline or for repeated requests.
- **Cache Duration**: Cached responses are valid for 7 days by default.
- **Authentication**: Automatically includes Bearer token from SharedPreferences in request headers.
- **Logging**: All requests and responses are logged for debugging.

## Migration from HTTP

Replace direct `http` calls with `ApiService` methods. The service handles JSON encoding/decoding automatically and provides better error handling.

## Dependencies Added

- `dio`: HTTP client
- `dio_cache_interceptor`: Caching interceptor
- `dio_cache_interceptor_hive_store`: Hive-based cache storage
- `path_provider`: For getting app directory for cache storage