class Pos {
    int x, y;
    Pos(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

class Action {
    Pos pos;
    float eval;
    int evalCount;
    Action(Pos pos, float eval, int evalCount) {
        this.pos = pos;
        this.eval = eval;
        this.evalCount = evalCount;
    }
}

class ActionSelector {
    Action searchNextMove(Board board) {
        return null;
    }
}


class Minimax {
    Evaluator evaluator = null;
    int myStone = 0;
    int evalCount = 0;

    class EvalPos {
        Pos pos;
        float eval;
        EvalPos(Pos pos, float eval) {
            this.pos = pos;
            this.eval = eval;
        }
    }

    Minimax(Evaluator evaluator, int myStone) {
        this.evaluator = evaluator;
        this.myStone = myStone;
        this.evalCount = 0;
    }

    Action searchNextMove(Board board, int maxLevel) {
        evalCount = 0;
        EvalPos ep = doMinimax(board, this.myStone, 0, maxLevel, -1000, 1000);
        Action action = new Action(ep.pos, ep.eval, this.evalCount);
        return action;
    }

    EvalPos doMinimax(Board board, int currStone, int currLevel, int maxLevel, float alpha, float beta) {
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
                if( maxLevel <= currLevel ) {
                    _ev = eval(b, currStone);
                } else {
                    _ev = doMinimax(b, Stone.reverse(currStone), currLevel, maxLevel, _alpha, _beta).eval;
                }
                evalPosList.add(new EvalPos(pos, _ev));

                // alpha-beta branch cut
                if(( currStone == myStone && beta < _ev ) || ( currStone != myStone && _ev < alpha )) {
                    break;
                }
                // update alpha-beta
                _alpha = (_alpha <   _ev) ? _ev : _alpha;
                _beta = (_ev     < _beta) ? _ev : _beta;
            }

            if( currStone == myStone) {
                evalPos = getMax(evalPosList);
            } else {
                evalPos = getMin(evalPosList);
            }
        } else {
            if( maxLevel <= currLevel ) {
                evalPos = new EvalPos(null, eval(board, currStone));
            } else {
                evalPos = new EvalPos(null, doMinimax(board, Stone.reverse(currStone), currLevel, maxLevel, alpha, beta).eval);
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

    float eval(Board board, int currStone) {
        evalCount++;
        float ev = evaluator.eval(board, currStone, myStone);
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
