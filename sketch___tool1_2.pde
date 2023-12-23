import com.hamoid.*;
import controlP5.*;

ControlP5 cp5;
VideoExport videoExport;

PImage backgroundImage;
PFont heading, regular;

int headingColor, regularColor;
float x, y;

Textfield headingField, subtitleField; //это для интерфейса из примера, поле ввода
String userHeading = "";
String userSubtitle = "";
float padding = 40; //отступ
float w = 43; //ширина клетки — CHECK

float walkerNumSliderValue = 12.0;//задаю переменные + массивы чтобы управлять ходьбой
int walkerNumIntValue = 12;
float[] Xcoord;
float[] Ycoord;

Slider paddingSlider; //это для интерфейса из примера, чтобы я могла управлять отступами в слайдере

void setup() {
  size(1000, 600);
  surface.setLocation(0, 0);
  pixelDensity(2);
  heading = createFont("GT-America-Expanded-Medium-Trial.otf", 100);
  regular = createFont("GT-Alpina-Standard-Medium-Italic-Trial.otf", 100);

  // Загрузка изображения
  backgroundImage = loadImage("kino.jpg");
  backgroundImage.resize(width, height);
  image(backgroundImage, 0, 0);

  cp5 = new ControlP5(this);

  headingField = cp5.addTextfield("heading")
    .setPosition(20, 20)
    .setSize(200, 40)
    .setFocus(true)
    .setText(userHeading);

  textFont(heading);

  subtitleField = cp5.addTextfield("subtitle")
    .setPosition(20, 80)
    .setSize(200, 40)
    .setFocus(true)
    .setText(userSubtitle);

  textFont(regular);

  cp5.addSlider("walkerNumSlider")
    .setPosition(20, 140)
    .setSize(200, 20)
    .setRange(1, 30)
    .setValue(walkerNumSliderValue);

  paddingSlider = cp5.addSlider("padding")
    .setPosition(20, 170)
    .setSize(200, 20)
    .setRange(0, 50)
    .setValue(padding);

  initializeArrays();
  rectMode(CENTER);

  videoExport = new VideoExport(this);
  videoExport.startMovie();
}

void draw() {
  
  userHeading = headingField.getText(); //текст заголовка = тому что ввел юзер в интерфейсе
  userSubtitle = subtitleField.getText(); //текст подзаголовка = тому что ввел юзер в интерфейсе
  padding = paddingSlider.getValue(); // обновляется значениее полученне из ползунка paddinglider

  for (int j = 0; j < walkerNumIntValue; j++) {
    float x = Xcoord[j];
    float y = Ycoord[j];
    textFont(heading);
    float headingSize = random(5, 40); //рандом кегль заголовка
    textSize(headingSize);

    while (textWidth(userHeading) > width - 2 * padding) { //уменьшаем размер текста пока ширина текста не станет меньше чем область, в которую я вписываю текст
      headingSize -= 1; //уменьшаем кегль когда строка выходит за фрейм
      textSize(headingSize);
    }

    text(userHeading, x, y); //выводим текст

    // ПОДЗАГОЛОВОК
    textFont(regular);
    float subtitleSize = random(constrain(headingSize - 10, 10, 39));
    float leading = subtitleSize * 1.2; //отступ
    textSize(subtitleSize);
    textLeading(leading);

    float subtitleY = y + textAscent() + padding; // расположение текста по вертикали: y + вертикальное расстояние от базовой линии до самого верха символа +  значение отступа между верхней границей подзаголовка и нижней границей заголовка
    text(userSubtitle, x, subtitleY);

    while (textWidth(userSubtitle) > width - 2 * padding) {//уменьшаем размер текста пока ширина текста не станет меньше чем область, в которую я вписываю текст
      subtitleSize -= 1; //уменьшаем кегль когда строка выходит за фрейм
      leading = subtitleSize * 1.2; // отступ ПРИ УМЕНЬШЕНИИ
      textSize(subtitleSize);
      textLeading(leading);
    }

    noStroke();

    int imgColor = backgroundImage.get(int(x), int(y)); //вывести картинку в ЦЕЛЫХ координатах
    fill(imgColor);

    int dice = floor(random(4));
    if (dice == 0) {
      x += w;
    } else if (dice == 1) {
      x -= w;
    } else if (dice == 2) {
      y += w;
    } else {
      y -= w;
    }

    if (x < 0 || x > width || y < 0 || y > height) {
      x = random(width);
      y = random(height);
    }

    Xcoord[j] = x;
    Ycoord[j] = y;
  }
  
  videoExport.saveFrame();
}

//функция обновляет значения сразу, как их изменила в интерфейсе
void walkerNumSlider(float value) {
  walkerNumSliderValue = value; //значение = текущее положение ползунка интерфейса, которое определено пользователем
  walkerNumIntValue = int(value); // значение = ЦЕЛОЕ (число) значение value
  initializeArrays();
}

void initializeArrays() { // массивы координат для ходьбы в соответствии с выбранным пользователем количеством
  Xcoord = new float[walkerNumIntValue];
  Ycoord = new float[walkerNumIntValue];
  for (int i = 0; i < walkerNumIntValue; i++) {
    Xcoord[i] = random(width);
    Ycoord[i] = random(height);
  }
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
