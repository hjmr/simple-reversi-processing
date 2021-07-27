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
    ActionSelector actionSelector;
    ComputerPlayer(int myStone, ActionSelector selector) {
        super(myStone);
        this.actionSelector = selector;
    }

    Action nextMove(Board board) {
        int start_time = millis();
        Action action = actionSelector.searchNextMove(board);
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
                " (num:" + act.evalCount +
                " time:" + nf(elapsed_time,0,2) + "s" +
                " tpe:" + nf(time_per_eval,0,2) + "us)");
    }
}


class MinimaxPlayer extends ComputerPlayer {
    Evaluator finalEvaluator;
    int maxSearchLevel;
    MinimaxPlayer(int myStone, Evaluator middleEvaluator, Evaluator finalEvaluator, int maxSearchLevel) {
        super(myStone, new Minimax(myStone, middleEvaluator, maxSearchLevel));
        this.finalEvaluator = finalEvaluator;
        this.maxSearchLevel = maxSearchLevel;
    }

    Action nextMove(Board board) {
        if( board.countBlank() < this.maxSearchLevel + 8 ) {
            this.actionSelector = new Minimax(myStone, this.finalEvaluator, board.countBlank());
        }
        return super.nextMove(board);
    }
}
