public class Point {

    private double x, y;

    Point(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public double getX() {
        return this.x;
    }

    public double getY() {
        return this.y;
    }

    public void setX(double abs) {
        this.x = abs;
    }

    public void setY(double ord) {
        this.y = ord;
    }

    @Override
    public String toString() {
        return "Point(" + x + ", " + y + ")";
    }

    void xy() {
        System.out.println("Abscisse : " + x + " ; Ordonnée : " + y);
    }

    double distance(Point p) {
        return Math.sqrt(
            (this.x - p.getX()) * (this.x - p.getX())
            + (this.y - p.getY()) * (this.y - p.getY())
        );
    }

    void translation(double x1, double y1) {
        this.x += x1;
        this.y += y1;
    }
}