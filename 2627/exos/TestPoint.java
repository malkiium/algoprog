public class TestPoint {
    public static void main(String[] args) {

        Point p = new Point(3, -4);
        Point q = new Point(1, 2);

        System.out.println("p = " + p);
        System.out.println("x = " + p.getX() + ", y = " + p.getY());
        System.out.println("Distance entre p et q = " + p.distance(q));

        p.translation(2, 5);
        System.out.println("Après translation : " + p);
    }
}