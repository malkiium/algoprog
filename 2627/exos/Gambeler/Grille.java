import java.util.Scanner;


public class Grille {
  public final int TAILLE_GRILLE = 6;
  public final int MAX_GRILLE = 49;
  private int[] lesNumeros;
  private int taille;

  public Grille() {
    this.taille = TAILLE_GRILLE;
    this.lesNumeros = new int[MAX_GRILLE];
  }

  public Grille(int taille) {
    this.taille = taille;
    this.lesNumeros = new int[MAX_GRILLE];
  }

  public Grille(Grille g) {
    this.taille = g.taille;
    this.lesNumeros = new int[MAX_GRILLE];

    for (int i = 0; i < taille; i++) {
        this.lesNumeros[i] = g.lesNumeros[i];
    }
  }
  public int getLeNumero(int position) {
    return lesNumeros[position];
  }

  public int[] getLesNumeros() {
    return lesNumeros;
  }

  public int getTaille() {
    return taille;
  }

  public void setLeNumero(int pos, int val) {
    lesNumeros[pos] = val;
  }

  public void setTaille(int taille) {
    this.taille = taille;
  }

  public String toString() {
    String total = "";
    for (int i=0; i<(taille-1); i++) {
      total += lesNumeros[i] + " ";
    }
    total += lesNumeros[taille-1];
    
    return "Grile : \n" +total;
  }

  public void initInteractif() {
  Scanner sc = new Scanner(System.in);

    for (int i = 0; i < taille; i++) {
      boolean ok = false;
      while (!ok) {
        System.out.print("Numero " + (i + 1) + " : ");
        if (!sc.hasNextInt()) {
          System.out.println("Entre un nombre stp");
          sc.next();
          continue;
        }
        int nombre = sc.nextInt();
        if (nombre < 1 || nombre > MAX_GRILLE) {
          System.out.println("Le nombre doit etre entre 1 et 49");
          continue;
        }
        boolean dejaLa = false;
        for (int j = 0; j < i; j++) {
          if (lesNumeros[j] == nombre) {
            dejaLa = true;
          }
        }
        if (dejaLa) {
          System.out.println("Ce numero est deja dans la grille");
          continue;
        }
        lesNumeros[i] = nombre;
        ok = true;
      }
    }
  }  

  public void initAleatoire() {
    int nombre;
    boolean dejaLa;
    for (int i = 0; i < taille; i++) {
      dejaLa = false;
      nombre = (int)(Math.random() * MAX_GRILLE) + 1;

      for (int j = 0; j < i; j++) {
        if (lesNumeros[j] == nombre) {
          dejaLa = true;
        }
      }

      if (dejaLa) {
        i--;
      } else {
        lesNumeros[i] = nombre;
      }
    }
  }

  public int compare(Grille g) {
    int nb = 0;

    for (int i = 0; i < this.taille; i++) {
        for (int j = 0; j < g.taille; j++) {
            if (this.lesNumeros[i] == g.lesNumeros[j]) {
                nb++;
            }
        }
    }
    return nb;
  }

  public void tri() {
    for (int fin = taille - 1; fin > 0; fin--) {
        int posMax = 0;

        for (int i = 1; i <= fin; i++) {
            if (lesNumeros[i] > lesNumeros[posMax]) {
                posMax = i;
            }
        }

        int temp = lesNumeros[fin];
        lesNumeros[fin] = lesNumeros[posMax];
        lesNumeros[posMax] = temp;
    }
  }

  public int compareMieux(Grille g) {
    int i = 0;
    int j = 0;
    int nb = 0;

    while (i < this.taille && j < g.taille) {
        if (this.lesNumeros[i] == g.lesNumeros[j]) {
            nb++;
            i++;
            j++;
        } else if (this.lesNumeros[i] < g.lesNumeros[j]) {
            i++;
        } else {
            j++;
        }
    }
    return nb;
  }
}
