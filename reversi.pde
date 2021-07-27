int turn = Stone.BLACK;
float unit_x, unit_y;
Board board;
ComputerPlayer computerPlayer;
int MAX_LEVEL = 7;
boolean thinking = false;
int pass_num = 0;

void setup() {
    size(400, 400);
    board = new Board();
    unit_x = width  / 8;
    unit_y = height / 8;
    Evaluator midEval = new PutPosCornerEvaluator(2.0, 1.0, 1.0);
    Evaluator finEval = new StoneNumEvaluator();
    computerPlayer = new MinimaxPlayer(Stone.WHITE, midEval, finEval, MAX_LEVEL);
}

void draw() {
    drawBoard(board);
    if( thinking == true ) {
        noStroke();
        textSize(36);
        textAlign(CENTER, CENTER);
        fill(255, 0, 0);
        text("thinking ... ", width/2, height/2);
    }
    if( 2 <= pass_num ) {
        noStroke();
        textSize(36);
        textAlign(CENTER, CENTER);
        fill(0, 0, 0);
        text("Finished.", width/2, height/2);
    } else if( !board.possibleToPutStone(turn) ) {
        // pass
        turn = Stone.reverse(turn);
        pass_num++;
    } else if( turn == Stone.WHITE && thinking != true ) {
        thread("doComputerTurn"); // call method "doComputerTurn" in different thread
    }
}

void doComputerTurn() {
    thinking = true;
    if( turn == Stone.WHITE ) {
        Action action = computerPlayer.nextMove(board);
        if( board.possibleToPutStoneAt(turn, action.pos.x, action.pos.y) ) {
            if( board.putStoneAt(turn, action.pos.x, action.pos.y) ) {
                board.reverseStonesFrom(action.pos.x, action.pos.y);
                turn = Stone.reverse(turn);
                pass_num = 0;
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
        if( board.possibleToPutStoneAt(turn, x, y) ) {
            if( board.putStoneAt(turn, x, y) ) {
                board.reverseStonesFrom(x, y);
                turn = Stone.reverse(turn);
                pass_num = 0;
            }
        }
    }
}
