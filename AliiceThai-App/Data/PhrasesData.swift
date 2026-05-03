import Foundation

struct PhraseCategory {
    let id: String
    let nameEn: String
    let nameFr: String
    let icon: String
    let phrases: [Phrase]
}

struct Phrase {
    let thai: String
    let romanization: String
    let englishTranslation: String
    let frenchTranslation: String
    let emoji: String
    let context: String
    let contextFr: String
}

let phraseCategories: [PhraseCategory] = [
    // GREETINGS (12 phrases)
    PhraseCategory(
        id: "greetings",
        nameEn: "Greetings",
        nameFr: "Salutations",
        icon: "👋",
        phrases: [
            Phrase(thai: "สวัสดี", romanization: "sawadee", englishTranslation: "Hello/Hi", frenchTranslation: "Bonjour/Salut", emoji: "👋", context: "General greeting", contextFr: "Salutation générale"),
            Phrase(thai: "สวัสดีค่ะ", romanization: "sawadee kha", englishTranslation: "Hello (female polite)", frenchTranslation: "Bonjour (femme, poli)", emoji: "👋", context: "Female speaker, polite", contextFr: "Locutrice, poli"),
            Phrase(thai: "สวัสดีครับ", romanization: "sawadee khrap", englishTranslation: "Hello (male polite)", frenchTranslation: "Bonjour (homme, poli)", emoji: "👋", context: "Male speaker, polite", contextFr: "Locuteur, poli"),
            Phrase(thai: "สบายดีไหม", romanization: "sabai dee mai", englishTranslation: "How are you?", frenchTranslation: "Comment allez-vous?", emoji: "😊", context: "Polite greeting", contextFr: "Salutation polie"),
            Phrase(thai: "สบายดี", romanization: "sabai dee", englishTranslation: "I'm fine", frenchTranslation: "Je vais bien", emoji: "😊", context: "Response to greeting", contextFr: "Réponse à la salutation"),
            Phrase(thai: "ยินดีที่ได้รู้จัก", romanization: "yin dee tee dai roo jak", englishTranslation: "Nice to meet you", frenchTranslation: "Enchanté de vous rencontrer", emoji: "🤝", context: "Meeting someone", contextFr: "Rencontre"),
            Phrase(thai: "ยินดีต้อนรับ", romanization: "yin dee thorn rap", englishTranslation: "Welcome", frenchTranslation: "Bienvenue", emoji: "🏠", context: "Welcoming", contextFr: "Accueil"),
            Phrase(thai: "หวัดดี", romanization: "wat dee", englishTranslation: "Hi (casual)", frenchTranslation: "Salut (casual)", emoji: "👋", context: "Informal greeting", contextFr: "Salutation informelle"),
            Phrase(thai: "สวัสดีตอนเช้า", romanization: "sawadee ton chao", englishTranslation: "Good morning", frenchTranslation: "Bonjour matin", emoji: "🌅", context: "Morning greeting", contextFr: "Salutation du matin"),
            Phrase(thai: "สวัสดีตอนบ่าย", romanization: "sawadee ton bai", englishTranslation: "Good afternoon", frenchTranslation: "Bon après-midi", emoji: "☀️", context: "Afternoon greeting", contextFr: "Salutation d'après-midi"),
            Phrase(thai: "สวัสดีตอนค่ำ", romanization: "sawadee ton kham", englishTranslation: "Good evening", frenchTranslation: "Bonsoir", emoji: "🌆", context: "Evening greeting", contextFr: "Salutation du soir"),
            Phrase(thai: "ราตรีสวัสดิ์", romanization: "ratri sawat", englishTranslation: "Good night", frenchTranslation: "Bonne nuit", emoji: "🌙", context: "Night greeting", contextFr: "Salutation de nuit")
        ]
    ),

    // POLITENESS (10 phrases)
    PhraseCategory(
        id: "politeness",
        nameEn: "Politeness",
        nameFr: "Politesse",
        icon: "🙏",
        phrases: [
            Phrase(thai: "ขอบคุณ", romanization: "khop khun", englishTranslation: "Thank you", frenchTranslation: "Merci", emoji: "🙏", context: "General thanks", contextFr: "Remerciements"),
            Phrase(thai: "ขอบคุณค่ะ", romanization: "khop khun kha", englishTranslation: "Thank you (female)", frenchTranslation: "Merci (femme)", emoji: "🙏", context: "Female speaker", contextFr: "Locutrice"),
            Phrase(thai: "ขอบคุณครับ", romanization: "khop khun khrap", englishTranslation: "Thank you (male)", frenchTranslation: "Merci (homme)", emoji: "🙏", context: "Male speaker", contextFr: "Locuteur"),
            Phrase(thai: "ขอบคุณมาก", romanization: "khop khun mak", englishTranslation: "Thank you very much", frenchTranslation: "Merci beaucoup", emoji: "🙏", context: "Emphatic thanks", contextFr: "Remerciements emphase"),
            Phrase(thai: "โปรด", romanization: "prode", englishTranslation: "Please", frenchTranslation: "S'il vous plaît", emoji: "👏", context: "Making request", contextFr: "Faire une demande"),
            Phrase(thai: "ขออนุญาต", romanization: "khor anuyat", englishTranslation: "Excuse me/May I", frenchTranslation: "Excusez-moi/Puis-je", emoji: "🙏", context: "Polite request", contextFr: "Demande polie"),
            Phrase(thai: "ไม่เป็นไร", romanization: "mai pen rai", englishTranslation: "Never mind/You're welcome", frenchTranslation: "De rien/Ce n'est rien", emoji: "😊", context: "Reassuring response", contextFr: "Réponse rassurante"),
            Phrase(thai: "ขอโทษ", romanization: "khor tot", englishTranslation: "I'm sorry/Excuse me", frenchTranslation: "Je suis désolé/Pardon", emoji: "😔", context: "Apology", contextFr: "Excuses"),
            Phrase(thai: "ขอโทษด้วย", romanization: "khor tot duay", englishTranslation: "Sorry", frenchTranslation: "Désolé", emoji: "😔", context: "Casual apology", contextFr: "Excuses casuelle"),
            Phrase(thai: "ไม่มีปัญหา", romanization: "mai mee pan ha", englishTranslation: "No problem", frenchTranslation: "Pas de problème", emoji: "✨", context: "Reassurance", contextFr: "Assurance")
        ]
    ),

    // YES/NO (10 phrases)
    PhraseCategory(
        id: "responses",
        nameEn: "Yes/No",
        nameFr: "Oui/Non",
        icon: "✅",
        phrases: [
            Phrase(thai: "ใช่", romanization: "chai", englishTranslation: "Yes", frenchTranslation: "Oui", emoji: "✅", context: "Affirmative", contextFr: "Affirmatif"),
            Phrase(thai: "ใช่ค่ะ", romanization: "chai kha", englishTranslation: "Yes (female)", frenchTranslation: "Oui (femme)", emoji: "✅", context: "Female, polite", contextFr: "Femme, poli"),
            Phrase(thai: "ใช่ครับ", romanization: "chai khrap", englishTranslation: "Yes (male)", frenchTranslation: "Oui (homme)", emoji: "✅", context: "Male, polite", contextFr: "Homme, poli"),
            Phrase(thai: "ไม่", romanization: "mai", englishTranslation: "No", frenchTranslation: "Non", emoji: "❌", context: "Negative", contextFr: "Négatif"),
            Phrase(thai: "ไม่ค่ะ", romanization: "mai kha", englishTranslation: "No (female)", frenchTranslation: "Non (femme)", emoji: "❌", context: "Female, polite", contextFr: "Femme, poli"),
            Phrase(thai: "ไม่ครับ", romanization: "mai khrap", englishTranslation: "No (male)", frenchTranslation: "Non (homme)", emoji: "❌", context: "Male, polite", contextFr: "Homme, poli"),
            Phrase(thai: "ได้ค่ะ", romanization: "dai kha", englishTranslation: "Okay (female)", frenchTranslation: "D'accord (femme)", emoji: "👍", context: "Agreement", contextFr: "Accord"),
            Phrase(thai: "ได้ครับ", romanization: "dai khrap", englishTranslation: "Okay (male)", frenchTranslation: "D'accord (homme)", emoji: "👍", context: "Agreement", contextFr: "Accord"),
            Phrase(thai: "เข้าใจ", romanization: "khao jai", englishTranslation: "I understand", frenchTranslation: "Je comprends", emoji: "✨", context: "Confirmation", contextFr: "Confirmation"),
            Phrase(thai: "อืม", romanization: "um", englishTranslation: "Mmm/Yeah", frenchTranslation: "Mmm/Ouais", emoji: "😊", context: "Casual agreement", contextFr: "Accord casual")
        ]
    ),

    // QUESTIONS (12 phrases)
    PhraseCategory(
        id: "questions",
        nameEn: "Questions",
        nameFr: "Questions",
        icon: "❓",
        phrases: [
            Phrase(thai: "คุณชื่ออะไร", romanization: "khun chue arai", englishTranslation: "What's your name?", frenchTranslation: "Quel est votre nom?", emoji: "🤨", context: "Asking name", contextFr: "Demander le nom"),
            Phrase(thai: "ชื่ออะไร", romanization: "chue arai", englishTranslation: "What's your name? (casual)", frenchTranslation: "Tu t'appelles comment?", emoji: "🤨", context: "Casual", contextFr: "Casual"),
            Phrase(thai: "คุณมาจากไหน", romanization: "khun ma chak nai", englishTranslation: "Where are you from?", frenchTranslation: "D'où venez-vous?", emoji: "🗺️", context: "Origin", contextFr: "Origine"),
            Phrase(thai: "ห้องน้ำอยู่ไหน", romanization: "hong nam yu nai", englishTranslation: "Where's the bathroom?", frenchTranslation: "Où sont les toilettes?", emoji: "🚻", context: "Essential", contextFr: "Essentiel"),
            Phrase(thai: "เท่าไหร่", romanization: "thao rai", englishTranslation: "How much?", frenchTranslation: "Combien coûte?", emoji: "💰", context: "Price", contextFr: "Prix"),
            Phrase(thai: "พูดภาษาอังกฤษได้ไหม", romanization: "phut pa sa angkrit dai mai", englishTranslation: "Do you speak English?", frenchTranslation: "Parlez-vous anglais?", emoji: "🗣️", context: "Language", contextFr: "Langue"),
            Phrase(thai: "หกี่โมง", romanization: "kee moeng", englishTranslation: "What time is it?", frenchTranslation: "Quelle heure est-il?", emoji: "🕐", context: "Time", contextFr: "Heure"),
            Phrase(thai: "วันนี้วันอะไร", romanization: "wan nee wan arai", englishTranslation: "What day is today?", frenchTranslation: "Quel jour sommes-nous?", emoji: "📅", context: "Day", contextFr: "Jour"),
            Phrase(thai: "ทำไม", romanization: "tham mai", englishTranslation: "Why?", frenchTranslation: "Pourquoi?", emoji: "🤔", context: "Reason", contextFr: "Raison"),
            Phrase(thai: "ใคร", romanization: "khrai", englishTranslation: "Who?", frenchTranslation: "Qui?", emoji: "👥", context: "Person", contextFr: "Personne"),
            Phrase(thai: "อะไร", romanization: "arai", englishTranslation: "What?", frenchTranslation: "Quoi?", emoji: "🤨", context: "Thing", contextFr: "Chose"),
            Phrase(thai: "เมื่อไหร่", romanization: "meua rai", englishTranslation: "When?", frenchTranslation: "Quand?", emoji: "📆", context: "Time", contextFr: "Temps")
        ]
    ),

    // COMMUNICATION (10 phrases)
    PhraseCategory(
        id: "communication",
        nameEn: "Communication",
        nameFr: "Communication",
        icon: "💬",
        phrases: [
            Phrase(thai: "ไม่เข้าใจ", romanization: "mai khao jai", englishTranslation: "I don't understand", frenchTranslation: "Je ne comprends pas", emoji: "🤔", context: "Confusion", contextFr: "Confusion"),
            Phrase(thai: "ช้าๆ หน่อย", romanization: "cha cha noi", englishTranslation: "Slowly please", frenchTranslation: "Lentement s'il vous plaît", emoji: "🐢", context: "Speed request", contextFr: "Demande de vitesse"),
            Phrase(thai: "ได้เนื้อความ", romanization: "dai nua khwam", englishTranslation: "I understand", frenchTranslation: "Je comprends", emoji: "✨", context: "Understanding", contextFr: "Compréhension"),
            Phrase(thai: "สามารถพูดอีกครั้งได้ไหม", romanization: "samarot phut eek khrang dai mai", englishTranslation: "Can you repeat?", frenchTranslation: "Pouvez-vous répéter?", emoji: "🔄", context: "Repetition", contextFr: "Répétition"),
            Phrase(thai: "โปรดแล่นช้า", romanization: "prode len cha", englishTranslation: "Please speak slower", frenchTranslation: "Parlez plus lentement", emoji: "🎧", context: "Listening", contextFr: "Écoute"),
            Phrase(thai: "พูดชัด ๆ", romanization: "phut chat", englishTranslation: "Speak clearly", frenchTranslation: "Parlez clairement", emoji: "🔊", context: "Clarity", contextFr: "Clarté"),
            Phrase(thai: "คุณเข้าใจหรือ", romanization: "khun khao jai rue", englishTranslation: "Do you understand?", frenchTranslation: "Vous comprenez?", emoji: "🤨", context: "Check understanding", contextFr: "Vérifier compréhension"),
            Phrase(thai: "ฉันเข้าใจ", romanization: "chan khao jai", englishTranslation: "I understand (casual)", frenchTranslation: "Je comprends (casual)", emoji: "✨", context: "Casual understanding", contextFr: "Compréhension casual"),
            Phrase(thai: "ขอโทษ ฉันไม่ได้ยิน", romanization: "khor tot chan mai dai yin", englishTranslation: "Sorry, I didn't hear", frenchTranslation: "Désolé, je n'ai pas entendu", emoji: "👂", context: "Hearing", contextFr: "Audition"),
            Phrase(thai: "คุณพูดอะไรคะ", romanization: "khun phut arai kha", englishTranslation: "What did you say?", frenchTranslation: "Qu'avez-vous dit?", emoji: "🤨", context: "Clarification", contextFr: "Clarification")
        ]
    ),

    // TIME & NUMBERS (10 phrases)
    PhraseCategory(
        id: "time",
        nameEn: "Time & Numbers",
        nameFr: "Temps & Nombres",
        icon: "🕐",
        phrases: [
            Phrase(thai: "โมง", romanization: "moeng", englishTranslation: "o'clock", frenchTranslation: "heure", emoji: "🕐", context: "Time", contextFr: "Heure"),
            Phrase(thai: "นาที", romanization: "nathee", englishTranslation: "minute", frenchTranslation: "minute", emoji: "⏱️", context: "Time unit", contextFr: "Unité de temps"),
            Phrase(thai: "วินาที", romanization: "winathee", englishTranslation: "second", frenchTranslation: "seconde", emoji: "⏱️", context: "Time unit", contextFr: "Unité de temps"),
            Phrase(thai: "เช้า", romanization: "chao", englishTranslation: "morning", frenchTranslation: "matin", emoji: "🌅", context: "Time of day", contextFr: "Moment de la journée"),
            Phrase(thai: "บ่าย", romanization: "bai", englishTranslation: "afternoon", frenchTranslation: "après-midi", emoji: "☀️", context: "Time of day", contextFr: "Moment de la journée"),
            Phrase(thai: "ค่ำ", romanization: "kham", englishTranslation: "evening", frenchTranslation: "soir", emoji: "🌆", context: "Time of day", contextFr: "Moment de la journée"),
            Phrase(thai: "คืน", romanization: "khuen", englishTranslation: "night", frenchTranslation: "nuit", emoji: "🌙", context: "Time of day", contextFr: "Moment de la journée"),
            Phrase(thai: "วันนี้", romanization: "wan nee", englishTranslation: "today", frenchTranslation: "aujourd'hui", emoji: "📅", context: "Day", contextFr: "Jour"),
            Phrase(thai: "เมื่อวาน", romanization: "meua wan", englishTranslation: "yesterday", frenchTranslation: "hier", emoji: "📆", context: "Past", contextFr: "Passé"),
            Phrase(thai: "พรุ่งนี้", romanization: "phrung nee", englishTranslation: "tomorrow", frenchTranslation: "demain", emoji: "📆", context: "Future", contextFr: "Futur")
        ]
    ),

    // DIRECTIONS & PLACES (10 phrases)
    PhraseCategory(
        id: "directions",
        nameEn: "Directions",
        nameFr: "Directions",
        icon: "🗺️",
        phrases: [
            Phrase(thai: "ซ้าย", romanization: "sai", englishTranslation: "left", frenchTranslation: "gauche", emoji: "⬅️", context: "Direction", contextFr: "Direction"),
            Phrase(thai: "ขวา", romanization: "khwa", englishTranslation: "right", frenchTranslation: "droite", emoji: "➡️", context: "Direction", contextFr: "Direction"),
            Phrase(thai: "ตรง", romanization: "trong", englishTranslation: "straight", frenchTranslation: "droit", emoji: "⬆️", context: "Direction", contextFr: "Direction"),
            Phrase(thai: "ที่นี่", romanization: "tee nee", englishTranslation: "here", frenchTranslation: "ici", emoji: "📍", context: "Location", contextFr: "Lieu"),
            Phrase(thai: "ที่นั่น", romanization: "tee nan", englishTranslation: "there", frenchTranslation: "là-bas", emoji: "📍", context: "Location", contextFr: "Lieu"),
            Phrase(thai: "ใกล้", romanization: "glai", englishTranslation: "near", frenchTranslation: "près", emoji: "📍", context: "Distance", contextFr: "Distance"),
            Phrase(thai: "ไกล", romanization: "glai", englishTranslation: "far", frenchTranslation: "loin", emoji: "📍", context: "Distance", contextFr: "Distance"),
            Phrase(thai: "โรงแรม", romanization: "rong raem", englishTranslation: "hotel", frenchTranslation: "hôtel", emoji: "🏨", context: "Place", contextFr: "Lieu"),
            Phrase(thai: "ร้านอาหาร", romanization: "ran aharn", englishTranslation: "restaurant", frenchTranslation: "restaurant", emoji: "🍽️", context: "Place", contextFr: "Lieu"),
            Phrase(thai: "ห้องพยาบาล", romanization: "hong phayaban", englishTranslation: "hospital", frenchTranslation: "hôpital", emoji: "🏥", context: "Place", contextFr: "Lieu")
        ]
    ),

    // FOOD & DINING (10 phrases)
    PhraseCategory(
        id: "food",
        nameEn: "Food & Dining",
        nameFr: "Nourriture & Repas",
        icon: "🍜",
        phrases: [
            Phrase(thai: "อร่อย", romanization: "aroy", englishTranslation: "Delicious", frenchTranslation: "Délicieux", emoji: "😋", context: "Compliment", contextFr: "Compliment"),
            Phrase(thai: "ขอน้ำ", romanization: "khor nam", englishTranslation: "Water please", frenchTranslation: "De l'eau s'il vous plaît", emoji: "💧", context: "Drink", contextFr: "Boisson"),
            Phrase(thai: "ขอเมนู", romanization: "khor menu", englishTranslation: "Menu please", frenchTranslation: "Le menu s'il vous plaît", emoji: "📋", context: "Order", contextFr: "Commande"),
            Phrase(thai: "เผ็ดไหม", romanization: "pet hai mai", englishTranslation: "Is it spicy?", frenchTranslation: "C'est épicé?", emoji: "🌶️", context: "Question", contextFr: "Question"),
            Phrase(thai: "ไม่เผ็ด", romanization: "mai pet", englishTranslation: "Not spicy", frenchTranslation: "Pas épicé", emoji: "😌", context: "Preference", contextFr: "Préférence"),
            Phrase(thai: "เผ็ด", romanization: "pet", englishTranslation: "Spicy", frenchTranslation: "Épicé", emoji: "🌶️", context: "Preference", contextFr: "Préférence"),
            Phrase(thai: "อาหารเย็น", romanization: "aharn yen", englishTranslation: "dinner", frenchTranslation: "dîner", emoji: "🍽️", context: "Meal", contextFr: "Repas"),
            Phrase(thai: "อาหารเช้า", romanization: "aharn chao", englishTranslation: "breakfast", frenchTranslation: "petit-déjeuner", emoji: "🥣", context: "Meal", contextFr: "Repas"),
            Phrase(thai: "กาแฟ", romanization: "ga-fae", englishTranslation: "coffee", frenchTranslation: "café", emoji: "☕", context: "Drink", contextFr: "Boisson"),
            Phrase(thai: "ชา", romanization: "cha", englishTranslation: "tea", frenchTranslation: "thé", emoji: "🫖", context: "Drink", contextFr: "Boisson")
        ]
    ),

    // SHOPPING & MONEY (10 phrases)
    PhraseCategory(
        id: "shopping",
        nameEn: "Shopping",
        nameFr: "Magasinage",
        icon: "💳",
        phrases: [
            Phrase(thai: "เท่าไหร่", romanization: "thao rai", englishTranslation: "How much?", frenchTranslation: "Combien coûte?", emoji: "💰", context: "Price", contextFr: "Prix"),
            Phrase(thai: "แพง", romanization: "paeng", englishTranslation: "expensive", frenchTranslation: "cher", emoji: "💸", context: "Cost", contextFr: "Coût"),
            Phrase(thai: "ถูก", romanization: "thuk", englishTranslation: "cheap", frenchTranslation: "bon marché", emoji: "✨", context: "Cost", contextFr: "Coût"),
            Phrase(thai: "ลด", romanization: "lot", englishTranslation: "discount", frenchTranslation: "remise", emoji: "🏷️", context: "Offer", contextFr: "Offre"),
            Phrase(thai: "บาท", romanization: "baht", englishTranslation: "baht (Thai currency)", frenchTranslation: "baht (devise thaïe)", emoji: "💵", context: "Currency", contextFr: "Devise"),
            Phrase(thai: "เงิน", romanization: "ngen", englishTranslation: "money", frenchTranslation: "argent", emoji: "💰", context: "Payment", contextFr: "Paiement"),
            Phrase(thai: "บัตรเครดิต", romanization: "bat khrdit", englishTranslation: "credit card", frenchTranslation: "carte de crédit", emoji: "💳", context: "Payment", contextFr: "Paiement"),
            Phrase(thai: "เก้าหก", romanization: "kao hok", englishTranslation: "96 baht", frenchTranslation: "96 bahts", emoji: "💵", context: "Amount", contextFr: "Montant"),
            Phrase(thai: "ขอใบเสร็จ", romanization: "khor bai sert", englishTranslation: "Receipt please", frenchTranslation: "Reçu s'il vous plaît", emoji: "🧾", context: "Document", contextFr: "Document"),
            Phrase(thai: "ฟรี", romanization: "free", englishTranslation: "free", frenchTranslation: "gratuit", emoji: "🎁", context: "Cost", contextFr: "Coût")
        ]
    ),

    // FEELINGS & EMOTIONS (10 phrases)
    PhraseCategory(
        id: "emotions",
        nameEn: "Feelings",
        nameFr: "Sentiments",
        icon: "😊",
        phrases: [
            Phrase(thai: "ผมสุข", romanization: "phom suk", englishTranslation: "I'm happy", frenchTranslation: "Je suis heureux", emoji: "😊", context: "Emotion", contextFr: "Émotion"),
            Phrase(thai: "ผมเศร้า", romanization: "phom sao", englishTranslation: "I'm sad", frenchTranslation: "Je suis triste", emoji: "😢", context: "Emotion", contextFr: "Émotion"),
            Phrase(thai: "ผมหิว", romanization: "phom hiw", englishTranslation: "I'm hungry", frenchTranslation: "J'ai faim", emoji: "🤤", context: "Need", contextFr: "Besoin"),
            Phrase(thai: "ผมเหนื่อย", romanization: "phom nueai", englishTranslation: "I'm tired", frenchTranslation: "Je suis fatigué", emoji: "😴", context: "State", contextFr: "État"),
            Phrase(thai: "ผมกลัว", romanization: "phom gluea", englishTranslation: "I'm scared", frenchTranslation: "J'ai peur", emoji: "😨", context: "Emotion", contextFr: "Émotion"),
            Phrase(thai: "ผมโกรธ", romanization: "phom grot", englishTranslation: "I'm angry", frenchTranslation: "Je suis en colère", emoji: "😠", context: "Emotion", contextFr: "Émotion"),
            Phrase(thai: "ผมรักกัน", romanization: "phom rak gan", englishTranslation: "I love you", frenchTranslation: "Je t'aime", emoji: "❤️", context: "Affection", contextFr: "Affection"),
            Phrase(thai: "สวย", romanization: "suay", englishTranslation: "beautiful", frenchTranslation: "beau", emoji: "✨", context: "Compliment", contextFr: "Compliment"),
            Phrase(thai: "น่ารัก", romanization: "naa rak", englishTranslation: "cute", frenchTranslation: "mignon", emoji: "🥰", context: "Compliment", contextFr: "Compliment"),
            Phrase(thai: "เจ็บ", romanization: "jep", englishTranslation: "It hurts", frenchTranslation: "Ça fait mal", emoji: "😷", context: "Pain", contextFr: "Douleur")
        ]
    ),

    // TRAVEL & HOTEL (10 phrases)
    PhraseCategory(
        id: "travel",
        nameEn: "Travel & Hotel",
        nameFr: "Voyage & Hôtel",
        icon: "✈️",
        phrases: [
            Phrase(thai: "สนามบิน", romanization: "sanam bin", englishTranslation: "airport", frenchTranslation: "aéroport", emoji: "✈️", context: "Travel", contextFr: "Voyage"),
            Phrase(thai: "ตั๋วเครื่องบิน", romanization: "tuea khruang bin", englishTranslation: "plane ticket", frenchTranslation: "billet d'avion", emoji: "🎫", context: "Document", contextFr: "Document"),
            Phrase(thai: "หนังสือเดินทาง", romanization: "nangsu doen thang", englishTranslation: "passport", frenchTranslation: "passeport", emoji: "📕", context: "Document", contextFr: "Document"),
            Phrase(thai: "ห้องพัก", romanization: "hong phak", englishTranslation: "room", frenchTranslation: "chambre", emoji: "🛏️", context: "Accommodation", contextFr: "Logement"),
            Phrase(thai: "เช่นห้องได้ไหม", romanization: "chen hong dai mai", englishTranslation: "Can I rent a room?", frenchTranslation: "Puis-je louer une chambre?", emoji: "🛏️", context: "Request", contextFr: "Demande"),
            Phrase(thai: "ราคาห้องเท่าไหร่", romanization: "rai ka hong thao rai", englishTranslation: "How much is the room?", frenchTranslation: "Combien coûte la chambre?", emoji: "💰", context: "Price", contextFr: "Prix"),
            Phrase(thai: "เช้านี้", romanization: "chao nee", englishTranslation: "this morning", frenchTranslation: "ce matin", emoji: "🌅", context: "Time", contextFr: "Heure"),
            Phrase(thai: "ยืนยัน", romanization: "yuen yen", englishTranslation: "confirm", frenchTranslation: "confirmer", emoji: "✅", context: "Action", contextFr: "Action"),
            Phrase(thai: "โรงแรมอยู่ไหน", romanization: "rong raem yu nai", englishTranslation: "Where's the hotel?", frenchTranslation: "Où est l'hôtel?", emoji: "🏨", context: "Location", contextFr: "Lieu"),
            Phrase(thai: "ต้อง", romanization: "tong", englishTranslation: "must/have to", frenchTranslation: "devoir/falloir", emoji: "⚠️", context: "Obligation", contextFr: "Obligation")
        ]
    ),

    // EMERGENCY & HELP (10 phrases)
    PhraseCategory(
        id: "emergency",
        nameEn: "Emergency",
        nameFr: "Urgence",
        icon: "🆘",
        phrases: [
            Phrase(thai: "ช่วย", romanization: "chuay", englishTranslation: "Help!", frenchTranslation: "Au secours!", emoji: "🆘", context: "Emergency", contextFr: "Urgence"),
            Phrase(thai: "เจ็บ", romanization: "jep", englishTranslation: "It hurts/I'm sick", frenchTranslation: "Ça fait mal/Je suis malade", emoji: "😷", context: "Health", contextFr: "Santé"),
            Phrase(thai: "โรงพยาบาล", romanization: "rong phayaban", englishTranslation: "Hospital", frenchTranslation: "Hôpital", emoji: "🏥", context: "Location", contextFr: "Lieu"),
            Phrase(thai: "เรียกแพทย์", romanization: "riak phaet", englishTranslation: "Call a doctor", frenchTranslation: "Appelez un médecin", emoji: "👨‍⚕️", context: "Medical", contextFr: "Médical"),
            Phrase(thai: "ตำรวจ", romanization: "tamruat", englishTranslation: "Police", frenchTranslation: "Police", emoji: "👮", context: "Service", contextFr: "Service"),
            Phrase(thai: "ไฟไหม้", romanization: "fai mai", englishTranslation: "Fire!", frenchTranslation: "Au feu!", emoji: "🔥", context: "Emergency", contextFr: "Urgence"),
            Phrase(thai: "มีอุบัติเหตุ", romanization: "mee ubat het", englishTranslation: "There's an accident", frenchTranslation: "Il y a un accident", emoji: "🚗", context: "Emergency", contextFr: "Urgence"),
            Phrase(thai: "เสียน้ำตา", romanization: "sia nam ta", englishTranslation: "I'm crying", frenchTranslation: "Je pleure", emoji: "😭", context: "State", contextFr: "État"),
            Phrase(thai: "หลอก", romanization: "lok", englishTranslation: "deceive/cheat", frenchTranslation: "tricher/tromper", emoji: "🤥", context: "Problem", contextFr: "Problème"),
            Phrase(thai: "คืน", romanization: "khuen", englishTranslation: "return", frenchTranslation: "rendre", emoji: "🔄", context: "Action", contextFr: "Action")
        ]
    ),

    // COMMON VERBS (14 phrases)
    PhraseCategory(
        id: "verbs",
        nameEn: "Common Verbs",
        nameFr: "Verbes Courants",
        icon: "▶️",
        phrases: [
            Phrase(thai: "ไป", romanization: "pai", englishTranslation: "go", frenchTranslation: "aller", emoji: "🚶", context: "Movement", contextFr: "Mouvement"),
            Phrase(thai: "มา", romanization: "ma", englishTranslation: "come", frenchTranslation: "venir", emoji: "🚶", context: "Movement", contextFr: "Mouvement"),
            Phrase(thai: "กิน", romanization: "gin", englishTranslation: "eat", frenchTranslation: "manger", emoji: "🍴", context: "Food", contextFr: "Nourriture"),
            Phrase(thai: "ดื่ม", romanization: "deum", englishTranslation: "drink", frenchTranslation: "boire", emoji: "🥤", context: "Food", contextFr: "Nourriture"),
            Phrase(thai: "นอน", romanization: "non", englishTranslation: "sleep", frenchTranslation: "dormir", emoji: "😴", context: "Daily", contextFr: "Quotidien"),
            Phrase(thai: "ตื่น", romanization: "tuen", englishTranslation: "wake up", frenchTranslation: "se réveiller", emoji: "⏰", context: "Daily", contextFr: "Quotidien"),
            Phrase(thai: "ทำงาน", romanization: "tham ngan", englishTranslation: "work", frenchTranslation: "travailler", emoji: "💼", context: "Work", contextFr: "Travail"),
            Phrase(thai: "เรียน", romanization: "rian", englishTranslation: "study", frenchTranslation: "étudier", emoji: "📚", context: "Education", contextFr: "Éducation"),
            Phrase(thai: "เล่น", romanization: "len", englishTranslation: "play", frenchTranslation: "jouer", emoji: "🎮", context: "Activity", contextFr: "Activité"),
            Phrase(thai: "อ่าน", romanization: "an", englishTranslation: "read", frenchTranslation: "lire", emoji: "📖", context: "Activity", contextFr: "Activité"),
            Phrase(thai: "เขียน", romanization: "khian", englishTranslation: "write", frenchTranslation: "écrire", emoji: "✏️", context: "Activity", contextFr: "Activité"),
            Phrase(thai: "คิด", romanization: "khit", englishTranslation: "think", frenchTranslation: "penser", emoji: "🤔", context: "Mental", contextFr: "Mental"),
            Phrase(thai: "เห็น", romanization: "hen", englishTranslation: "see", frenchTranslation: "voir", emoji: "👀", context: "Sense", contextFr: "Sensation"),
            Phrase(thai: "ได้ยิน", romanization: "dai yin", englishTranslation: "hear", frenchTranslation: "entendre", emoji: "👂", context: "Sense", contextFr: "Sensation")
        ]
    ),

    // BODY PARTS & HEALTH (13 phrases)
    PhraseCategory(
        id: "body_health",
        nameEn: "Body & Health",
        nameFr: "Corps & Santé",
        icon: "💪",
        phrases: [
            Phrase(thai: "หัว", romanization: "hua", englishTranslation: "head", frenchTranslation: "tête", emoji: "🗣️", context: "Body", contextFr: "Corps"),
            Phrase(thai: "หน้า", romanization: "na", englishTranslation: "face", frenchTranslation: "visage", emoji: "😊", context: "Body", contextFr: "Corps"),
            Phrase(thai: "ตา", romanization: "ta", englishTranslation: "eye", frenchTranslation: "œil", emoji: "👁️", context: "Body", contextFr: "Corps"),
            Phrase(thai: "หู", romanization: "hu", englishTranslation: "ear", frenchTranslation: "oreille", emoji: "👂", context: "Body", contextFr: "Corps"),
            Phrase(thai: "จมูก", romanization: "chamook", englishTranslation: "nose", frenchTranslation: "nez", emoji: "👃", context: "Body", contextFr: "Corps"),
            Phrase(thai: "ปาก", romanization: "pak", englishTranslation: "mouth", frenchTranslation: "bouche", emoji: "👄", context: "Body", contextFr: "Corps"),
            Phrase(thai: "มือ", romanization: "mu", englishTranslation: "hand", frenchTranslation: "main", emoji: "✋", context: "Body", contextFr: "Corps"),
            Phrase(thai: "ขา", romanization: "kha", englishTranslation: "leg", frenchTranslation: "jambe", emoji: "🦵", context: "Body", contextFr: "Corps"),
            Phrase(thai: "เท้า", romanization: "thao", englishTranslation: "foot", frenchTranslation: "pied", emoji: "🦶", context: "Body", contextFr: "Corps"),
            Phrase(thai: "หัวใจ", romanization: "hua chai", englishTranslation: "heart", frenchTranslation: "cœur", emoji: "❤️", context: "Body", contextFr: "Corps"),
            Phrase(thai: "ท้อง", romanization: "thong", englishTranslation: "stomach", frenchTranslation: "ventre", emoji: "🤰", context: "Body", contextFr: "Corps"),
            Phrase(thai: "สุขภาพ", romanization: "sukh-a-phap", englishTranslation: "health", frenchTranslation: "santé", emoji: "⚕️", context: "Health", contextFr: "Santé"),
            Phrase(thai: "ป่วย", romanization: "puay", englishTranslation: "sick/ill", frenchTranslation: "malade", emoji: "🤒", context: "Health", contextFr: "Santé")
        ]
    ),

    // CLOTHING & ACCESSORIES (12 phrases)
    PhraseCategory(
        id: "clothing",
        nameEn: "Clothing",
        nameFr: "Vêtements",
        icon: "👕",
        phrases: [
            Phrase(thai: "เสื้อ", romanization: "sua", englishTranslation: "shirt", frenchTranslation: "chemise", emoji: "👕", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "กางเกง", romanization: "gang keang", englishTranslation: "pants", frenchTranslation: "pantalon", emoji: "👖", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "ชุดกระโปรง", romanization: "chut gra-prong", englishTranslation: "dress", frenchTranslation: "robe", emoji: "👗", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "รองเท้า", romanization: "rong thao", englishTranslation: "shoes", frenchTranslation: "chaussures", emoji: "👟", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "หมวก", romanization: "muan", englishTranslation: "hat", frenchTranslation: "chapeau", emoji: "🎩", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "แจ็คเก็ต", romanization: "jacket", englishTranslation: "jacket", frenchTranslation: "veste", emoji: "🧥", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "ถุงเท้า", romanization: "thung thao", englishTranslation: "socks", frenchTranslation: "chaussettes", emoji: "🧦", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "ผ้าพันคอ", romanization: "pha phan khor", englishTranslation: "scarf", frenchTranslation: "écharpe", emoji: "🧣", context: "Clothing", contextFr: "Vêtements"),
            Phrase(thai: "นาฬิกา", romanization: "na-li-ga", englishTranslation: "watch", frenchTranslation: "montre", emoji: "⌚", context: "Accessory", contextFr: "Accessoire"),
            Phrase(thai: "แว่นตา", romanization: "waen ta", englishTranslation: "glasses", frenchTranslation: "lunettes", emoji: "👓", context: "Accessory", contextFr: "Accessoire"),
            Phrase(thai: "กระเป๋า", romanization: "gra-bao", englishTranslation: "bag", frenchTranslation: "sac", emoji: "👜", context: "Accessory", contextFr: "Accessoire"),
            Phrase(thai: "สร้อย", romanization: "sroy", englishTranslation: "necklace", frenchTranslation: "collier", emoji: "💍", context: "Accessory", contextFr: "Accessoire")
        ]
    ),

    // COLORS (12 phrases)
    PhraseCategory(
        id: "colors",
        nameEn: "Colors",
        nameFr: "Couleurs",
        icon: "🎨",
        phrases: [
            Phrase(thai: "แดง", romanization: "daeng", englishTranslation: "red", frenchTranslation: "rouge", emoji: "🔴", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "น้ำเงิน", romanization: "nam ngen", englishTranslation: "blue", frenchTranslation: "bleu", emoji: "🔵", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "เขียว", romanization: "khiao", englishTranslation: "green", frenchTranslation: "vert", emoji: "🟢", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "เหลือง", romanization: "lueang", englishTranslation: "yellow", frenchTranslation: "jaune", emoji: "🟡", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "ส้ม", romanization: "som", englishTranslation: "orange", frenchTranslation: "orange", emoji: "🟠", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "ม่วง", romanization: "muang", englishTranslation: "purple", frenchTranslation: "violet", emoji: "🟣", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "ดำ", romanization: "dam", englishTranslation: "black", frenchTranslation: "noir", emoji: "⚫", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "ขาว", romanization: "khao", englishTranslation: "white", frenchTranslation: "blanc", emoji: "⚪", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "เทา", romanization: "thao", englishTranslation: "gray", frenchTranslation: "gris", emoji: "⚪", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "ชมพู", romanization: "chom-phoo", englishTranslation: "pink", frenchTranslation: "rose", emoji: "🩷", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "น้ำตาล", romanization: "nam tarn", englishTranslation: "brown", frenchTranslation: "marron", emoji: "🟤", context: "Color", contextFr: "Couleur"),
            Phrase(thai: "สี", romanization: "see", englishTranslation: "color", frenchTranslation: "couleur", emoji: "🎨", context: "Concept", contextFr: "Concept")
        ]
    ),

    // DAILY ACTIVITIES & OBJECTS (15 phrases)
    PhraseCategory(
        id: "daily_objects",
        nameEn: "Daily Life",
        nameFr: "Vie Quotidienne",
        icon: "🏠",
        phrases: [
            Phrase(thai: "บ้าน", romanization: "ban", englishTranslation: "house", frenchTranslation: "maison", emoji: "🏠", context: "Place", contextFr: "Lieu"),
            Phrase(thai: "ประตู", romanization: "pra-too", englishTranslation: "door", frenchTranslation: "porte", emoji: "🚪", context: "House", contextFr: "Maison"),
            Phrase(thai: "หน้าต่าง", romanization: "na tang", englishTranslation: "window", frenchTranslation: "fenêtre", emoji: "🪟", context: "House", contextFr: "Maison"),
            Phrase(thai: "โต๊ะ", romanization: "to", englishTranslation: "table", frenchTranslation: "table", emoji: "🪑", context: "Furniture", contextFr: "Mobilier"),
            Phrase(thai: "เก้าอี้", romanization: "gao ee", englishTranslation: "chair", frenchTranslation: "chaise", emoji: "🪑", context: "Furniture", contextFr: "Mobilier"),
            Phrase(thai: "เตียง", romanization: "tiang", englishTranslation: "bed", frenchTranslation: "lit", emoji: "🛏️", context: "Furniture", contextFr: "Mobilier"),
            Phrase(thai: "อาหาร", romanization: "aharn", englishTranslation: "food", frenchTranslation: "nourriture", emoji: "🍚", context: "Food", contextFr: "Nourriture"),
            Phrase(thai: "น้ำ", romanization: "nam", englishTranslation: "water", frenchTranslation: "eau", emoji: "💧", context: "Drink", contextFr: "Boisson"),
            Phrase(thai: "ไฟ", romanization: "fai", englishTranslation: "fire/light", frenchTranslation: "feu/lumière", emoji: "💡", context: "Utility", contextFr: "Utilité"),
            Phrase(thai: "ดิน", romanization: "din", englishTranslation: "earth/ground", frenchTranslation: "terre", emoji: "🌍", context: "Nature", contextFr: "Nature"),
            Phrase(thai: "ท้องฟ้า", romanization: "thong fa", englishTranslation: "sky", frenchTranslation: "ciel", emoji: "🌤️", context: "Nature", contextFr: "Nature"),
            Phrase(thai: "ดวงจันทร์", romanization: "duang jan", englishTranslation: "moon", frenchTranslation: "lune", emoji: "🌙", context: "Nature", contextFr: "Nature"),
            Phrase(thai: "ดวงอาทิตย์", romanization: "duang a-thit", englishTranslation: "sun", frenchTranslation: "soleil", emoji: "☀️", context: "Nature", contextFr: "Nature"),
            Phrase(thai: "พืช", romanization: "pheut", englishTranslation: "plant", frenchTranslation: "plante", emoji: "🌿", context: "Nature", contextFr: "Nature"),
            Phrase(thai: "สัตว์", romanization: "sat", englishTranslation: "animal", frenchTranslation: "animal", emoji: "🐕", context: "Nature", contextFr: "Nature")
        ]
    )
]
