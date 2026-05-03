import Foundation

struct GrammarTopic {
    let id: String
    let titleEn: String
    let titleFr: String
    let icon: String
    let descriptionEn: String
    let descriptionFr: String
    let rules: [GrammarRule]
    let examples: [GrammarExample]
    let patterns: [GrammarPattern]
    let commonMistakes: [CommonMistake]
}

struct GrammarRule {
    let ruleEn: String
    let ruleFr: String
    let explanation: String
    let explanationFr: String
}

struct GrammarExample {
    let thai: String
    let romanization: String
    let englishTranslation: String
    let frenchTranslation: String
    let structure: String
}

struct GrammarPattern {
    let patternEn: String
    let patternFr: String
    let example: String
    let description: String
}

struct CommonMistake {
    let incorrectThai: String
    let correctThai: String
    let explanationEn: String
    let explanationFr: String
}

let grammarTopicsData: [GrammarTopic] = [
    // PRONOUNS
    GrammarTopic(
        id: "pronouns",
        titleEn: "Pronouns",
        titleFr: "Pronoms",
        icon: "👤",
        descriptionEn: "Personal pronouns in Thai",
        descriptionFr: "Pronoms personnels en thaï",
        rules: [
            GrammarRule(
                ruleEn: "Pronouns come before the verb",
                ruleFr: "Les pronoms viennent avant le verbe",
                explanation: "Thai pronouns are always placed at the beginning of the sentence, before any verb or adjective",
                explanationFr: "Les pronoms thaïs sont toujours placés au début de la phrase, avant tout verbe ou adjectif"
            ),
            GrammarRule(
                ruleEn: "Different pronouns for relationships",
                ruleFr: "Différents pronoms pour les relations",
                explanation: "The choice depends on gender, age, relationship, and formality. Elders use different pronouns with juniors",
                explanationFr: "Le choix dépend du sexe, de l'âge, de la relation et de la formalité. Les aînés utilisent des pronoms différents avec les cadets"
            ),
            GrammarRule(
                ruleEn: "Pronouns can be omitted",
                ruleFr: "Les pronoms peuvent être omis",
                explanation: "In conversational Thai, pronouns are often dropped when the context is clear",
                explanationFr: "En thaï conversationnel, les pronoms sont souvent omis quand le contexte est clair"
            )
        ],
        examples: [
            GrammarExample(
                thai: "ผม",
                romanization: "phom",
                englishTranslation: "I (formal, male)",
                frenchTranslation: "Je (formel, masculin)",
                structure: "Pronoun"
            ),
            GrammarExample(
                thai: "ฉัน",
                romanization: "chan",
                englishTranslation: "I (casual, neutral)",
                frenchTranslation: "Je (casual, neutre)",
                structure: "Pronoun"
            ),
            GrammarExample(
                thai: "ดิฉัน",
                romanization: "di-chan",
                englishTranslation: "I (formal, female)",
                frenchTranslation: "Je (formel, féminin)",
                structure: "Pronoun"
            ),
            GrammarExample(
                thai: "เธอ",
                romanization: "thoe",
                englishTranslation: "You (informal)",
                frenchTranslation: "Tu (informel)",
                structure: "Pronoun"
            ),
            GrammarExample(
                thai: "คุณ",
                romanization: "khun",
                englishTranslation: "You (formal/polite)",
                frenchTranslation: "Vous (formel/poli)",
                structure: "Pronoun"
            ),
            GrammarExample(
                thai: "เขา",
                romanization: "khao",
                englishTranslation: "He/She/They",
                frenchTranslation: "Il/Elle/Ils",
                structure: "Pronoun"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Pronoun + Verb",
                patternFr: "Pronom + Verbe",
                example: "ผม ไป → I go",
                description: "Basic structure with subject pronoun before action"
            ),
            GrammarPattern(
                patternEn: "Pronoun + Adjective",
                patternFr: "Pronom + Adjectif",
                example: "เขา สวย → He/She is beautiful",
                description: "Pronoun can work with adjectives (adjective = 'to be' + adjective)"
            ),
            GrammarPattern(
                patternEn: "Pronoun + Negation + Verb",
                patternFr: "Pronom + Négation + Verbe",
                example: "ผม ไม่ ชอบ → I don't like",
                description: "Adding negation between pronoun and verb"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "ไป ผม",
                correctThai: "ผม ไป",
                explanationEn: "Word order matters! Verb comes AFTER pronoun, not before",
                explanationFr: "L'ordre des mots compte! Le verbe vient APRÈS le pronom, pas avant"
            ),
            CommonMistake(
                incorrectThai: "คุณ ผม",
                correctThai: "ผม or คุณ",
                explanationEn: "Use only one pronoun. 'คุณ' and 'ผม' shouldn't be together",
                explanationFr: "Utilisez un seul pronom. 'คุณ' et 'ผม' ne doivent pas être ensemble"
            ),
            CommonMistake(
                incorrectThai: "ผม ไป เขา",
                correctThai: "ผม ไป หา เขา",
                explanationEn: "Can't use two pronouns as subject/object without a verb connector",
                explanationFr: "Vous ne pouvez pas utiliser deux pronoms sans un connecteur verbal"
            )
        ]
    ),

    // SUBJECT + VERB + OBJECT
    GrammarTopic(
        id: "subject_verb",
        titleEn: "Subject + Verb + Object",
        titleFr: "Sujet + Verbe + Objet",
        icon: "📝",
        descriptionEn: "Basic sentence structure (SVO)",
        descriptionFr: "Structure de phrase basique (SVO)",
        rules: [
            GrammarRule(
                ruleEn: "Follow SVO word order",
                ruleFr: "Suivez l'ordre SVO",
                explanation: "Thai uses Subject-Verb-Object order like English. Place subject first, then verb, then object",
                explanationFr: "Le thaï utilise l'ordre Sujet-Verbe-Objet comme l'anglais. Placez d'abord le sujet, puis le verbe, puis l'objet"
            ),
            GrammarRule(
                ruleEn: "No auxiliary 'to be' needed",
                ruleFr: "Aucun auxiliaire 'être' nécessaire",
                explanation: "Thai doesn't need 'am/is/are' for linking sentences. Name + name = identity",
                explanationFr: "Le thaï n'a pas besoin de 'suis/es/est' pour les phrases de liaison. Nom + nom = identité"
            ),
            GrammarRule(
                ruleEn: "Particles modify meaning",
                ruleFr: "Les particules modifient le sens",
                explanation: "Small particles at the end of sentences change meaning (question, polite, etc.)",
                explanationFr: "Les petites particules à la fin des phrases changent le sens (question, poli, etc.)"
            )
        ],
        examples: [
            GrammarExample(
                thai: "ผม ชื่อ สมชาย",
                romanization: "phom chue somchai",
                englishTranslation: "I name Somchai (I am Somchai)",
                frenchTranslation: "Je m'appelle Somchai",
                structure: "Subject + Verb + Object"
            ),
            GrammarExample(
                thai: "เธอ กิน ข้าว",
                romanization: "thoe kin khao",
                englishTranslation: "You eat rice",
                frenchTranslation: "Tu manges du riz",
                structure: "Subject + Verb + Object"
            ),
            GrammarExample(
                thai: "เขา ไป โรงเรียน",
                romanization: "khao pai roong-rian",
                englishTranslation: "He/She goes to school",
                frenchTranslation: "Il/Elle va à l'école",
                structure: "Subject + Verb + Location"
            ),
            GrammarExample(
                thai: "หมา กัด คน",
                romanization: "maa gat khon",
                englishTranslation: "Dog bites person",
                frenchTranslation: "Le chien mord une personne",
                structure: "Subject + Verb + Object"
            ),
            GrammarExample(
                thai: "ผม รัก เธอ",
                romanization: "phom rak thoe",
                englishTranslation: "I love you",
                frenchTranslation: "Je t'aime",
                structure: "Subject + Verb + Object"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Subject + Verb + Object",
                patternFr: "Sujet + Verbe + Objet",
                example: "ผม กิน ข้าว",
                description: "Most common pattern for statements"
            ),
            GrammarPattern(
                patternEn: "Subject + Verb + Location",
                patternFr: "Sujet + Verbe + Lieu",
                example: "เขา ทำงาน ที่บ้าน",
                description: "When showing where action happens"
            ),
            GrammarPattern(
                patternEn: "Subject + Adjective (= to be + adj)",
                patternFr: "Sujet + Adjectif (= être + adj)",
                example: "เธอ สวย",
                description: "No 'to be' needed with adjectives"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "กิน เธอ ข้าว",
                correctThai: "เธอ กิน ข้าว",
                explanationEn: "Verb cannot come first. Always: Subject → Verb → Object",
                explanationFr: "Le verbe ne peut pas venir en premier. Toujours: Sujet → Verbe → Objet"
            ),
            CommonMistake(
                incorrectThai: "ผม ข้าว กิน",
                correctThai: "ผม กิน ข้าว",
                explanationEn: "Object comes after verb, not before. Subject → Verb → Object order",
                explanationFr: "L'objet vient après le verbe, pas avant. Ordre Sujet → Verbe → Objet"
            ),
            CommonMistake(
                incorrectThai: "ผม เป็น กิน",
                correctThai: "ผม กิน",
                explanationEn: "Don't use 'เป็น' (to be) with action verbs. Only with nouns/adjectives",
                explanationFr: "N'utilisez pas 'เป็น' (être) avec les verbes d'action. Seulement avec les noms/adjectifs"
            )
        ]
    ),

    // ADJECTIVES
    GrammarTopic(
        id: "adjectives",
        titleEn: "Adjectives",
        titleFr: "Adjectifs",
        icon: "✨",
        descriptionEn: "Describing words and qualities",
        descriptionFr: "Mots descriptifs et qualités",
        rules: [
            GrammarRule(
                ruleEn: "Adjectives FOLLOW nouns",
                ruleFr: "Les adjectifs SUIVENT les noms",
                explanation: "Unlike English (beautiful dog), Thai says 'dog beautiful' (หมา สวย)",
                explanationFr: "Contrairement à l'anglais (joli chien), le thaï dit 'chien joli' (หมา สวย)"
            ),
            GrammarRule(
                ruleEn: "Adjectives function as verbs",
                ruleFr: "Les adjectifs fonctionnent comme des verbes",
                explanation: "In Thai, 'เธอ สวย' means 'She IS beautiful' - no 'to be' needed",
                explanationFr: "En thaï, 'เธอ สวย' signifie 'Elle EST belle' - pas besoin de 'être'"
            ),
            GrammarRule(
                ruleEn: "Multiple adjectives stack",
                ruleFr: "Les adjectifs multiples s'empilent",
                explanation: "You can use several adjectives in a row: 'หมา ใหญ่ ดำ สวย' (big black beautiful dog)",
                explanationFr: "Vous pouvez utiliser plusieurs adjectifs à la suite: 'หมา ใหญ่ ดำ สวย' (grand chien noir beau)"
            )
        ],
        examples: [
            GrammarExample(
                thai: "หมา ดำ",
                romanization: "maa dam",
                englishTranslation: "Black dog",
                frenchTranslation: "Chien noir",
                structure: "Noun + Adjective"
            ),
            GrammarExample(
                thai: "บ้าน ใหญ่",
                romanization: "baan yai",
                englishTranslation: "Big house",
                frenchTranslation: "Grande maison",
                structure: "Noun + Adjective"
            ),
            GrammarExample(
                thai: "เธอ สวย",
                romanization: "thoe suay",
                englishTranslation: "You are beautiful",
                frenchTranslation: "Tu es belle",
                structure: "Subject + Adjective"
            ),
            GrammarExample(
                thai: "น้ำ เย็น",
                romanization: "nam yen",
                englishTranslation: "Water is cold",
                frenchTranslation: "L'eau est froide",
                structure: "Subject + Adjective"
            ),
            GrammarExample(
                thai: "รถ สีแดง เร็ว",
                romanization: "rot see dang reo",
                englishTranslation: "Red fast car",
                frenchTranslation: "Voiture rouge rapide",
                structure: "Noun + Adj + Adj"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Noun + Adjective",
                patternFr: "Nom + Adjectif",
                example: "หมา ใหญ่",
                description: "Basic adjective position - AFTER the noun"
            ),
            GrammarPattern(
                patternEn: "Subject + Adjective (no verb)",
                patternFr: "Sujet + Adjectif (pas de verbe)",
                example: "เธอ สวย",
                description: "Adjective replaces 'to be' verb"
            ),
            GrammarPattern(
                patternEn: "Noun + Multiple Adjectives",
                patternFr: "Nom + Adjectifs multiples",
                example: "หมา ใหญ่ ดำ",
                description: "Stack adjectives after the noun"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "สวย เธอ",
                correctThai: "เธอ สวย",
                explanationEn: "Adjective comes AFTER subject, not before",
                explanationFr: "L'adjectif vient APRÈS le sujet, pas avant"
            ),
            CommonMistake(
                incorrectThai: "หมา สวยดำ",
                correctThai: "หมา สวย ดำ",
                explanationEn: "Separate adjectives with space when stacking them",
                explanationFr: "Séparez les adjectifs avec un espace quand vous les empilez"
            ),
            CommonMistake(
                incorrectThai: "เธอ เป็น สวย",
                correctThai: "เธอ สวย",
                explanationEn: "Don't use 'เป็น' (to be) with adjectives",
                explanationFr: "N'utilisez pas 'เป็น' (être) avec les adjectifs"
            )
        ]
    ),

    // QUESTIONS
    GrammarTopic(
        id: "questions",
        titleEn: "Questions",
        titleFr: "Questions",
        icon: "❓",
        descriptionEn: "How to ask questions",
        descriptionFr: "Comment poser des questions",
        rules: [
            GrammarRule(
                ruleEn: "Question words come at END",
                ruleFr: "Les mots interrogatifs viennent à la FIN",
                explanation: "Thai questions often end with the question word, not start with it like English",
                explanationFr: "Les questions thaïes se terminent souvent par le mot interrogatif, pas commencent comme l'anglais"
            ),
            GrammarRule(
                ruleEn: "Use question particles",
                ruleFr: "Utilisez les particules interrogatives",
                explanation: "Add 'ไหม' (hai mai) at the end to turn statements into yes/no questions",
                explanationFr: "Ajoutez 'ไหม' (hai mai) à la fin pour transformer les affirmations en questions oui/non"
            ),
            GrammarRule(
                ruleEn: "No word order change needed",
                ruleFr: "Aucun changement d'ordre des mots nécessaire",
                explanation: "Just keep SVO order and add question word at the end",
                explanationFr: "Gardez simplement l'ordre SVO et ajoutez le mot interrogatif à la fin"
            )
        ],
        examples: [
            GrammarExample(
                thai: "เธอ ชื่อ อะไร?",
                romanization: "thoe chue arai?",
                englishTranslation: "Your name is what? (What is your name?)",
                frenchTranslation: "Ton nom est quoi?",
                structure: "Statement + Question Word"
            ),
            GrammarExample(
                thai: "เขา อยู่ ไหน?",
                romanization: "khao yu nai?",
                englishTranslation: "He is where? (Where is he?)",
                frenchTranslation: "Il est où?",
                structure: "Statement + Question Word"
            ),
            GrammarExample(
                thai: "เธอ กิน ข้าว ไหม?",
                romanization: "thoe kin khao hai mai?",
                englishTranslation: "Did you eat rice?",
                frenchTranslation: "As-tu mangé du riz?",
                structure: "Statement + Particle"
            ),
            GrammarExample(
                thai: "นี่ ใคร?",
                romanization: "nee khrai?",
                englishTranslation: "Who is this?",
                frenchTranslation: "Qui est-ce?",
                structure: "Statement + Question Word"
            ),
            GrammarExample(
                thai: "เมื่อไหร่ เธอ มา?",
                romanization: "meua-rai thoe ma?",
                englishTranslation: "When will you come?",
                frenchTranslation: "Quand viendras-tu?",
                structure: "Question Word + Statement"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Statement + Question Word",
                patternFr: "Affirmation + Mot interrogatif",
                example: "เขา ชื่อ อะไร?",
                description: "Most common question pattern"
            ),
            GrammarPattern(
                patternEn: "Statement + ไหม (hai mai)",
                patternFr: "Affirmation + ไหม (hai mai)",
                example: "เธอ สวย ไหม?",
                description: "Yes/no questions with rising inflection"
            ),
            GrammarPattern(
                patternEn: "Question Word + Statement",
                patternFr: "Mot interrogatif + Affirmation",
                example: "เมื่อไหร่ เธอ มา?",
                description: "Time questions at the beginning"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "อะไร เธอ ชื่อ?",
                correctThai: "เธอ ชื่อ อะไร?",
                explanationEn: "Question word comes at END, not at beginning like English",
                explanationFr: "Le mot interrogatif vient à la FIN, pas au début comme l'anglais"
            ),
            CommonMistake(
                incorrectThai: "เธอ สวย?",
                correctThai: "เธอ สวย ไหม?",
                explanationEn: "Add 'ไหม' at the end to make it a yes/no question",
                explanationFr: "Ajoutez 'ไหม' à la fin pour en faire une question oui/non"
            ),
            CommonMistake(
                incorrectThai: "ที่ไหน เขา อยู่?",
                correctThai: "เขา อยู่ ไหน?",
                explanationEn: "Keep normal SVO order, just add question word at the end",
                explanationFr: "Gardez l'ordre SVO normal, ajoutez simplement le mot interrogatif à la fin"
            )
        ]
    ),

    // NEGATION
    GrammarTopic(
        id: "negation",
        titleEn: "Negation",
        titleFr: "Négation",
        icon: "🚫",
        descriptionEn: "Making negative sentences",
        descriptionFr: "Faire des phrases négatives",
        rules: [
            GrammarRule(
                ruleEn: "Use 'ไม่' (mai) for general negation",
                ruleFr: "Utilisez 'ไม่' (mai) pour la négation générale",
                explanation: "'ไม่' is placed directly before the verb or adjective to negate it",
                explanationFr: "'ไม่' est placé directement avant le verbe ou l'adjectif pour le nier"
            ),
            GrammarRule(
                ruleEn: "Use 'ยัง' (yang) for 'not yet'",
                ruleFr: "Utilisez 'ยัง' (yang) pour 'pas encore'",
                explanation: "'ยัง' indicates something hasn't happened yet but will in the future",
                explanationFr: "'ยัง' indique que quelque chose ne s'est pas encore produit mais se produira à l'avenir"
            ),
            GrammarRule(
                ruleEn: "'ยัง ไม่' together for emphasis",
                ruleFr: "'ยัง ไม่' ensemble pour l'emphase",
                explanation: "Using both 'ยัง' and 'ไม่' together emphasizes 'still not' or 'not yet'",
                explanationFr: "Utiliser à la fois 'ยัง' et 'ไม่' ensemble souligne 'toujours pas' ou 'pas encore'"
            )
        ],
        examples: [
            GrammarExample(
                thai: "ผม ไม่ ชอบ",
                romanization: "phom mai chop",
                englishTranslation: "I don't like",
                frenchTranslation: "Je n'aime pas",
                structure: "Subject + ไม่ + Verb"
            ),
            GrammarExample(
                thai: "เขา ไม่ สวย",
                romanization: "khao mai suay",
                englishTranslation: "He/She is not beautiful",
                frenchTranslation: "Il/Elle n'est pas belle",
                structure: "Subject + ไม่ + Adjective"
            ),
            GrammarExample(
                thai: "เธอ ยัง ไม่ มา",
                romanization: "thoe yang mai ma",
                englishTranslation: "You haven't come yet",
                frenchTranslation: "Tu n'es pas encore venu",
                structure: "Subject + ยัง + ไม่ + Verb"
            ),
            GrammarExample(
                thai: "ผม ยัง หิว",
                romanization: "phom yang hiw",
                englishTranslation: "I'm still hungry",
                frenchTranslation: "J'ai toujours faim",
                structure: "Subject + ยัง + Adjective"
            ),
            GrammarExample(
                thai: "เขา ไม่ ไป โรงเรียน",
                romanization: "khao mai pai roong-rian",
                englishTranslation: "He doesn't go to school",
                frenchTranslation: "Il ne va pas à l'école",
                structure: "Subject + ไม่ + Verb + Object"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Subject + ไม่ + Verb/Adjective",
                patternFr: "Sujet + ไม่ + Verbe/Adjectif",
                example: "ผม ไม่ ชอบ",
                description: "Standard negation pattern"
            ),
            GrammarPattern(
                patternEn: "Subject + ยัง + ไม่ + Verb",
                patternFr: "Sujet + ยัง + ไม่ + Verbe",
                example: "เธอ ยัง ไม่ มา",
                description: "For 'still not' or 'not yet' emphasis"
            ),
            GrammarPattern(
                patternEn: "Subject + ยัง + Adjective",
                patternFr: "Sujet + ยัง + Adjectif",
                example: "ผม ยัง หิว",
                description: "For continuing state ('still hungry')"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "ผม ชอบ ไม่",
                correctThai: "ผม ไม่ ชอบ",
                explanationEn: "'ไม่' must come BEFORE the verb, not after it",
                explanationFr: "'ไม่' doit venir AVANT le verbe, pas après"
            ),
            CommonMistake(
                incorrectThai: "เขา ไม่ไม่ มา",
                correctThai: "เขา ยัง ไม่ มา",
                explanationEn: "Don't double 'ไม่'. Use 'ยัง' + 'ไม่' for emphasis, not 'ไม่' twice",
                explanationFr: "Ne doublez pas 'ไม่'. Utilisez 'ยัง' + 'ไม่' pour l'emphase, pas 'ไม่' deux fois"
            ),
            CommonMistake(
                incorrectThai: "ยัง ผม มา ไม่",
                correctThai: "ผม ยัง ไม่ มา",
                explanationEn: "Pronoun first, then 'ยัง', then 'ไม่', then verb",
                explanationFr: "Pronom d'abord, puis 'ยัง', puis 'ไม่', puis verbe"
            )
        ]
    ),

    // TENSES
    GrammarTopic(
        id: "tenses",
        titleEn: "Tenses",
        titleFr: "Temps",
        icon: "⏰",
        descriptionEn: "Past, present, and future",
        descriptionFr: "Passé, présent et futur",
        rules: [
            GrammarRule(
                ruleEn: "Thai verbs don't conjugate",
                ruleFr: "Les verbes thaïs ne se conjuguent pas",
                explanation: "Verbs stay the same; time is shown with separate words placed before or after the verb",
                explanationFr: "Les verbes restent les mêmes; le temps est montré avec des mots séparés placés avant ou après le verbe"
            ),
            GrammarRule(
                ruleEn: "Time markers before the verb",
                ruleFr: "Les marqueurs de temps avant le verbe",
                explanation: "Past/future time words usually come at the beginning: เมื่อวาน (yesterday), พรุ่งนี้ (tomorrow)",
                explanationFr: "Les mots de temps passé/futur viennent généralement au début: เมื่อวาน (hier), พรุ่งนี้ (demain)"
            ),
            GrammarRule(
                ruleEn: "Use particles for tense hints",
                ruleFr: "Utilisez les particules pour les indices de temps",
                explanation: "Small particles like 'แล้ว' (finished/already) and 'จะ' (will) help clarify time",
                explanationFr: "Les petites particules comme 'แล้ว' (fini/déjà) et 'จะ' (volonté) aident à clarifier le temps"
            )
        ],
        examples: [
            GrammarExample(
                thai: "เมื่อวาน ผม ไป",
                romanization: "meua-wan phom pai",
                englishTranslation: "Yesterday I went",
                frenchTranslation: "Hier je suis allé",
                structure: "Time + Subject + Verb"
            ),
            GrammarExample(
                thai: "วันนี้ เขา ทำงาน",
                romanization: "wan-nee khao tham ngan",
                englishTranslation: "Today he/she works",
                frenchTranslation: "Aujourd'hui il/elle travaille",
                structure: "Time + Subject + Verb + Object"
            ),
            GrammarExample(
                thai: "พรุ่งนี้ เธอ จะ มา",
                romanization: "phrung-nee thoe cha ma",
                englishTranslation: "Tomorrow you will come",
                frenchTranslation: "Demain tu viendras",
                structure: "Time + Subject + Particle + Verb"
            ),
            GrammarExample(
                thai: "ผม กิน ข้าว แล้ว",
                romanization: "phom kin khao laew",
                englishTranslation: "I ate rice already / I have eaten rice",
                frenchTranslation: "J'ai déjà mangé du riz",
                structure: "Subject + Verb + Object + Particle"
            ),
            GrammarExample(
                thai: "เขา จะ ไป โรงเรียน",
                romanization: "khao cha pai roong-rian",
                englishTranslation: "He will go to school",
                frenchTranslation: "Il ira à l'école",
                structure: "Subject + Particle + Verb + Location"
            )
        ],
        patterns: [
            GrammarPattern(
                patternEn: "Time + Subject + Verb",
                patternFr: "Temps + Sujet + Verbe",
                example: "เมื่อวาน ผม ไป",
                description: "Past events with time marker at beginning"
            ),
            GrammarPattern(
                patternEn: "Subject + จะ + Verb",
                patternFr: "Sujet + จะ + Verbe",
                example: "เธอ จะ มา",
                description: "Future tense using 'จะ' particle"
            ),
            GrammarPattern(
                patternEn: "Subject + Verb + แล้ว",
                patternFr: "Sujet + Verbe + แล้ว",
                example: "ผม กิน แล้ว",
                description: "Completed action using 'แล้ว' particle"
            )
        ],
        commonMistakes: [
            CommonMistake(
                incorrectThai: "ผม จะ ไป เมื่อวาน",
                correctThai: "เมื่อวาน ผม ไป",
                explanationEn: "Don't use 'จะ' (future) with 'เมื่อวาน' (past). Use 'จะ' for future only",
                explanationFr: "N'utilisez pas 'จะ' (futur) avec 'เมื่อวาน' (passé). Utilisez 'จะ' pour le futur uniquement"
            ),
            CommonMistake(
                incorrectThai: "ผม ไป แล้ว จะ",
                correctThai: "ผม จะ ไป",
                explanationEn: "Don't mix 'แล้ว' (past) and 'จะ' (future) together",
                explanationFr: "Ne mélangez pas 'แล้ว' (passé) et 'จะ' (futur) ensemble"
            ),
            CommonMistake(
                incorrectThai: "ผม ไป เมื่อวาน",
                correctThai: "เมื่อวาน ผม ไป",
                explanationEn: "Time markers usually go at the BEGINNING of the sentence",
                explanationFr: "Les marqueurs de temps vont généralement AU DÉBUT de la phrase"
            )
        ]
    )
]
