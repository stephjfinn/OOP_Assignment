/*
    DIT OOP Assignment 2 Starter Code
    =================================
    
    Loads player properties from an xml file
    See: https://github.com/skooter500/DT228-OOP 
*/

ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
boolean[] keys = new boolean[526];
int w = 1280;
int h = 900;
int speed = 3;
int px, py;

void setup()
{
  size(w, h);
  setUpPlayerControllers();
}

void draw()
{
  background(0);
  //bgupdate();
  
  //for loop that calls the player methods to update the location and display it to the screen
  for(Player player:players)
  {
    player.update();
    player.display();
  }//end for()
  
  //for loop to update the position of all bullets and display them on screen
  for(int i = 0; i < bullets.size(); i++)
  {
    bullets.get(i).update();
    bullets.get(i).display();
    
    //if statement to remove bullets from the list
    if(bullets.get(i).alive == false)
    {
      bullets.remove(i);
      println("bullet " + i + " removed");
    }//end if()
  }//end for()
  
  //if statement to create new enemies
  if(frameCount % (60*4) == 0)
  {
    println("new enemy");
    Enemy e = new Grunt();
    enemies.add(e);
  }//end if()
  
  //for loop to update position and display enemies
  for(int i = 0; i < enemies.size(); i++)
  {
    enemies.get(i).update();
    enemies.get(i).display();
    
    //if statement to remove an enemy from the list when it dies
    if(enemies.get(i).alive == false)
    {
      enemies.remove(i);
      println("enemy " + i + " removed");
    }//end if()
  }//end for()
  
  //collision detecting nested for loops
  for(int i=0; i<enemies.size(); i++)
  {
    for(int j=0; j<bullets.size(); j++)
    {
      if((enemies.get(i).pos.y + enemies.get(i).h) >= bullets.get(j).pos.y &&
          enemies.get(i).pos.x <= bullets.get(j).pos.x &&
          (enemies.get(i).pos.x + enemies.get(i).w) >= bullets.get(j).pos.x)
      {
        println("enemy hit");
        enemies.get(i).hp--;
        bullets.get(j).alive = false;
      }//end if()
    }//end inner for()
  }//end outer for()
}//end draw()

void keyPressed()
{
  keys[keyCode] = true;
}

void keyReleased()
{
  keys[keyCode] = false;
}

boolean checkKey(char theKey)
{
  return keys[Character.toUpperCase(theKey)];
}

char buttonNameToKey(XML xml, String buttonName)
{
  String value =  xml.getChild(buttonName).getContent();
  if ("LEFT".equalsIgnoreCase(value))
  {
    return LEFT;
  }
  if ("RIGHT".equalsIgnoreCase(value))
  {
    return RIGHT;
  }
  if ("UP".equalsIgnoreCase(value))
  {
    return UP;
  }
  if ("DOWN".equalsIgnoreCase(value))
  {
    return DOWN;
  }
  //.. Others to follow
  return value.charAt(0);  
}

void setUpPlayerControllers()
{
  XML xml = loadXML("arcade.xml");
  XML[] children = xml.getChildren("player");
  int gap = width / (children.length + 1);
  
  for(int i = 0 ; i < children.length ; i ++)  
  {
    XML playerXML = children[i];
    Player p = new Player(i, playerXML);
    int x = (i + 1) * gap;
    p.pos.x = x;
    p.pos.y = (h/20) * 19;
    players.add(p);         
  }
}
