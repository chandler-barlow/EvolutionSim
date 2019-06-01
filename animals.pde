import java.util.LinkedList;
LinkedList<animal> animalList = new LinkedList<animal>();
LinkedList<food> foodList = new LinkedList<food>();
boolean foodAvailable = false;
int amountOfFood = 0;
float maxSize = 80;
float minSize = 20;
int populationSize = 5;
int foodSpawnAmount = 8;
int lifeSpan = 90;


class animal {
  float colour = 255;
  float size;
  float speed;
  float x;
  float y;
  boolean alive;
  int timeAlive;
  int framesWithoutFood;
  float[] target = {0, 0};
  
  animal(){
    this(minSize, maxSize);
  }
  
  animal(float minSize, float maxSize){
    this(minSize, maxSize, random(1,700), random(1,700)); 
  }
  
  animal(float minSize, float maxSize, float x, float y){
    this.size = random(minSize, maxSize);
    this.speed = 2000 / (size * 6);
    this.x = x;
    this.y = y;
    this.alive = true;
    this.framesWithoutFood = 0;
    this.timeAlive = 1;
  }
  
  void move(){
    if(alive){
      findClosestFood();
      if(target[0] > x){
       x+= speed; 
      }
      if(target[0] < x){
       x-= speed; 
      }
      if(target[1] > y){
       y+= speed; 
      }
      if(target[1] < y){
       y-= speed; 
      }
      checkCollisions();
      if(framesWithoutFood > lifeSpan){
       alive = false; 
      }
      if( timeAlive > 100){
       animalList.add(new animal(size - 2, size + 2)); 
       timeAlive = 0;
      }
      display();
    }
  }
  
  void findClosestFood(){
    int index = 0;
    int counter = 0;
    float currentClosest = 1000;
    for(food food: foodList){
      if(!food.eaten){
         if(distanceFrom(food) < currentClosest){
           currentClosest = distanceFrom(food);
           index = counter;
         }
      }
      counter++;
    }
    target[0] = foodList.get(index).getX();
    target[1] = foodList.get(index).getY();
  }
  
  float distanceFrom(food food){
    double xMinusX = (x - food.getX());
    double xMinusXPow = Math.pow(xMinusX, 2);
    double yMinusY = Math.pow((y - food.getY()), 2);
    double distance = Math.sqrt(xMinusX + yMinusY);
    return (float)(distance);
  }

 void checkCollisions(){
   for(food food: foodList){
     if(!food.eaten){
       if(food.getX() >= x - size && food.getX() <= x + size){
        if(food.getY() >= y - size && food.getY() <= y + size){
          food.eaten = true;
          amountOfFood--;
          framesWithoutFood = 0;
          colour = 255;
          return;
        }
       }
     }  
  }
  framesWithoutFood ++;
  colour -= 255/lifeSpan;
  }
  
  void display(){
    fill(colour,0,0);
    ellipse(x, y, size, size);
    timeAlive++;
    
  }
  
  
  
  
}

class food {
  
  boolean eaten;
  float x;
  float y;
  
  food(){
    this.x = random(1,700);
    this.y = random(1,700);
    this.eaten = false;
  }
  
  float getX(){
   return x; 
  }
  
  float getY(){
   return y; 
  }
  
  boolean getState(){
   return eaten; 
  }
  
  void display(){
    fill(200);
    ellipseMode(CENTER);
    ellipse(x, y, 10,10);
  }
  
}

void setup(){
  size(700, 700);
  background(0);
  ellipseMode(CENTER);
  frameRate(30);
  for(int i = 0; i < populationSize; i++){
    animalList.add(new animal());
  }
}

void draw(){
  clear();
    while(amountOfFood < foodSpawnAmount){
    foodList.add(new food());
    amountOfFood++;
   }
    for(int i = 0; i < foodList.size(); i++){
    if(foodList.get(i).getState() == true){
      foodList.remove(i);
    } else {
     foodList.get(i).display(); 
    }
  }
  for(int i = 0; i < animalList.size(); i++){
    animalList.get(i).move();
  }
}

void mousePressed(){
  animalList.add(new animal(minSize, maxSize, mouseX, mouseY));
}
