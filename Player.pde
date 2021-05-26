class Player {
    int myStone;
    Player(int myStone) {
        this.myStone = myStone;
    }

    int getMyStone() {
        return myStone;
    }

    int[] nextMove(Board board) {
        int[] ret = new int[2];
        return ret;
    }
}

class ComputerPlayer extends Player {
    int maxSearchLevel = 1;
    Minimax actionSelector;
    ComputerPlayer(int myStone, int maxSearchLevel) {
        super(myStone);
        this.maxSearchLevel = maxSearchLevel;
        actionSelector = new Minimax(new MiddleEvaluator(), myStone);
    }

    int[] nextMove(Board board) {
        if( board.countBlank() < maxSearchLevel + 8 ) {
            actionSelector = new Minimax(new FinalEvaluator(), myStone);
        }
        int start_time = millis();
        int[] ret = actionSelector.searchNextMove(board, maxSearchLevel);
        int elapsed_time_ms = millis() - start_time;
        showStat(elapsed_time_ms, ret);
        return ret;
    }

    void showStat(int elapsed_time_ms, int[] data) {
        char[] int2str = {' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'};
        float elapsed_time = elapsed_time_ms / 1000.0;
        float time_per_eval = 1000.0 * elapsed_time_ms / data[3];
        println("Put:" + int2str[data[0]] + data[1] +
                " Eval:" + data[2] +
                " (level:" + maxSearchLevel +
                " num:" + data[3] +
                " time:" + elapsed_time +
                " tpe:" + time_per_eval + " us)");
    }
}
