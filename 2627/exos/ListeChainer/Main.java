

public class Main {
  public static void main(String[] args) {

    // creation d'une liste vide
    System.out.println("Creation d'une liste vide");
    ListeChainee lc = new ListeChainee();

    System.out.println("Affichage de la liste vide");
    System.out.println("lc : " + lc);

    // utilisation des arguments du programme
    System.out.println("initialisation avec ajouteTete");
    int i = 0;
    while (i < args.length) {
      lc.ajouteTete(args[i]);
      i++;
    }

    System.out.println("Affichage de la liste obtenue");
    System.out.println("lc : " + lc);

    // creation d'une deuxieme liste vide
    System.out.println("Creation d'une autre liste vide");
    ListeChainee lc2 = new ListeChainee();

    System.out.println("initialisation avec ajouteQueue");
    i = 0;
    while (i < args.length) {
      // lc2.ajouteQueue(args[i]);
      i++;
    }

    System.out.println("Affichage de la liste obtenue");
    System.out.println("lc2 : " + lc2);

    // creation d'une troisieme liste a partir de la tete de lc2
    System.out.println("Creation d'une autre liste");
    ListeChainee lc3 = new ListeChainee(lc2.getTete());

    System.out.println("Affichage de la liste obtenue");
    System.out.println("lc3 : " + lc3);

    // retrait de la tete de lc
    lc.retireTete();
    System.out.println("Affichage de lc apres retrait de lc.tete");
    System.out.println("lc : " + lc);
    System.out.println();

    // retrait de la queue de lc2
    // lc2.retireQueue();

    System.out.println("Affichage de lc2 et lc3 apres retrait de lc2.queue");
    System.out.println("lc2 : " + lc2);
    System.out.println("lc3 : " + lc3);
    System.out.println();

    // retrait de la 3eme cellule de lc3
    // A ecrire lorsque retireCourant() sera implementee
  }
}
