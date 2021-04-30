class Game {
    Board board;
    Position[] directions;

    Game() {
        board = new Board();

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
        if( board.getAt(pos) == BLANK ) {
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
        int stone = board.getAt(pos);
        if( stone == Stone.BLACK || stone == Stone.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                Position dir = directions[i];
                Position last_pos = _findLastPosInDirection(stone, pos, dir);
                if( last_pos != null ) {
                    _reverseStonesInDirection(stone, last_pos, Position.mul(dir, -1));
                }
            }
        }
    }

    boolean putStoneAt(int stone, Position pos) {
        boolean success = false;
        if( board.getAt(pos) == BLANK ) {
            board.setStoneAt(stone, pos);
            success = true;
        }
        return success;
    }

    int _countReversibleStonesInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        int count = 0;
        Position curr_pos = Position.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            curr_pos.add(dir);
            count++;
        }
        if( board.getAt(curr_pos) != stone ) {
            count = 0;
        }
        return count;
    }

    Position _findLastPosInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        Position curr_pos = Position.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            curr_pos.add(dir);
        }
        Position last_pos = null;
        if( board.getAt(curr_pos) == stone ) {
            last_pos = curr_pos;
        }
        return last_pos;
    }

    void _reverseStonesInDirection(int stone, Position pos, Position dir) {
        int rev_stone = Stone.reverseStone(stone);
        Position curr_pos = Position.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            board.setStoneAt(stone, curr_pos);
            curr_pos.add(dir);
        }
    }

    String toString() {
        return board.toString();
    }
}
