import java.util.Random;

Random rand = new Random();

String[] first = {"Cherie", "Mon lapin", "Mon quoicoubebou", "Ma choubidou"};
String[] second = {"d'amour", "de coeur", "en sucre", "tendre"};

String[] adjectives = {
  "adorable", "mignon", "créatif", "douce", "joli", "sexy",
  "essoufflé", "brûlant", "avide", "désireux", "curieux", "chéri",
  "cher", "dévoué", "impatient", "épris", "ardent", "tendre",
  "pressé", "vif", "petit", "adorable", "transi d amour", "aimant",
  "passionné", "précieux", "doux", "compatissant", "tendre",
  "insatisfait", "mélancolique"
};

String[] nouns = {
  "adoration", "affection", "ambition", "appétit", "ardeur", "charme",
  "désir", "dévotion", "enthousiasme", "enchantement", "ferveur", "fantaisie",
  "tendresse partagée", "ferveur", "attachement", "cœur", "faim",
  "infatuation", "attirance", "nostalgie", "amour", "luxure", "passion",
  "ravissement", "sympathie", "tendresse", "soif", "souhait", "élan"
};

String[] adverbs = {
  "affectueusement", "anxieusement", "ardemment", "avidement", "magnifiquement",
  "à bout de souffle", "brûlamment", "avec convoitise", "curieusement", "dévouément",
  "impatiemment", "avec ferveur", "tendrement", "avec impatience", "vivement",
  "amoureusement", "passionnément", "séductivement", "tendrement",
  "avec charme", "avec nostalgie"
};

String[] verbs = {
 "adore", "attire", "chérît", "chérît", "s accroche à", "désire",
  "tient pour cher", "espère", "a soif de", "est uni à", "aime",
  "aspire à", "aime", "brûle de désir pour", "halète pour", "languit pour",
  "prise", "soupire pour", "tente", "a soif de", "chérît",
  "veut", "souhaite", "courtise", "désire ardemment"
};

void setup() {
  
  noLoop();
  println("");

  while (true) {
    println(letter());
    delay(30000); 
  }
}


String choice(String[] words) {
  return words[rand.nextInt(words.length)];
}

String maybe(String[] words) {
  if (rand.nextBoolean()) {
    return " " + choice(words);
  }
  return "";
}

String longer() {
  return " MA"
    + maybe(adjectives)
    + " "
    + choice(nouns)
    + maybe(adverbs)
    + " "
    + choice(verbs)
    + " es"
    + maybe(adjectives)
    + " "
    + choice(nouns)
    + ".";
}

String shorter() {
  return " " + choice(adjectives) + " " + choice(nouns) + ".";
}

String body() {
  String text = "";
  boolean youAre = false;

  for (int i = 0; i < 5; i++) {
    if (rand.nextBoolean()) {
      text += longer();
      youAre = false;
    } else {
      if (youAre) {
        text = text.substring(0, text.length() - 1) + ": ma" + shorter();
        youAre = false;
      } else {
        text += " Tu es ma" + shorter();
        youAre = true;
      }
    }
  }
  return text;
}

String letter() {
  String text =
    choice(first) + " " + choice(second) + "\n\n"
    + wrapText(body(), 80) + "\n\n"
    + "                            tu " + choice(adverbs) + "\n\n"
    + "                                  M.U.C.\n";

  return text;
}

String wrapText(String text, int maxWidth) {
  String[] words = text.split(" ");
  String result = "";
  int lineLength = 0;

  for (String word : words) {
    if (lineLength + word.length() > maxWidth) {
      result += "\n";
      lineLength = 0;
    }
    result += word + " ";
    lineLength += word.length() + 1;
  }
  return result.trim();
}
