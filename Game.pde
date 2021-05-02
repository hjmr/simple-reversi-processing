static class Game {
    static PosDir[] directions;

    static void init() {
        int[][] _dirs = {
            {-1,-1},{ 0,-1},{ 1,-1},
            {-1, 0},        { 1, 0},
            {-1, 1},{ 0, 1},{ 1, 1}
        };
        directions = new PosDir[_dirs.length];
        for( int i = 0 ; i < _dirs.length ; i++ ) {
            directions[i] = new PosDir(_dirs[i][0], _dirs[i][1]);
        }
    }

    static boolean possibleToPutStone(Board board, int stone) {
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( possibleToPutStoneAt(board, stone, new PosDir(x, y)) ) {
                    return true;
                }
            }
        }
        return false;
    }

    static boolean possibleToPutStoneAt(Board board, int stone, PosDir pos) {
        boolean yn = false;
        if( board.getAt(pos) == BLANK ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                if( 0 < _countReversibleStonesInDirection(board, stone, pos, directions[i]) ) {
                    yn = true;
                    break;
                }
            }
        }
        return yn;
    }

    static int countReversibleStones(Board board, int stone, PosDir pos) {
        int count = 0;
        for( int i = 0 ; i < directions.length ; i++ ) {
            count += _countReversibleStonesInDirection(board, stone, pos, directions[i]);
        }
        return count;
    }

    static void reverseStonesFrom(Board board, PosDir pos) {
        int stone = board.getAt(pos);
        if( stone == Stone.BLACK || stone == Stone.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                PosDir dir = directions[i];
                PosDir last_pos = _findLastPosInDirection(board, stone, pos, dir);
                if( last_pos != null ) {
                    _reverseStonesInDirection(board, stone, last_pos, PosDir.mul(dir, -1));
                }
            }
        }
    }

    static boolean putStoneAt(Board board, int stone, PosDir pos) {
        boolean success = false;
        if( board.getAt(pos) == BLANK ) {
            board.setStoneAt(stone, pos);
            success = true;
        }
        return success;
    }

    static int _countReversibleStonesInDirection(Board board, int stone, PosDir pos, PosDir dir) {
        int rev_stone = Stone.reverseStone(stone);
        int count = 0;
        PosDir curr_pos = PosDir.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            curr_pos.add(dir);
            count++;
        }
        if( board.getAt(curr_pos) != stone ) {
            count = 0;
        }
        return count;
    }

    static PosDir _findLastPosInDirection(Board board, int stone, PosDir pos, PosDir dir) {
        int rev_stone = Stone.reverseStone(stone);
        PosDir curr_pos = PosDir.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            curr_pos.add(dir);
        }
        PosDir last_pos = null;
        if( board.getAt(curr_pos) == stone ) {
            last_pos = curr_pos;
        }
        return last_pos;
    }

    static void _reverseStonesInDirection(Board board, int stone, PosDir pos, PosDir dir) {
        int rev_stone = Stone.reverseStone(stone);
        PosDir curr_pos = PosDir.add(pos, dir);
        while( board.getAt(curr_pos) == rev_stone ) {
            board.setStoneAt(stone, curr_pos);
            curr_pos.add(dir);
        }
    }
}
