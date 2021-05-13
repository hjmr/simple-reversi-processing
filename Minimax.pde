class Minimax {
    Evaluator evaluator = null;
    int myStone = 0;
    int evalCount = 0;

    class Pos {
        int x, y;
        Pos(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }

    class EvalPos {
        Pos pos;
        int eval;
        EvalPos(Pos pos, int eval) {
            this.pos = pos;
            this.eval = eval;
        }
    }

    Minimax(Evaluator evaluator, int myStone) {
        this.evaluator = evaluator;
        this.myStone = myStone;
        this.evalCount = 0;
    }

    int[] searchNextMove(Board board, int maxLevel) {
        evalCount = 0;
        EvalPos ep = doMinimax(board, this.myStone, 0, maxLevel, -1000, 1000);
        int[] ret = new int[2];
        ret[0] = ep.pos.x;
        ret[1] = ep.pos.y;
        return ret;
    }

    EvalPos doMinimax(Board board, int stone, int currLevel, int maxLevel, int alpha, int beta) {
        EvalPos evalPos;
        currLevel++;
        ArrayList<Pos> posList = getPositionsToPutStone(board, stone);
        if( 0 < posList.size() ) {
            ArrayList<EvalPos> evalPosList = new ArrayList<EvalPos>();
            int _alpha = -1000;
            int _beta = 1000;
            for( int i = 0 ; i < posList.size() ; i++ ) {
                int _ev = 0;
                Board b = board.copy();
                Pos pos = posList.get(i);
                Game.putStoneAt(b, stone, pos.x, pos.y);
                Game.reverseStonesFrom(b, pos.x, pos.y);
                if( maxLevel <= currLevel ) {
                    _ev = eval(b);
                } else {
                    _ev = doMinimax(b, Stone.reverse(stone), currLevel, maxLevel, _alpha, _beta).eval;
                }
                evalPosList.add(new EvalPos(pos, _ev));

                // alpha-beta branch cut
                if(( stone == myStone && _beta < _ev ) || ( stone != myStone && _ev < _alpha )) {
                    break;
                }
                // update alpha-beta
                _alpha = (_alpha <   _ev) ? _ev : _alpha;
                _beta = (_ev     < _beta) ? _ev : _beta;
            }

            if( stone == myStone) {
                evalPos = getMax(evalPosList);
            } else {
                evalPos = getMin(evalPosList);
            }
        } else {
            if( maxLevel <= currLevel ) {
                evalPos = new EvalPos(null, eval(board));
            } else {
                evalPos = new EvalPos(null, doMinimax(board, Stone.reverse(stone), currLevel, maxLevel, alpha, beta).eval);
            }
        }
        return evalPos;
    }

    ArrayList<Pos> getPositionsToPutStone(Board board, int stone) {
        ArrayList<Pos> positions = new ArrayList<Pos>();
        for(int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( Game.possibleToPutStoneAt(board, stone, x, y) ) {
                    positions.add(new Pos(x, y));
                }
            }
        }
        return positions;
    }

    int eval(Board board) {
        evalCount++;
        int ev = evaluator.eval(board, myStone);
        return ev;
    }

    EvalPos getMax(ArrayList<EvalPos> evalPosList) {
        EvalPos ep = null;
        if( 0 < evalPosList.size() ) {
            ep = evalPosList.get(0);
            for( int i = 1 ; i < evalPosList.size() ; i++ ) {
                EvalPos curr = evalPosList.get(i);
                if( ep.eval < curr.eval ) {
                    ep = curr;
                }
            }
        }
        return ep;
    }

    EvalPos getMin(ArrayList<EvalPos> evalPosList) {
        EvalPos ep = null;
        if( 0 < evalPosList.size() ) {
            ep = evalPosList.get(0);
            for( int i = 1 ; i < evalPosList.size() ; i++ ) {
                EvalPos curr = evalPosList.get(i);
                if( curr.eval < ep.eval ) {
                    ep = curr;
                }
            }
        }
        return ep;
    }
}
