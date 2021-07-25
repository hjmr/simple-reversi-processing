class Player {
    int myStone;
    Player(int myStone) {
        this.myStone = myStone;
    }

    int getMyStone() {
        return myStone;
    }

    Action nextMove(Board board) {
        return null;
    }
}

class ComputerPlayer extends Player {
    int maxSearchLevel = 1;
    Minimax actionSelector;
    Evaluator middleEvaluator;
    Evaluator finalEvaluator;
    ComputerPlayer(int myStone, Evaluator middleEvaluator, Evaluator finalEvaluator, int maxSearchLevel) {
        super(myStone);
        this.middleEvaluator = middleEvaluator;
        this.finalEvaluator = finalEvaluator;
        this.maxSearchLevel = maxSearchLevel;
        actionSelector = new Minimax(this.middleEvaluator, myStone);
    }

    Action nextMove(Board board) {
        if( board.countBlank() < maxSearchLevel + 8 ) {
            actionSelector = new Minimax(this.finalEvaluator, myStone);
            this.maxSearchLevel = board.countBlank();
        }
        int start_time = millis();
        Action action = actionSelector.searchNextMove(board, maxSearchLevel);
        int elapsed_time_ms = millis() - start_time;
        showStat(elapsed_time_ms, action);
        return action;
    }

    void showStat(int elapsed_time_ms, Action act) {
        char[] int2str = {' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
        float elapsed_time = elapsed_time_ms / 1000.0;
        float time_per_eval = 1000.0 * elapsed_time_ms / act.evalCount;
        println("Put: " + int2str[act.pos.x] + act.pos.y +
                " Eval: " + act.eval +
                " (level:" + maxSearchLevel +
                " num:" + act.evalCount +
                " time:" + nf(elapsed_time,0,2) + "s" +
                " tpe:" + nf(time_per_eval,0,2) + "us)");
    }
}
