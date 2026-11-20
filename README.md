# Portal Acadêmico (Flutter)

App acadêmico **somente front-end**: Home, Notas, Faltas e Perfil, com dados
mockados em JSON local. Sem backend, sem API, funciona 100% offline.

- Flutter + Dart, Material Design 3
- Sem pacotes externos (só o Flutter SDK)
- Fonte Poppins embutida em `assets/fonts`
- Dados em `lib/data/mock_data.json`

## Estrutura

```
lib/
├── main.dart                     # ponto de entrada + troca loading/erro/app
├── data/
│   └── mock_data.json            # usuário, disciplinas, notas, faltas, horários...
├── models/                       # User, Subject, Grade, Absence, ClassSchedule...
├── services/
│   ├── academic_repository.dart  # contrato (interface) da camada de dados
│   ├── local_academic_repository.dart  # implementação que lê o JSON
│   └── app_controller.dart       # estado global (ChangeNotifier) + AppScope
├── screens/
│   ├── main_shell.dart           # BottomNavigationBar + IndexedStack
│   ├── home_screen.dart          # Tela 1 — Dashboard
│   ├── grades_screen.dart        # Tela 2 — Notas
│   ├── absences_screen.dart      # Tela 3 — Faltas
│   ├── absence_detail_screen.dart
│   ├── profile_screen.dart       # Tela 4 — Perfil
│   ├── edit_profile_screen.dart
│   ├── schedule_screen.dart      # "Aulas"
│   └── notifications_screen.dart
├── widgets/                      # SubjectCard, GradeCard, AbsenceCard, CustomAppBar,
│                                 # DashboardCard, BottomNavBar, PeriodSelector...
├── theme/                        # cores e ThemeData (Material 3)
└── utils/formatters.dart         # datas e notas no padrão brasileiro
android/                          # projeto Android pronto (Gradle Kotlin DSL)
```

## Rodar no celular/emulador

```bash
flutter pub get
flutter run
```

## Gerar o APK Release

```bash
flutter clean
flutter pub get
flutter build apk --release
```

O APK fica em:

```
build/app/outputs/flutter-apk/app-release.apk
```

Copie para o celular e instale (ative "Instalar apps desconhecidos"), ou com o
celular no cabo: `flutter install` / `adb install build/app/outputs/flutter-apk/app-release.apk`.

APKs menores (um por arquitetura):

```bash
flutter build apk --release --split-per-abi
# celulares atuais usam: app-arm64-v8a-release.apk
```

## Assinar com a sua chave (Play Store)

Sem `android/key.properties`, o release é assinado com a chave de debug (instala
normalmente para testes). Para publicar:

1. Crie a chave (uma vez só — guarde o arquivo e as senhas!):
   ```bash
   keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA \
     -keysize 2048 -validity 10000 -alias upload
   ```
2. Copie `android/key.properties.example` para `android/key.properties` e preencha.
3. Gere o pacote da Play Store:
   ```bash
   flutter build appbundle --release
   # build/app/outputs/bundle/release/app-release.aab
   ```

## Se o build Android der erro

A pasta `android/` segue o template do Flutter estável atual (3.50: AGP 9.3.1,
Gradle 9.5.0, Kotlin 2.4.20, Java 17+).

- Rode `flutter upgrade` e `flutter doctor` (aceite as licenças com
  `flutter doctor --android-licenses`).
- Com um Flutter mais antigo, regenere a pasta Android com o template da sua versão:
  ```bash
  # apague (ou renomeie) a pasta android/ e rode:
  flutter create --platforms=android --org com.leonardo --project-name portal_academico .
  ```
  O `lib/`, o `pubspec.yaml` e os assets não são sobrescritos. Depois, se quiser,
  troque o `android:label` no `AndroidManifest.xml` por "Portal Acadêmico".

## Integração futura com API

As telas só conhecem o `AppController`, que usa um `AcademicRepository`.
Para trocar o JSON por uma API, crie `ApiAcademicRepository implements
AcademicRepository` (com `http` ou `dio`) e troque a linha no `main.dart`:

```dart
AppController(const LocalAcademicRepository())  // ->  AppController(ApiAcademicRepository())
```

Os modelos já têm `fromJson`/`toJson`.

## Regras das faltas

| % do limite | Cor | Mensagem |
|---|---|---|
| até 70% | verde | — |
| 71% a 100% | amarelo | "Fique atento!" |
| acima de 100% | vermelho | "Você estourou o limite de faltas desta disciplina." |

Igual ao app original (20/20 ainda aparece em amarelo). Para 100% já ficar
vermelho, ajuste `AbsenceRules` em `lib/models/absence.dart`.
