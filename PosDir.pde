static class PosDir {
    int x, y;
    PosDir(int init_x, int init_y) {
        x = init_x;
        y = init_y;
    }

    PosDir(PosDir pos) {
        x = pos.x;
        y = pos.y;
    }

    static PosDir add(PosDir a, PosDir b) {
        return new PosDir(a.x + b.x, a.y + b.y);
    }

    static PosDir mul(PosDir a, int c) {
        return new PosDir(c * a.x, c * a.y);
    }

    PosDir add(PosDir pos) {
        x += pos.x;
        y += pos.y;
        return this;
    }
}
