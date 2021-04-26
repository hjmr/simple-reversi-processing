Stone s = new Stone();
Board b = new Board();
Position p = new Position(5,3);

println(b);
b.putStoneAt(s.BLACK, p);
b.reverseStonesFrom(p);
println(b);
