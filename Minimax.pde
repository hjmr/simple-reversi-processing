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
        EvalPos ep = doMinimax(board, this.myStone, 0, maxLevel);
        int[] ret = new int[2];
        ret[0] = ep.pos.x;
        ret[1] = ep.pos.y;
        return ret;
    }

    EvalPos doMinimax(Board board, int stone, int currLevel, int maxLevel) {
        EvalPos evalPos;
        currLevel++;
        ArrayList<Pos> posList = getPositionsToPutStone(board, stone);
        if( 0 < posList.size() ) {
            ArrayList<EvalPos> evalPosList = new ArrayList<EvalPos>();
            for( int i = 0 ; i < posList.size() ; i++ ) {
                Board b = board.copy();
                Pos pos = posList.get(i);
                Game.putStoneAt(b, stone, pos.x, pos.y);
                Game.reverseStonesFrom(b, pos.x, pos.y);
                if( maxLevel <= currLevel ) {
                    evalPosList.add(new EvalPos(pos, eval(b)));
                } else {
                    evalPosList.add(new EvalPos(pos, doMinimax(b, Stone.reverse(stone), currLevel, maxLevel).eval));
                }
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
                evalPos = new EvalPos(null, doMinimax(board, Stone.reverse(stone), currLevel, maxLevel).eval);
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
