// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instalog/instalog.dart';
import 'components/components.dart';

void main() {
  Instalog.instance.crash.setup(
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiTEC = TextEditingController();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Instalog',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                "Welcome to Instalog's flutter example",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: apiTEC,
                onFieldSubmitted: (text) {
                  Instalog.instance.initialize(
                    apiKey: text,
                    options: const InstalogOptions(
                      isLogEnabled: true,
                      isLoggerEnabled: true,
                      isCrashEnabled: true,
                      isFeedbackEnabled: true,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: InstalogColors.green,
                      content: Text('API Key updated'),
                    ),
                  );
                },
                decoration: InstalogColors.textFieldDecoration.copyWith(
                  hintText: 'Enter api key...',
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  InstalogButton(
                    onClick: () => showFeedback(),
                    text: 'Feedback',
                    buttonColor: InstalogColors.green,
                  ),
                  const SizedBox(height: 16),
                  InstalogButton(
                    onClick: () => logEvent(),
                    text: 'Send Event',
                  ),
                  const SizedBox(height: 16),
                  InstalogButton(
                    onClick: () => simulateCrash(),
                    text: 'Simulate Crash',
                    buttonColor: InstalogColors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logEvent() async {
    Instalog.instance.logEvent(
      event: 'user_login',
      params: {'name': 'John doe', 'age': '20'},
    );
  }

  Future<void> showFeedback() async {
    Instalog.instance.showFeedbackModal();
  }

  Future<void> initialize() async {
    Instalog.instance.initialize(
      apiKey: 'instalog_ea1801ecfc294eb4b985f2bbef7da498',
      options: const InstalogOptions(
        isLogEnabled: true,
        isLoggerEnabled: true,
        isCrashEnabled: true,
        isFeedbackEnabled: true,
      ),
    );
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    Instalog.instance.identifyUser(userId: userId);
  }

  void simulateCrash() {
    // This will cause a real crash that will be caught by Instalog.instance.crash
    throw Exception('This is a simulated crash');
  }
}
