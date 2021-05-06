static int BORDER = 100;
static int BLANK = 101;

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

    int getAt(int x, int y) {
        int ret = -1;
        if( 1 <= x && x <= 8 && 1 <= y && y <= 8 ) {
            ret = board[x][y];
        }
        return ret;
    }

    boolean setStoneAt(int stone, int x, int y) {
        boolean success = false;
        if( 1 <= x && x <= 8 && 1 <= y && y <= 8 ) {
            board[x][y] = stone;
            success = true;
        }
        return success;
    }

    int countStones(int stone) {
        int count = 0;
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( board[x][y] == stone ) {
                    count++;
                }
            }
        }
        return count;
    }

    int countBlank() {
        int count = 0;
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( board[x][y] == BLANK ) {
                    count++;
                }
            }
        }
        return count;
    }

    Board copy() {
        Board b = new Board();
        for( int x = 0 ; x < this.board.length ; x++ ) {
            for( int y = 0 ; y < this.board[x].length ; y++ ) {
                b.board[x][y] = this.board[x][y];
            }
        }
        return b;
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
