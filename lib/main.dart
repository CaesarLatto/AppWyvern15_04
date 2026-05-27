import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get_it/get_it.dart';

// --- Firebase Imports ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

// ---  Views  Controllers ---
import 'controller/iniciarlogin_controller.dart';
import 'view/cadastro_view.dart';
import 'view/iniciarlogin_view.dart';
import 'view/recuperar_senha_view.dart';
import 'view/menuprincipal_view.dart';
import 'view/addserver_view.dart';
import 'view/amigos_view.dart';
import 'view/informacoes_view.dart';
import 'view/personalizacao_view.dart';
import 'view/sobre_view.dart';

final g = GetIt.instance; //  final serve pra criar uma variável global para acessar
                          // o GetIt em toda o app, sem precisar passar a instancia

// Changed to async to allow Firebase to load before the app starts
void main() async {
  // Required so Flutter doesn't draw the UI before Firebase is ready
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wakes up Firebase using the configured options for the current platform.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  g.registerSingleton<IniciarloginController>(IniciarloginController());

  runApp(
    DevicePreview(builder: (context) => const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo Wyvern',
      theme: ThemeData( // theme serve para personalizar o tema do app, fontes etc
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF36393E),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2F3136),
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2F3136),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: 'iniciarlogin', // define a tela inicial, e logo abaixo, as rotas
      routes: {
        'iniciarlogin': (context) => const IniciarloginView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'cadastro': (context) => CadastroView(),
        'menuprincipal': (context) => const MenuPrincipalView(),
        'addserver': (context) => const AddServerView(),
        'amigos': (context) => const AmigosView(),
        'informacoes': (context) => const InformacoesView(),
        'personalizacao': (context) => const PersonalizacaoView(),
        'sobre': (context) => const SobreView(),
      }, // cada um desses é uma rota, uma tela do app, e o 
         //nome da rota é o que vai ser usado para navegar entre as telas
    );
  }
}