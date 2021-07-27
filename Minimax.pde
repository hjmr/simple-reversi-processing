class Minimax extends ActionSelector {
    Evaluator evaluator = null;
    int maxLevel = 0;
    int evalCount = 0;

    class EvalPos {
        Pos pos;
        float eval;
        EvalPos(Pos pos, float eval) {
            this.pos = pos;
            this.eval = eval;
        }
    }

    Minimax(int myStone, Evaluator evaluator, int maxLevel) {
        super(myStone);
        this.evaluator = evaluator;
        this.myStone = myStone;
        this.maxLevel = maxLevel;
        this.evalCount = 0;
    }

    Action searchNextMove(Board board) {
        evalCount = 0;
        EvalPos ep = doMinimax(board, this.myStone, 0, -1000, 1000);
        Action action = new Action(ep.pos, ep.eval, this.evalCount);
        return action;
    }

    EvalPos doMinimax(Board board, int currStone, int currLevel, float alpha, float beta) {
        EvalPos evalPos;
        currLevel++;
        ArrayList<Pos> posList = getPositionsToPutStone(board, currStone);
        if( 0 < posList.size() ) {
            ArrayList<EvalPos> evalPosList = new ArrayList<EvalPos>();
            float _alpha = -1000;
            float _beta = 1000;
            for( int i = 0 ; i < posList.size() ; i++ ) {
                float _ev = 0;
                Board b = board.copy();
                Pos pos = posList.get(i);
                b.putStoneAt(currStone, pos.x, pos.y);
                b.reverseStonesFrom(pos.x, pos.y);
                if( this.maxLevel <= currLevel ) {
                    _ev = eval(b);
                } else {
                    _ev = doMinimax(b, Stone.reverse(currStone), currLevel, _alpha, _beta).eval;
                }
                evalPosList.add(new EvalPos(pos, _ev));

                // alpha-beta branch cut
                if(( currStone == this.myStone && beta < _ev ) || ( currStone != this.myStone && _ev < alpha )) {
                    break;
                }
                // update alpha-beta
                _alpha = (_alpha <   _ev) ? _ev : _alpha;
                _beta = (_ev     < _beta) ? _ev : _beta;
            }

            if( currStone == this.myStone) {
                evalPos = getMax(evalPosList);
            } else {
                evalPos = getMin(evalPosList);
            }
        } else {
            if( this.maxLevel <= currLevel ) {
                evalPos = new EvalPos(null, eval(board));
            } else {
                evalPos = new EvalPos(null, doMinimax(board, Stone.reverse(currStone), currLevel, alpha, beta).eval);
            }
        }
        return evalPos;
    }

    ArrayList<Pos> getPositionsToPutStone(Board board, int stone) {
        ArrayList<Pos> positions = new ArrayList<Pos>();
        for(int x = 1 ; x <= 8 ; x++ ) {
            for( int y = 1 ; y <= 8 ; y++ ) {
                if( board.possibleToPutStoneAt(stone, x, y) ) {
                    positions.add(new Pos(x, y));
                }
            }
        }
        return positions;
    }

    float eval(Board board) {
        this.evalCount++;
        float ev = evaluator.eval(board, myStone);
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
