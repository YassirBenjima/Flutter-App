# Configuration du Port Fixe pour Flutter Web

## 🎯 Solution : Port Fixe 8080

Pour éviter d'ajouter un nouveau port à chaque fois dans Google Cloud Console, nous utilisons un **port fixe : 8080**.

## 📋 Configuration dans Google Cloud Console

Ajoutez ces URI de redirection **UNE SEULE FOIS** :

### Authorized redirect URIs :

```
http://localhost:8080
http://127.0.0.1:8080
```

### Authorized JavaScript origins :

```
http://localhost:8080
http://127.0.0.1:8080
```

## 🚀 Comment lancer l'application avec le port fixe

### Option 1 : Avec VS Code

1. Ouvrez VS Code dans le dossier `CoLearn`
2. Allez dans l'onglet **Run and Debug** (Ctrl+Shift+D)
3. Sélectionnez **"CoLearn (Web - Port 8080 - Chrome)"**
4. Cliquez sur le bouton Play ▶️

### Option 2 : Avec le script (Windows)

Double-cliquez sur `run_web.bat` ou dans le terminal :

```bash
run_web.bat
```

### Option 3 : Avec le script (Linux/Mac)

```bash
chmod +x run_web.sh
./run_web.sh
```

### Option 4 : Commande manuelle

```bash
flutter run -d chrome --web-port=8080
```

## ✅ Avantages

- ✅ Port toujours fixe : `8080`
- ✅ Configuration Google Cloud Console une seule fois
- ✅ Pas besoin d'ajouter de nouveaux ports
- ✅ URL stable : `http://localhost:8080`

## 🔧 Changer le port

Si vous voulez utiliser un autre port (par exemple 5000) :

1. Modifiez `run_web.bat` et `run_web.sh` :

   - Remplacez `8080` par `5000`

2. Modifiez `.vscode/launch.json` :

   - Remplacez `8080` par `5000`

3. Ajoutez le nouveau port dans Google Cloud Console :
   - `http://localhost:5000`
   - `http://127.0.0.1:5000`

## 📝 Note

Le port 8080 est standard et rarement utilisé par d'autres applications.
Si le port est déjà occupé, utilisez un autre port (ex: 8081, 8082, etc.)

