public class Stone {
    int BLACK = 0;
    int WHITE = 1;
    int reverseStone(int stone) {
        return (stone == BLACK) ? WHITE : BLACK;
    }
}
