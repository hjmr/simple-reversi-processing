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
    int myStone = 0;
    ActionSelector(int myStone) {
        this.myStone = myStone;
    }

    Action searchNextMove(Board board) {
        return null;
    }
}
