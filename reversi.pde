Board board;
int turn = Stone.BLACK;
float unit_x, unit_y;

void setup() {
    size(400, 400);
    board = new Board();
    unit_x = width  / 8;
    unit_y = height / 8;
}

void draw() {
    drawBoard(board);
}

void drawBoard(Board b) {
    background(50, 150, 50);
    for( int x = 0 ; x < 8 ; x++ ) {
        for( int y = 0 ; y < 8 ; y++ ) {
            noFill();
            stroke(0);
            rectMode(CORNER);
            rect(unit_x * x, unit_y * y, unit_x, unit_y);
            if( b.board[x+1][y+1] != BLANK ) {
                ellipseMode(CENTER);
                fill((b.board[x+1][y+1] == Stone.BLACK) ? 0 : 255);
                ellipse(unit_x * (x+0.5), unit_y * (y+0.5), unit_x * 0.85, unit_y * 0.85);
            }
        }
    }
}

void mouseClicked() {
    int x = int(mouseX / unit_x) + 1;
    int y = int(mouseY / unit_y) + 1;
    Position pos = new Position(x, y);
    if( board.possibleToPutStoneAt(turn, pos) ) {
        if( board.putStoneAt(turn, pos) ) {
            board.reverseStonesFrom(pos);
            turn = Stone.reverseStone(turn);
        }
    }
}
