import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'register.dart';
import 'account.dart'; // Importa la pantalla principal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Inicializa Hive
  await Hive.openBox('usuarios'); // Abre la caja de usuarios
  runApp(const MyApp());
}

// Paleta de colores personalizada actualizada con tonos más vivos
class AppColors {
  static const Color primary = Color.fromARGB(255, 53, 136, 125); // Azul más brillante
  static const Color secondary = Color(0xFFD0E8FF); // Azul muy claro y fresco
  static const Color accent = Color(0xFFFFFFFF); // Blanco puro para contraste
  static const Color text = Color(0xFF1B1F3B); // Azul oscuro para texto
  static const Color error = Color(0xFFE94B3C); // Rojo vibrante para errores
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cogela Suave',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.secondary,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text, fontFamily: 'Poppins'),
        ),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 69, 173, 159),
          foregroundColor: AppColors.text,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(const Color.fromARGB(255, 0, 255, 234)),
            foregroundColor: MaterialStatePropertyAll(AppColors.text),
            textStyle: MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/home': (context) => const AccountPage(), // Aquí conectas la pantalla principal
      },
    );
  }
}

// Página de Login mejorada
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  void _login() async {
    bool valido = await validarUsuario(_emailController.text, _passwordController.text);
    if (valido) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _error = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bienvenido a Cogela Suave",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Este sera tu lugar seguro, uno hecho solo para ti",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text("Iniciar Sesión"),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: const Text("Si, eres nuevo empieza aquí"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Página de Cuenta con navegación entre pestañas
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Cuenta"),
      ),
      body: _selectedIndex == 0
          ? const ActivityRegistrationPage()
          : _selectedIndex == 1
              ? const CalendarPage()
              : const EmotionRegistrationPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Cronograma para tu dia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Registrar Emociones',
          ),
        ],
      ),
    );
  }
}

// Página para registrar actividades
class ActivityRegistrationPage extends StatelessWidget {
  const ActivityRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Lógica para registrar actividades
        },
        child: const Text("Registrar Actividad"),
      ),
    );
  }
}

// Página de calendario
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Empieza un nuevo calendario aqui"),
    );
  }
}

// Página para registrar emociones
class EmotionRegistrationPage extends StatelessWidget {
  const EmotionRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Lógica para registrar emociones
        },
        child: const Text("Registremos tus emociones"),
      ),
    );
  }
}

// Puedes poner esto en cualquier archivo donde necesites leer usuarios
Future<List<Map>> obtenerUsuarios() async {
  var box = Hive.box('usuarios');
  return box.values.cast<Map>().toList();
}

// Puedes poner esta función en main.dart o donde manejes el login
Future<bool> validarUsuario(String apodo, String contrasena) async {
  var box = Hive.box('usuarios');
  for (var usuario in box.values) {
    if (usuario['apodo'] == apodo && usuario['contrasena'] == contrasena) {
      return true; // Usuario y contraseña correctos
    }
  }
  return false; // No coincide
}

