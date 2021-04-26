static class Stone {
    static int BLACK = 0;
    static int WHITE = 1;
    static int reverseStone(int stone) {
        return (stone == BLACK) ? WHITE : BLACK;
    }
}
