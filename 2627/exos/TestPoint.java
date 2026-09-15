public class TestPoint {
    public static void main(String[] args) {

        Point p1 = new Point(3, 4);
        Point p2 = new Point(6, 8);

        p1.xy();

        System.out.println(p1.getX());
        System.out.println(p1.getY());

        System.out.println(p1.distance(p2));

        p1.translation(10, 20);
        p1.xy();
    }
}