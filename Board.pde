int BORDER = 100;
int BLANK = 101;

class Board {
    int[][] board;

    Board() {
        board = new int[10][10];
        _initBoard();
    }

    void _initBoard() {
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                board[x][y] = BLANK;
            }
        }
        for( int i = 0 ; i < 10 ; i++ ) {
            board[0][i] = board[9][i] = board[i][0] = board[i][9] = BORDER;
        }
        board[4][4] = board[5][5] = Stone.BLACK;
        board[4][5] = board[5][4] = Stone.WHITE;
    }

    int getAt(Position pos) {
        int ret = -1;
        if( 1 <= pos.x && pos.x <= 8 && 1 <= pos.y && pos.y <= 8 ) {
            ret = board[pos.x][pos.y];
        }
        return ret;
    }

    boolean setStoneAt(int stone, Position pos) {
        boolean success = false;
        if( 1 <= pos.x && pos.x <= 8 && 1 <= pos.y && pos.y <= 8 ) {
            board[pos.x][pos.y] = stone;
            success = true;
        }
        return success;
    }

    String toString() {
        String s = "";
        for( int y = 1 ; y <= 8 ; y++ ) {
            for( int x = 1 ; x <= 8 ; x++ ) {
                if( board[x][y] == Stone.WHITE ) {
                    s += " O";
                } else if( board[x][y] == Stone.BLACK ) {
                    s += " X";
                } else {
                    s += " .";
                }
            }
            s += "\n";
        }
        return s;
    }
}
