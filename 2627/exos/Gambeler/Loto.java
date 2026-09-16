public class Loto {
  public static void main(String[] args) { 
    Grille g1 = new Grille(); 
    Grille g2 = new Grille(10); // 10 numéros seront mémorisés 
    g1.setLeNumero(0,1); 
    g1.setLeNumero(1,2); 
    g1.setLeNumero(2,3); 
    Grille g3 = new Grille(g1); 
    System.out.println("g1: "+g1); 
    System.out.println("g2: "+g2); 
    System.out.println("g3: "+g3); 
    g1.setLeNumero(3,4); 
    g3.setLeNumero(4,5); 
    System.out.println("g1: "+g1); 
    System.out.println("g3: "+g3); 
    g1.initAleatoire(); 
    g1.tri(); 
    g3.initAleatoire(); 
    g3.tri(); 
    g2.initInteractif(); 
    System.out.println("g1: "+g1); 
    System.out.println("g2: "+g2); 
    System.out.println("g3: "+g3); 
    int nb = g1.compare(g3); 
    System.out.println(nb);
  }
}
