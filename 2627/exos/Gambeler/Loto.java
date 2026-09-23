public class Loto {
  public static void main(String[] args) { 
    Grille g1 = new Grille(); 
    Grille g2 = new Grille(10);
    
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
    g2.tri();
    
    System.out.println("g1: "+g1); 
    System.out.println("g2: "+g2); 
    System.out.println("g3: "+g3); 

    long debut = System.nanoTime();
    int nb = g1.compare(g3);
    long fin = System.nanoTime();

    long tempsCompare = fin - debut;

    debut = System.nanoTime();
    int nbMieux = g1.compareMieux(g3);
    fin = System.nanoTime();

    long tempsCompareMieux = fin - debut;

    System.out.println("compare : " + nb);
    System.out.println("temps : " + tempsCompare + " ns");

    System.out.println("compareMieux : " + nbMieux);
    System.out.println("temps : " + tempsCompareMieux + " ns");

    if (tempsCompareMieux > 0) {
      double foisMieux = (double) tempsCompare / tempsCompareMieux;
      System.out.println("compareMieux est environ " + foisMieux + " fois plus rapide");
    }
  }
}
