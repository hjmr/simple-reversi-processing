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
        if( board.countBlank() < 12 ) {
            actionSelector = new Minimax(new FinalEvaluator(), myStone);
        }
        return actionSelector.searchNextMove(board, maxSearchLevel);
    }
}
