int BORDER = 100;
int BLANK = 101;

class Board {
    int[][] board;
    Position[] directions;

    Board() {
        board = new int[10][10];
        _initBoard();

        int[][] _dirs = {
            {-1,-1},{ 0,-1},{ 1,-1},
            {-1, 0},        { 1, 0},
            {-1, 1},{ 0, 1},{ 1, 1}
        };
        directions = new Position[_dirs.length];
        for( int i = 0 ; i < _dirs.length ; i++ ) {
            directions[i] = new Position(_dirs[i][0], _dirs[i][1]);
        }
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
        if( _getAt(pos) == BLANK ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                if( 0 < _countReversibleStonesInDirection(stone, pos, directions[i]) ) {
                    yn = true;
                    break;
                }
            }
        }
        return yn;
    }

    int countReversibleStones(int stone, Position pos) {
        int count = 0;
        for( int i = 0 ; i < directions.length ; i++ ) {
            count += _countReversibleStonesInDirection(stone, pos, directions[i]);
        }
        return count;
    }

    void reverseStonesFrom(Position pos) {
        int stone = board[pos.x][pos.y];
        if( stone == Stone.BLACK || stone == Stone.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                Position dir = directions[i];
                Position last_pos = _findLastPosInDirection(stone, pos, dir);
                if( last_pos != null ) {
                    _reverseStonesInDirection(stone, last_pos, new Position(-dir.x, -dir.y));
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

    int _countReversibleStonesInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        int count = 0;
        int curr_x = pos.x + dir.x, curr_y = pos.y + dir.y;
        while( board[curr_x][curr_y] == rev_stone ) {
            curr_x += dir.x;
            curr_y += dir.y;
            count++;
        }
        if( board[curr_x][curr_y] != stone ) {
            count = 0;
        }
        return count;
    }

    Position _findLastPosInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        int curr_x = pos.x + dir.x, curr_y = pos.y + dir.y;
        while( board[curr_x][curr_y] == rev_stone ) {
            curr_x += dir.x;
            curr_y += dir.y;
        }
        Position last_pos = null;
        if( board[curr_x][curr_y] == stone ) {
            last_pos = new Position(curr_x, curr_y);
        }
        return last_pos;
    }

    void _reverseStonesInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        int curr_x = pos.x + dir.x, curr_y = pos.y + dir.y;
        while( board[curr_x][curr_y] == rev_stone ) {
            board[curr_x][curr_y] = stone;
            curr_x += dir.x;
            curr_y += dir.y;
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
