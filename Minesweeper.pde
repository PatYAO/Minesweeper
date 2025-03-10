import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 10, NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_COLS; i++){
      for(int j = 0; j < NUM_ROWS; j++){
          buttons[j][i] = new MSButton(j,i); 
      }
    }
    
    for(int m = 0; m < 20; m++){
      setMines();
    }
}
public void setMines()
{
    int mineRows = (int)(Math.random() * (NUM_ROWS));
    int mineCols = (int)(Math.random() * (NUM_COLS));
    if(!mines.contains(buttons[mineRows][mineCols])){
      mines.add(buttons[mineRows][mineCols]);
    }
    //System.out.println((mineRows+1) + "," + (mineCols+1));
}

public void draw ()
{
    background( 0 );
    for(int i = 0; i < NUM_COLS; i++){
      for(int j = 0; j < NUM_ROWS; j++){
        if(buttons[j][i].clicked && countMines(j,i) != 0 && !mines.contains(buttons[j][i])){
          buttons[j][i].setLabel(countMines(j,i));
        }
      }
    }
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int x = 0;
    for(int i = 0; i < NUM_COLS; i++){
      for(int j = 0; j < NUM_ROWS; j++){
        if(buttons[j][i].clicked && mines.contains(buttons[j][i])){
          displayLosingMessage();
          return false;
        }
        else if(buttons[j][i].clicked && !mines.contains(buttons[j][i])){
          x++;
        }
      }
    }
    if(x == (NUM_ROWS * NUM_COLS) - mines.size()){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
     buttons[0][0].setLabel("Y");
     buttons[0][1].setLabel("o");
     buttons[0][2].setLabel("u");
     buttons[1][0].setLabel("L");
     buttons[1][1].setLabel("o");
     buttons[1][2].setLabel("s");
     buttons[1][3].setLabel("e");
    //your code here
}
public void displayWinningMessage()
{
     buttons[0][0].setLabel("Y");
     buttons[0][1].setLabel("o");
     buttons[0][2].setLabel("u");
     buttons[1][0].setLabel("W");
     buttons[1][1].setLabel("i");
     buttons[1][2].setLabel("n");
     
    //your code here
}
public boolean isValid(int r, int c)
{
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
    return true;
  }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
  for(int r = row-1;r<=row+1;r++)
    for(int c = col-1; c<=col+1;c++)
      if(isValid(r,c) && mines.contains(buttons[r][c]))
        numMines++;
      if(mines.contains(buttons[row][col]))
         numMines--;
   return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(isValid(myRow,myCol-1) && !mines.contains(buttons[myRow][myCol-1] ) && buttons[myRow][myCol-1].clicked == false && countMines(myRow,myCol-1) <= 2) {
            buttons[myRow][myCol-1].mousePressed();
            //System.out.println("Done");
         }
         
         if(isValid(myRow,myCol+1) && !mines.contains(buttons[myRow][myCol+1] ) && buttons[myRow][myCol+1].clicked == false && countMines(myRow,myCol+1) <= 2){
            buttons[myRow][myCol+1].mousePressed();
            //System.out.println("Done");
         }
         if(isValid(myRow-1,myCol) && !mines.contains(buttons[myRow-1][myCol] ) && buttons[myRow-1][myCol].clicked == false && countMines(myRow-1,myCol) <= 2){
            buttons[myRow-1][myCol].mousePressed();
            //System.out.println("Done");
         }
         if(isValid(myRow+1,myCol) && !mines.contains(buttons[myRow+1][myCol] ) && buttons[myRow+1][myCol].clicked == false && countMines(myRow+1,myCol) <= 2){
            buttons[myRow+1][myCol].mousePressed();
            //System.out.println("Done");
         }
         
        if(mouseButton == RIGHT){
          if(flagged){
            flagged = false;
          }
          else{
            flagged = true;
          }
          if(mines.contains(this)){
            myLabel = "YOU LOSE";
          }
          if(countMines(myRow,myCol) > 0){
            myLabel += countMines(myRow,myCol);
          }

          else{
            mousePressed();
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);

    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
