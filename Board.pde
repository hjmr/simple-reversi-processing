public class Board {
    int BORDER = 100;
    int BLANK = 101;
    int X = 0, Y = 1;
    int[][] board;
    Stone stn;

    int[][] directions = {
        {-1,-1},{ 0,-1},{ 1,-1},
        {-1, 0},        { 1, 0},
        {-1, 1},{ 0, 1},{ 1, 1}
    };

    Board() {
        stn = new Stone();
        board = new int[10][10];
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                board[x][y] = BLANK;
            }
        }
        for( int i = 0 ; i < 10 ; i++ ) {
            board[0][i] = board[9][i] = board[i][0] = board[i][9] = BORDER;
        }
        board[4][4] = board[5][5] = stn.BLACK;
        board[4][5] = board[5][4] = stn.WHITE;
    }

    boolean possibleToPutStone(int stone) {
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( possibleToPutStoneAt(stone, new Position(x, y)) ) {
                    return true;
                }
            }
        }
        return false;
    }

    boolean possibleToPutStoneAt(int stone, Position pos) {
        boolean yn = false;
        for( int i = 0 ; i < directions.length ; i++ ) {
            if( 0 < _countReversibleStonesInDirection(stone, pos, directions[i][X], directions[i][Y]) ) {
                yn = true;
                break;
            }
        }
        return yn;
    }

    int countReversibleStones(int stone, Position pos) {
        int count = 0;
        for( int i = 0 ; i < directions.length ; i++ ) {
            count += _countReversibleStonesInDirection(stone, pos, directions[i][X], directions[i][Y]);
        }
        return count;
    }

    void reverseStonesFrom(Position pos) {
        int stone = board[pos.x][pos.y];
        if( stone == stn.BLACK || stone == stn.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                int dx = directions[i][X];
                int dy = directions[i][Y];
                Position last_pos = _findLastPosInDirection(stone, pos, dx, dy);
                if( last_pos != null ) {
                    _reverseStonesInDirection(stone, last_pos, -dx, -dy);
                }
            }
        }
    }

    boolean putStoneAt(int stone, Position pos) {
        boolean success = false;
        if( _getAt(pos) == BLANK ) {
            _setStoneAt(stone, pos);
            success = true;
        }
        return success;
    }

    int _getAt(Position pos) {
        return board[pos.x][pos.y];
    }

    void _setStoneAt(int stone, Position pos) {
        board[pos.x][pos.y] = stone;
    }

    int _countReversibleStonesInDirection(int stone, Position pos, int dx, int dy) {
        int rev_stone = stn.reverseStone(stone);
        int count = 0;
        int curr_x = pos.x + dx, curr_y = pos.y + dy;
        while( board[curr_x][curr_y] == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
            count++;
        }
        if( board[curr_x][curr_y] != stone ) {
            count = 0;
        }
        return count;
    }

    Position _findLastPosInDirection(int stone, Position pos, int dx, int dy) {
        int rev_stone = stn.reverseStone(stone);
        int curr_x = pos.x + dx, curr_y = pos.y + dy;
        while( board[curr_x][curr_y] == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
        }
        Position last_pos = null;
        if( board[curr_x][curr_y] == stone ) {
            last_pos = new Position(curr_x, curr_y);
        }
        return last_pos;
    }

    void _reverseStonesInDirection(int stone, Position pos, int dx, int dy) {
        int rev_stone = stn.reverseStone(stone);
        int curr_x = pos.x + dx, curr_y = pos.y + dy;
        while( board[curr_x][curr_y] == rev_stone ) {
            board[curr_x][curr_y] = stone;
            curr_x += dx;
            curr_y += dy;
        }
    }

    String toString() {
        String s = "";
        for( int y = 1 ; y <= 8 ; y++ ) {
            for( int x = 1 ; x <= 8 ; x++ ) {
                if( board[x][y] == stn.WHITE ) {
                    s += " O";
                } else if( board[x][y] == stn.BLACK ) {
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
