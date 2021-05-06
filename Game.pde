static class Game {
    static int[][] directions = {
        {-1,-1},{ 0,-1},{ 1,-1},
        {-1, 0},        { 1, 0},
        {-1, 1},{ 0, 1},{ 1, 1}
    };

    static boolean possibleToPutStone(Board board, int stone) {
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( possibleToPutStoneAt(board, stone, x, y) ) {
                    return true;
                }
            }
        }
        return false;
    }

    static boolean possibleToPutStoneAt(Board board, int stone, int x, int y) {
        boolean yn = false;
        if( board.getAt(x, y) == BLANK ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                if( 0 < _countReversibleStonesInDirection(board, stone, x, y, directions[i][0], directions[i][1]) ) {
                    yn = true;
                    break;
                }
            }
        }
        return yn;
    }

    static int countReversibleStones(Board board, int stone, int x, int y) {
        int count = 0;
        for( int i = 0 ; i < directions.length ; i++ ) {
            count += _countReversibleStonesInDirection(board, stone, x, y, directions[i][0], directions[i][1]);
        }
        return count;
    }

    static void reverseStonesFrom(Board board, int x, int y) {
        int stone = board.getAt(x, y);
        if( stone == Stone.BLACK || stone == Stone.WHITE ) {
            for( int i = 0 ; i < directions.length ; i++ ) {
                int[] dir = directions[i];
                int[] last_pos = _findLastPosInDirection(board, stone, x, y, dir[0], dir[1]);
                if( last_pos != null ) {
                    _reverseStonesInDirection(board, stone, last_pos[0], last_pos[1], -dir[0], -dir[1]);
                }
            }
        }
    }

    static boolean putStoneAt(Board board, int stone, int x, int y) {
        boolean success = false;
        if( board.getAt(x, y) == BLANK ) {
            board.setStoneAt(stone, x, y);
            success = true;
        }
        return success;
    }

    static int _countReversibleStonesInDirection(Board board, int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int count = 0;
        int curr_x  = x + dx, curr_y = y + dy;
        while( board.getAt(curr_x, curr_y) == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
            count++;
        }
        if( board.getAt(curr_x, curr_y) != stone ) {
            count = 0;
        }
        return count;
    }

    static int[] _findLastPosInDirection(Board board, int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int curr_x  = x + dx, curr_y = y + dy;
        while( board.getAt(curr_x, curr_y) == rev_stone ) {
            curr_x += dx;
            curr_y += dy;
        }
        int[] last_pos = null;
        if( board.getAt(curr_x, curr_y) == stone ) {
            last_pos = new int[2];
            last_pos[0] = curr_x;
            last_pos[1] = curr_y;
        }
        return last_pos;
    }

    static void _reverseStonesInDirection(Board board, int stone, int x, int y, int dx, int dy) {
        int rev_stone = Stone.reverse(stone);
        int curr_x  = x + dx, curr_y = y + dy;
        while( board.getAt(curr_x, curr_y) == rev_stone ) {
            board.setStoneAt(stone, curr_x, curr_y);
            curr_x += dx;
            curr_y += dy;
        }
    }
}
