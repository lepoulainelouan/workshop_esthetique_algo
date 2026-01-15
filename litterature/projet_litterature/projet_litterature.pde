import java.util.HashMap;

String input = "";
boolean finished = false;

HashMap<Character, String[]> phrases = new HashMap<Character, String[]>();
PhraseBuilder builder;

String[] poemLines;
int[] lineAlpha;

int startTime;
int lineDelay = 1000; 

void setup() {
  size(900, 600);
  textAlign(LEFT, TOP);
  textSize(26);

  builder = new PhraseBuilder("c’est parce que");

  phrases.put('A', new String[]{
    "je t'aime d'AMOUR",
    "tu es mon ÂME",
    "tu es ADORABLE"
  });

  phrases.put('B', new String[]{
    "j’ai vraiment BESOIN de toi",
    "tu es mon BONHEUR",
    "tu es BEAU"
  });

  phrases.put('C', new String[]{
    "tu es mon CŒUR",
    "je te CHÉRIS",
    "tu me COMBLES"
  });

  phrases.put('D', new String[]{
    "je te DÉSIRE",
    "tu es DIVIN",
    "tu me DONNES le sourire"
  });

  phrases.put('E', new String[]{
    "j’ai vraiment ENVIE de toi",
    "tu es ÉTERNEL",
    "tu m’ÉMERVEILLES"
  });

  phrases.put('F', new String[]{
    "tu es FABULEUX",
    "tu es FANTASTIQUE",
    "tu me fait FRISSONER"
  });

  phrases.put('G', new String[]{
    "tu es GENIAL",
    "tu es le GOOOOAAAT des echecs",
    "j'ai trop envie de te GALOCHE"
  });

  phrases.put('H', new String[]{
    "tu es HYPER mega trop coool",
    "tu es plus mignon qu'un HAMSTER",
    "tu es mon HERO"
  });

  phrases.put('I', new String[]{
    "tu es mon INSPIRATION",
    "je t’IMAGINE partout",
    "tu es INCROYABLE"
  });

  phrases.put('J', new String[]{
    "t'es trop JOLI",
    "tu me rends JOYEUX",
    "tu es plus précieux qu'un JOYAUX"
  });

  phrases.put('K', new String[]{
    "tu me fais sauter au plafond comme un KANGOUROU",
    "tu es un veritable KING",
    "j'ai envie de descendre tous les fleuves en KAYAK avec toi"
  });

  phrases.put('L', new String[]{
    "je ne peux me LASSER de toi",
    "tu transformes mon coeur en véritable LOCOMOTIVE",
    "tu es plus mignon qu'un bébé LOUTRE"
  });

  phrases.put('M', new String[]{
    "tu me rends completement MABOUL",
    "avec toi tous les moments sont MAGIQUES",
    "t'es trop MIGNOOON",
    "avec toi tous les moments sont MERVEILLEUX"
  });

  phrases.put('N', new String[]{
    "je NE pense qu’à toi",
    "tu es NÉCESSAIRE",
    "tu es mon NORD"
  });

  phrases.put('O', new String[]{
    "tu es mon OXYGÈNE",
    "tu es mon OR",
    "tu es mon OCÉAN"
  });

  phrases.put('P', new String[]{
    "tu me fais PAPILLONNER le cœur",
    "tu es mon PLUS beau POÈME",
    "je suis fou de ta PRÉSENCE"
  });

  phrases.put('Q', new String[]{
    "je te veux QUOI qu’il arrive",
    "tu es la QUESTION à laquelle je réponds toujours oui",
    "ton sourire me fait QUITTER la raison"
  });

  phrases.put('R', new String[]{
    "tu fais battre mon cœur super RAPIDEMENT",
    "tu me fais REVER",
    "tu rends ma vie RADIEUSE"
  });

  phrases.put('S', new String[]{
    "tu es mon SOLEIL",
    "tu rends tout plus SIMPLE",
    "je SOURIS rien qu’en pensant à toi"
  });

  phrases.put('T', new String[]{
    "je T’AIME",
    "tu es TOUT pour moi",
    "je TE veux"
  });

  phrases.put('U', new String[]{
    "je te trouve absolument UNIQUE",
    "tu illumines mon UNIVERS",
    "avec toi je suis UTILEMENT heureux"
  });

  phrases.put('V', new String[]{
    "tu fais VIBRER tout mon cœur",
    "je te veux aujourd’hui et pour la VIE",
    "tu es mon plus beau VOYAGE",
    "tu es VRAIMENT VRAIMENT incroyable"
  });

  phrases.put('W', new String[]{
    "tu me fais dire WOW",
    "you make me feel WONDER"
  });

  phrases.put('X', new String[]{
    "j'ai envie de faire du XYLOPHONE",
    "j'ai envie de t'envoyer XOXO"
  });

  phrases.put('Y', new String[]{
    "tu me fais dire YOUPI",
    "tu me fais sentire YOUPLA BOOM"
  });

  phrases.put('Z', new String[]{
    "avec toi ZERO hesitation"
  });
}

void draw() {
  background(#F7F7F7);

  if (!finished) {
    fill(#393E46);
    text("Entre un prénom puis appuie sur ENTRÉE :", 50, 50);
    text(input, 50, 100);
  } else {
    drawPoemAnimated(50, 50);
  }
}

void keyPressed() {
  if (!finished) {
    if (key == ENTER || key == RETURN) {
      if (input.length() > 0) {
        input = input.toUpperCase();
        buildPoem(input);
        startTime = millis();
        finished = true;
      }
    } else if (key == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length() - 1);
      }
    } else if (key >= 'a' && key <= 'z' || key >= 'A' && key <= 'Z') {
      input += key;
    }
  }
}

void buildPoem(String name) {
  poemLines = new String[name.length()];
  lineAlpha = new int[name.length()];

  for (int i = 0; i < name.length(); i++) {
    char c = name.charAt(i);
    poemLines[i] = c + " — " + generateLine(c);
    lineAlpha[i] = 0;
  }
}

void drawPoemAnimated(int x, int y) {
  int elapsed = millis() - startTime;

  for (int i = 0; i < poemLines.length; i++) {
    if (elapsed > i * lineDelay) {
      lineAlpha[i] = min(lineAlpha[i] + 8, 255);
      fill(#393E46, lineAlpha[i]);
      text(poemLines[i], x, y + i * 40);
    }
  }
}

String generateLine(char c) {
  String[] options = phrases.get(c);
  return builder.build(c, options[int(random(options.length))]);
}
class PhraseBuilder {
  String intro;

  PhraseBuilder(String intro) {
    this.intro = intro;
  }

  String build(char letter, String core) {
    return letter + " " + intro + " " + core;
  }
}
