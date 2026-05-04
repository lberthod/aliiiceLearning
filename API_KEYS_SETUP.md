# 🔑 Configuration des Clés API pour AliceLearnthai

## ⚠️ IMPORTANT
Les clés API sont **secrets** et ne doivent **JAMAIS** être commitées à Git.

## Setup (2 minutes)

### Étape 1: Créer le fichier Config.xcconfig

```bash
cd AliiceThai-App
cp Config.xcconfig.template Config.xcconfig
```

### Étape 2: Ajouter vos clés API

Ouvre `Config.xcconfig` et remplace:
```xcconfig
OPENAI_API_KEY = sk-YOUR_OPENAI_API_KEY_HERE
DEEPSEEK_API_KEY = sk-YOUR_DEEPSEEK_API_KEY_HERE
```

Par vos vraies clés:
```xcconfig
OPENAI_API_KEY = sk-proj-abcdef123456...
DEEPSEEK_API_KEY = sk-a1b2c3d4e5f6...
```

### Étape 3: Configurer Xcode

1. **Ouvre le projet** dans Xcode
2. **Sélectionne** le projet dans le navigator
3. **Onglet "Build Settings"**
4. **Recherche** "User-Defined"
5. **Ajoute** deux clés:
   - `OPENAI_API_KEY` = (ta valeur)
   - `DEEPSEEK_API_KEY` = (ta valeur)

**OU** laisse Xcode charger depuis Config.xcconfig automatiquement.

### Étape 4: Test

```bash
# Build et run l'app
xcodebuild -scheme AliiceThai-App build
```

L'app devrait **démarrer sans erreurs de clés API**.

## Obtenir les clés API

### OpenAI (Whisper)
1. Va sur https://platform.openai.com/account/api-keys
2. Clique "Create new secret key"
3. Copie la clé dans Config.xcconfig

**Coût:** ~$0.02 per minute of audio (très cheap)

### Deepseek (Feedback AI)
1. Va sur https://platform.deepseek.com (ou ton provider)
2. Crée un API key
3. Copie la clé dans Config.xcconfig

**Coût:** ~$0.0001 per 1K tokens (ultra cheap)

## Vérification ✅

Après config, teste en:
1. **Ouvre l'app**
2. **Va dans** "Speaking Tasks"
3. **Sélectionne** un mot
4. **Enregistre** ta voix
5. Tu devrais voir "Analyzing..." puis le feedback

Si tu vois des erreurs "❌ API key not configured", vérifie:
- [ ] Config.xcconfig existe?
- [ ] Les clés sont correctes?
- [ ] Xcode utilise Config.xcconfig?

## Sécurité 🔒

✅ **Fait:**
- Config.xcconfig est dans .gitignore
- Template Config.xcconfig.template peut être commité
- Les secrets ne sont jamais dans le repo

⚠️ **À ne PAS faire:**
- Ne mets JAMAIS les vraies clés dans Swift code
- Ne push pas Config.xcconfig
- Ne partage pas tes clés API

## Troubleshooting

**Q: "OpenAI API key not configured"**
- A: Config.xcconfig n'a pas les bonnes clés, ou Xcode ne les charge pas

**Q: "Deepseek API key not configured"**
- A: Même problème. Vérifie que Config.xcconfig existe ET est chargé par Xcode

**Q: Les clés ne se chargent pas?**
- A: Dans Xcode, va à Project Settings et ajoute les clés manuellement dans Build Settings
