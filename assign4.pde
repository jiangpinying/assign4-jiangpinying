PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX=new float [6],cabbageY=new float [6],soldierX=new float [6], soldierY=new float [6];
float[] soilEmptyX=new float [24],soilEmptyY=new float [24];
float[] soilEmptyX1=new float [24],soilEmptyY1=new float [24];

float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;

int col,row;

void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
	life = loadImage("img/life.png");
	soldier = loadImage("img/soldier.png");
	cabbage = loadImage("img/cabbage.png");

	soilEmpty = loadImage("img/soils/soilEmpty.png");

	// Load soil images used in assign3 if you don't plan to finish requirement #6
	soil0 = loadImage("img/soil0.png");
	soil1 = loadImage("img/soil1.png");
	soil2 = loadImage("img/soil2.png");
	soil3 = loadImage("img/soil3.png");
	soil4 = loadImage("img/soil4.png");
	soil5 = loadImage("img/soil5.png");

  stone1=loadImage("img/stone1.png");
  stone2=loadImage("img/stone2.png");

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
		}
	}

	// Load PImage[][] stones
	stones = new PImage[2][5];
	for(int i = 0; i < stones.length; i++){
		for(int j = 0; j < stones[i].length; j++){
			stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
		}
	}

	// Initialize player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;

	// Initialize soilHealth
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {
			 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      
      if(i==0 || i==3 || i==6){
        soilHealth[i][18]=45;
        soilHealth[i][21]=45;
        soilHealth[i][17]=30;
        soilHealth[i][20]=30;
        soilHealth[i][23]=30;
      }else if(i==1 || i==4 || i==7){
        soilHealth[i][17]=45;
        soilHealth[i][20]=45;
        soilHealth[i][23]=45;
        soilHealth[i][16]=30;
        soilHealth[i][19]=30;
        soilHealth[i][22]=30;
      }else{
        soilHealth[i][16]=45;
        soilHealth[i][19]=45;
        soilHealth[i][22]=45;
        soilHealth[i][18]=30;
        soilHealth[i][21]=30; 
      }
      
      if(i==0 || i==3 || i==4 || i==7){  
        soilHealth[i][9]=30;
        soilHealth[i][10]=30;
        soilHealth[i][13]=30;
        soilHealth[i][14]=30;
      }else{
        soilHealth[i][8]=30;
        soilHealth[i][11]=30;
        soilHealth[i][12]=30;
        soilHealth[i][15]=30;
      }
        
        soilHealth[i][i]=30;
        soilHealth[i][j]=15;
		}
    
  
	}
 
  for(int i = 0; i < 24; i++){
    soilEmptyX[i]=floor(random(8))*SOIL_SIZE;
    soilEmptyY[i]=(i+1)*SOIL_SIZE;
  }
  for(int i = 0; i < 24; i++){
    int count=floor(random(1)+1);
     for(int j=0 ; j<count ; j++){
      soilEmptyX1[i]=floor(random(8))*SOIL_SIZE;
      soilEmptyY1[i]=(i+1)*SOIL_SIZE; 
    }
  }
  
  
  
	// Initialize soidiers and their position
  
  for(int i=0 ; i<soldierX.length ; i++){
    soldierY[i]=floor((random(4))+4*i)*SOIL_SIZE;
    soldierX[i]=floor(random(8))*SOIL_SIZE;
  }
	// Initialize cabbages and their position
  
  for(int i=0 ; i<6 ; i++){
    cabbageY[i]=floor(random(4)+4*i)*SOIL_SIZE;
    cabbageX[i]=floor(random(8))*SOIL_SIZE;
  }
  
}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);
    
		// Soil

		for(int i = 0; i < soilHealth.length; i++){
      
			for (int j = 0; j < soilHealth[i].length; j++) {
        
  
  
				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				int areaIndex = floor(j / 4);
				image(soils[areaIndex][4], i * SOIL_SIZE, j* SOIL_SIZE);
        
        //stone
        //1-8
        image(stones[0][4],i*SOIL_SIZE,i*SOIL_SIZE);
      
			}
      //9-16
      for(int c=-1 ; c<8 ; c+=4){
        for(int a=0 ; a<7 ; a+=4){
          for(int b=0 ; b<2 ; b++){
            image(stones[0][4],(c+b)*80,(a+9)*80);
            image(stones[0][4],(c+b)*80,(a+10)*80);
            image(stones[0][4],(c+2+b)*80,(a+8)*80);
            image(stones[0][4],(c+2+b)*80,(a+11)*80);
          }
        } 
      }
      //levle17-24
      for(int c=0 ; c<8 ; c++){
        for(int a=0 ; a<2 ; a++){
          for(int b=-6 ; b<7 ; b+=3){
            image(stones[0][4],(c+a+b)*80,height-(c-17)*80);
            image(stones[1][4],(c+b+1)*80,height-(c-17)*80);
          }
        }
      }
		}
    
    //soilEmpty
    for(int i = 0; i < 24; i++){ 
      image(soilEmpty,soilEmptyX[i], soilEmptyY[i]);
      image(soilEmpty,soilEmptyX1[i], soilEmptyY1[i]);
    }

		// Cabbages
		// > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for(int i=0 ; i<6 ; i++){
      image(cabbage,cabbageX[i],cabbageY[i]);
      if(playerHealth<PLAYER_MAX_HEALTH && 
      cabbageX[i]<playerX+80 && cabbageX[i]+80>playerX &&
        cabbageY[i]<playerY+80 && cabbageY[i]+80>playerY){
        cabbageX[i]=width;
        playerHealth++;
        
      }
      
    }

		// Groundhog

		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
		if(playerMoveTimer == 0){

			// HINT:
			// You can use playerCol and playerRow to get which soil player is currently on

			// Check if "player is NOT at the bottom AND the soil under the player is empty"
			// > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
			// > Else then determine player's action based on input state

			if(leftState){

				groundhogDisplay = groundhogLeft;

				// Check left boundary
				if(playerCol > 0){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the left"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = LEFT;
					playerMoveTimer = playerMoveDuration;

				}

			}else if(rightState){

				groundhogDisplay = groundhogRight;

				// Check right boundary
				if(playerCol < SOIL_COL_COUNT - 1){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the right"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = RIGHT;
					playerMoveTimer = playerMoveDuration;

				}

			}else if(downState){

				groundhogDisplay = groundhogDown;

				// Check bottom boundary

				// HINT:
				// We have already checked "player is NOT at the bottom AND the soil under the player is empty",
				// and since we can only get here when the above statement is false,
				// we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
				if(playerRow < SOIL_ROW_COUNT - 1){

					// > If so, dig it and decrease its health

					// For requirement #3:
					// Note that player never needs to move down as it will always fall automatically,
					// so the following 2 lines can be removed once you finish requirement #3

					playerMoveDirection = DOWN;
					playerMoveTimer = playerMoveDuration;


				}
			}

		}

		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}

		image(groundhogDisplay, playerX, playerY);
    if(playerX==col*SOIL_SIZE &&  playerY+80==row*SOIL_SIZE){
      playerY+=80;
    }
		// Soldiers
    for(int i=0 ; i<6 ; i++){
      image(soldier,soldierX[i],soldierY[i]);
      soldierX[i]+=2;
      
      if(soldierX[i]<playerX+80 && soldierX[i]+80>playerX &&
        soldierY[i]<playerY+80 && soldierY[i]+80>playerY){
        playerY=PLAYER_INIT_Y;
        playerX=PLAYER_INIT_X;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth--;
        
      }
      if(soldierX[i]>width){
       soldierX[i]=-80;
      }
    }
    
		// > Remember to stop player's moving! (reset playerMoveTimer)
		// > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
		// > Remember to reset the soil under player's original position!

		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI
    for(int i=0 ; i<playerHealth ; i++ ){ 
      image(life,i*70+10,10);
    }
    
    if(playerHealth==0){
      gameState=GAME_OVER;
    }
    
		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

				// Initialize soilHealth
				soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
				for(int i = 0; i < soilHealth.length; i++){
					for (int j = 0; j < soilHealth[i].length; j++) {
						 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
						soilHealth[i][j] = 15;
					}
				}
        for(int i = 0; i < 24; i++){
          soilEmptyX[i]=floor(random(8))*SOIL_SIZE;
          soilEmptyY[i]=(i+1)*SOIL_SIZE;
        }
        for(int i = 0; i < 24; i++){
          int count=floor(random(1)+1);
           for(int j=0 ; j<count ; j++){
            soilEmptyX1[i]=floor(random(8))*SOIL_SIZE;
            soilEmptyY1[i]=(i+1)*SOIL_SIZE; 
          }
        }
        // Initialize soidiers and their position
				for(int i=0 ; i<soldierX.length ; i++){
          soldierY[i]=floor((random(4))+4*i)*SOIL_SIZE;
          soldierX[i]=floor(random(8))*SOIL_SIZE;
        }
        // Initialize cabbages and their position
  
        for(int i=0 ; i<6 ; i++){
          cabbageY[i]=floor(random(4)+4*i)*SOIL_SIZE;
          cabbageX[i]=floor(random(8))*SOIL_SIZE;
        }
				
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}
