static class Position {
    int x, y;
    Position(int init_x, int init_y) {
        x = init_x;
        y = init_y;
    }

    Position(Position pos) {
        x = pos.x;
        y = pos.y;
    }

    static Position add(Position a, Position b) {
        return new Position(a.x + b.x, a.y + b.y);
    }

    static Position mul(Position a, int c) {
        return new Position(c * a.x, c * a.y);
    }

    Position add(Position pos) {
        x += pos.x;
        y += pos.y;
        return this;
    }
}
