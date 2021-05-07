int turn = Stone.BLACK;
float unit_x, unit_y;
Board board;
ComputerPlayer computerPlayer;
int MAX_LEVEL = 6;
boolean thinking = false;

void setup() {
    size(400, 400);
    board = new Board();
    unit_x = width  / 8;
    unit_y = height / 8;
    computerPlayer = new ComputerPlayer(Stone.WHITE, MAX_LEVEL);
}

void draw() {
    drawBoard(board);
    if( thinking == true ) {
        stroke(255, 0, 0);
        fill(255, 0, 0);
        textSize(36);
        textAlign(CENTER, CENTER);
        text("thinking ... ", width/2, height/2);
    }
    if( !Game.possibleToPutStone(board, turn) ) {
        // pass
        turn = Stone.reverse(turn);
    } else if( turn == Stone.WHITE && thinking != true ) {
        thread("doComputerTurn");
    }
}

void doComputerTurn() {
    thinking = true;
    if( turn == Stone.WHITE ) {
        int[] pos = computerPlayer.nextMove(board);
        if( Game.possibleToPutStoneAt(board, turn, pos[0], pos[1]) ) {
            if( Game.putStoneAt(board, turn, pos[0], pos[1]) ) {
                Game.reverseStonesFrom(board, pos[0], pos[1]);
                turn = Stone.reverse(turn);
                thinking = false;
            }
        }
    }
}

void drawBoard(Board b) {
    background(50, 150, 50);
    for( int x = 0 ; x < 8 ; x++ ) {
        for( int y = 0 ; y < 8 ; y++ ) {
            noFill();
            stroke(0);
            rectMode(CORNER);
            rect(unit_x * x, unit_y * y, unit_x, unit_y);
            int stoneColor = b.getAt(x+1, y+1);
            if( stoneColor != BLANK ) {
                ellipseMode(CENTER);
                fill((stoneColor == Stone.BLACK) ? 0 : 255);
                ellipse(unit_x * (x+0.5), unit_y * (y+0.5), unit_x * 0.85, unit_y * 0.85);
            }
        }
    }
}

void mouseClicked() {
    if( turn == Stone.BLACK ) {
        int x = int(mouseX / unit_x) + 1;
        int y = int(mouseY / unit_y) + 1;
        if( Game.possibleToPutStoneAt(board, turn, x, y) ) {
            if( Game.putStoneAt(board, turn, x, y) ) {
                Game.reverseStonesFrom(board, x, y);
                turn = Stone.reverse(turn);
            }
        }
    }
}
