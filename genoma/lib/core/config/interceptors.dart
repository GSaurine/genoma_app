import 'package:dio/dio.dart';

/// Interceptors reutilizáveis para o Dio.
/// - `LoggingInterceptor`: logs simples (substitua por logger se preferir)
/// - `TokenInterceptor`: adiciona header Authorization via callback
/// - `ErrorInterceptor`: trata 401 e chama callback de limpeza de credenciais
/// - `RequestInterceptor`: adiciona token e apiKey (opcional)
class LoggingInterceptor extends Interceptor {
	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
		// Troque por um logger se preferir (ex: package:logger)
		print('--> ${options.method} ${options.uri}');
		handler.next(options);
	}

	@override
	void onResponse(Response response, ResponseInterceptorHandler handler) {
		print('<-- ${response.statusCode} ${response.requestOptions.uri}');
		handler.next(response);
	}

	@override
	void onError(DioException err, ErrorInterceptorHandler handler) {
		print('<-- ERROR ${err.message}');
		handler.next(err);
	}
}

class TokenInterceptor extends Interceptor {
	final String Function() getToken;
	TokenInterceptor(this.getToken);

	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
		final token = getToken();
		if (token.isNotEmpty) {
			options.headers['Authorization'] = 'Bearer $token';
		}
		handler.next(options);
	}
}

class ErrorInterceptor extends Interceptor {
	final void Function()? onUnauthorized;
	ErrorInterceptor({this.onUnauthorized});

	@override
	void onError(DioException err, ErrorInterceptorHandler handler) {
		if (err.response?.statusCode == 401) {
			onUnauthorized?.call();
		}
		handler.next(err);
	}
}

class RequestInterceptor extends Interceptor {
	final String Function() getToken;
	final String Function()? getApiKey;

	RequestInterceptor({required this.getToken, this.getApiKey});

	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
		final token = getToken();
		if (token.isNotEmpty) options.headers['Authorization'] = 'Bearer $token';

		final apiKey = getApiKey?.call() ?? '';
		if (apiKey.isNotEmpty) options.headers['x-api-key'] = apiKey;

		handler.next(options);
	}
}
