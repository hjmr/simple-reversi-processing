class Evaluator {
    int eval(Board board, int my_stone) {
        return 0;
    }
}

class MiddleEvaluator extends Evaluator {
    int eval(Board board, int my_stone) {
        int my_putpos = countPutPos(board, my_stone);
        int opp_putpos = countPutPos(board, Stone.reverse(my_stone));
        int eval = my_putpos - opp_putpos + evalCorners(board, my_stone);
        return eval;
    }

    int countPutPos(Board board, int my_stone) {
        int count = 0;
        for( int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( Game.possibleToPutStoneAt(board, my_stone, x, y) ) {
                    count++;
                }
            }
        }
        return count;
    }

    int evalCorners(Board board, int my_stone) {
        int opp_stone = Stone.reverse(my_stone);
        int point = 0;
        int[][] corners = {{1,1}, {1,8}, {8,1}, {8,8}};
        int corner_point = 5;
        for( int i = 0 ; i < corners.length ; i++ ) {
            int s = board.getAt(corners[i][0], corners[i][1]);
            if( s == my_stone ) {
                point += corner_point;
            } else if( s == opp_stone ) {
                point = corner_point;
            }
        }
        return point;
    }
}

class FinalEvaluator extends Evaluator {
    int eval(Board board, int my_stone) {
        int my_count = board.countStones(my_stone);
        int opp_count = board.countStones(Stone.reverse(my_stone));
        return my_count - opp_count;
    }
}
