import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _isLoggedInKey = 'is_logged_in';

  // Регистрация нового пользователя
  Future<User> register({
    required String email,
    required String username,
    required String password,
  }) async {
    // Валидация
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Некорректный email');
    }
    if (username.isEmpty || username.length < 3) {
      throw Exception('Имя пользователя должно содержать минимум 3 символа');
    }
    if (password.isEmpty || password.length < 6) {
      throw Exception('Пароль должен содержать минимум 6 символов');
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    // Проверка существующих пользователей
    Map<String, dynamic> users = {};
    if (usersJson != null) {
      users = json.decode(usersJson) as Map<String, dynamic>;
    }

    // Проверка на существующий email
    for (var userData in users.values) {
      final user = User.fromJson(userData as Map<String, dynamic>);
      if (user.email.toLowerCase() == email.toLowerCase()) {
        throw Exception('Пользователь с таким email уже существует');
      }
      if (user.username.toLowerCase() == username.toLowerCase()) {
        throw Exception('Пользователь с таким именем уже существует');
      }
    }

    // Создание нового пользователя
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = User(
      id: userId,
      email: email,
      username: username,
      createdAt: DateTime.now(),
    );

    // Сохранение пароля (в реальном приложении нужно хешировать!)
    final userData = {
      'user': newUser.toJson(),
      'password': password, // ВНИМАНИЕ: В продакшене нужно использовать хеширование!
    };

    users[userId] = userData;
    await prefs.setString(_usersKey, json.encode(users));

    // Автоматический вход после регистрации
    await login(email, password);

    return newUser;
  }

  // Вход пользователя
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Заполните все поля');
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) {
      throw Exception('Пользователь не найден');
    }

    final users = json.decode(usersJson) as Map<String, dynamic>;

    // Поиск пользователя по email
    User? foundUser;
    String? foundPassword;

    for (var userData in users.values) {
      final data = userData as Map<String, dynamic>;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      
      if (user.email.toLowerCase() == email.toLowerCase()) {
        foundUser = user;
        foundPassword = data['password'] as String?;
        break;
      }
    }

    if (foundUser == null) {
      throw Exception('Пользователь не найден');
    }

    if (foundPassword != password) {
      throw Exception('Неверный пароль');
    }

    // Сохранение текущего пользователя
    await prefs.setString(_currentUserKey, json.encode(foundUser.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return foundUser;
  }

  // Выход
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Получить текущего пользователя
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (!isLoggedIn) {
      return null;
    }

    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) {
      return null;
    }

    try {
      final userData = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // Проверка авторизации
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Обновление профиля пользователя
  Future<User> updateProfile({
    required String userId,
    required String newUsername,
  }) async {
    if (newUsername.isEmpty || newUsername.length < 3) {
      throw Exception('Имя пользователя должно содержать минимум 3 символа');
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) {
      throw Exception('Пользователь не найден');
    }

    final users = json.decode(usersJson) as Map<String, dynamic>;
    
    if (!users.containsKey(userId)) {
      throw Exception('Пользователь не найден');
    }

    // Проверка на уникальность имени
    for (var entry in users.entries) {
      if (entry.key != userId) {
        final user = User.fromJson((entry.value as Map<String, dynamic>)['user'] as Map<String, dynamic>);
        if (user.username.toLowerCase() == newUsername.toLowerCase()) {
          throw Exception('Пользователь с таким именем уже существует');
        }
      }
    }

    // Обновление данных
    final userData = users[userId] as Map<String, dynamic>;
    final user = User.fromJson(userData['user'] as Map<String, dynamic>);
    final updatedUser = User(
      id: user.id,
      email: user.email,
      username: newUsername,
      createdAt: user.createdAt,
    );

    userData['user'] = updatedUser.toJson();
    users[userId] = userData;

    await prefs.setString(_usersKey, json.encode(users));
    await prefs.setString(_currentUserKey, json.encode(updatedUser.toJson()));

    return updatedUser;
  }
}
