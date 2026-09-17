import java.util.Scanner;

//-//-//-//-//-//-//-//-//

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
        System.out.print("Numero " + (i + 1) + " : ");
        lesNumeros[i] = sc.nextInt();
    }
  }

  public void initAleatoire() {
    int i = 0;

    while (i < taille) {
        int nombre = (int)(Math.random() * MAX_GRILLE) + 1;
        int j = 0;

        while (j < i && lesNumeros[j] != nombre) {
            j++;
        }

        if (j == i) {
            lesNumeros[i] = nombre;
            i++;
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
}
