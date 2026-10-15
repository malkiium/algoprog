public class ListeChainee {

  private Cellule tete;
  private Cellule queue;
  private Cellule courant;

  public ListeChainee() {
    this.tete = null;
    this.queue = null;
    this.courant = null;
  }

  public ListeChainee(Cellule tete) {
    this.tete = tete;
    this.courant = tete;
    this.queue = tete;

    while (this.queue != null &&
      this.queue.getSuivant() != null) {
        this.queue = this.queue.getSuivant();
      }
    }

  public boolean estVide() {
    return this.tete == null;
  }

  public Cellule getTete() {
    return this.tete;
  }

  public Cellule getQueue() {
    return this.queue;
  }

  public Cellule getCourant() {
    return this.courant;
  }

  public void razCourant() {
    this.courant = this.tete;
  }

  public void suivant() {
    if (this.courant != null) {
      this.courant = this.courant.getSuivant();
    }
  }

}
