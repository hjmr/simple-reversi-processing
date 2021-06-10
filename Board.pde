static int BORDER = 100;
static int BLANK  = 101;

class Board {

    int[][] board;

    int[][] directions = {
        {-1,-1},{ 0,-1},{ 1,-1},
        {-1, 0},        { 1, 0},
        {-1, 1},{ 0, 1},{ 1, 1}
    };

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
        board[4][4] = board[5][5] = Stone.WHITE;
        board[4][5] = board[5][4] = Stone.BLACK;
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

    boolean possibleToPutStone(int stone) {
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( possibleToPutStoneAt(stone, x, y) ) {
                    return true;
                }
            }
        }
        return false;
    }

    boolean possibleToPutStoneAt(int stone, int x, int y) {
        boolean yn = false;
        if( getAt(x, y) == BLANK ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                if( 0 < _countReversibleStonesInDirection(stone, x, y, directions[i][0], directions[i][1]) ) {
                    yn = true;
                    break;
                }
            }
        }
        return yn;
    }

    int countReversibleStones(int stone, int x, int y) {
        int count = 0;
        for( int i = 0 ; i < directions.length ; i++ ) {
            count += _countReversibleStonesInDirection(stone, x, y, directions[i][0], directions[i][1]);
        }
        return count;
    }

    void reverseStonesFrom(int x, int y) {
        int stone = getAt(x, y);
        if( stone == Stone.BLACK || stone == Stone.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                int[] dir = directions[i];
                int[] last_pos = _findLastPosInDirection(stone, x, y, dir[0], dir[1]);
                if( last_pos != null ) {
                    _reverseStonesInDirection(stone, last_pos[0], last_pos[1], -dir[0], -dir[1]);
                }
            }
        }
    }

    boolean putStoneAt(int stone, int x, int y) {
        boolean success = false;
        if( getAt(x, y) == BLANK ) {
            setStoneAt(stone, x, y);
            success = true;
        }
        return success;
    }

    int _countReversibleStonesInDirection(int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int count = 0;
        int curr_x  = x + dx, curr_y = y + dy;
        while( getAt(curr_x, curr_y) == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
            count++;
        }
        if( getAt(curr_x, curr_y) != stone ) {
            count = 0;
        }
        return count;
    }

    int[] _findLastPosInDirection(int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int curr_x  = x + dx, curr_y = y + dy;
        while( getAt(curr_x, curr_y) == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
        }
        int[] last_pos = null;
        if( getAt(curr_x, curr_y) == stone ) {
            last_pos = new int[2];
            last_pos[0] = curr_x;
            last_pos[1] = curr_y;
        }
        return last_pos;
    }

    void _reverseStonesInDirection(int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int curr_x  = x + dx, curr_y = y + dy;
        while( getAt(curr_x, curr_y) == rev_stone ) {
            setStoneAt(stone, curr_x, curr_y);
            curr_x += dx;
            curr_y += dy;
        }
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
